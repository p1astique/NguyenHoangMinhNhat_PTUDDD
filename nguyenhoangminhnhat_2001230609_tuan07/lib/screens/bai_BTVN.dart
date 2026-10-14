
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BaiBTVN extends StatefulWidget {
  const BaiBTVN({super.key});

  @override
  State<BaiBTVN> createState() => _BaiBTVNState();
}

class _BaiBTVNState extends State<BaiBTVN> {
  final MapController _map = MapController();

  final _from = TextEditingController(
    text: 'Đại học Bách Khoa, Quận 10, Hồ Chí Minh',
  );

  final _to = TextEditingController(
    text: 'Chợ Bến Thành, Hồ Chí Minh',
  );

  static const _initial = LatLng(10.7769, 106.7009);

  Database? _db;
  LatLng? _start;
  LatLng? _end;
  List<LatLng> _route = [];
  List<Map<String, Object?>> _favorites = [];

  String _vehicle = 'auto';
  String _info = '';
  bool _loading = false;

  final Map<String, String> _vehicles = const {
    'auto': 'Ô tô',
    'motor_scooter': 'Xe máy',
    'pedestrian': 'Đi bộ',
  };

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final folder = await getDatabasesPath();
      final db = await openDatabase(
        p.join(folder, 'bai07_routes.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE favorites (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              from_address TEXT NOT NULL,
              to_address TEXT NOT NULL,
              vehicle TEXT NOT NULL,
              start_lat REAL NOT NULL,
              start_lng REAL NOT NULL,
              end_lat REAL NOT NULL,
              end_lng REAL NOT NULL,
              route_json TEXT NOT NULL,
              distance_km REAL NOT NULL,
              duration_min REAL NOT NULL
            )
          ''');
        },
      );

      if (!mounted) {
        await db.close();
        return;
      }

      _db = db;
      await _loadFavorites();
    } catch (e) {
      _message('Không mở được SQLite: $e');
    }
  }

  Future<void> _loadFavorites() async {
    final db = _db;
    if (db == null) return;

    final rows = await db.query(
      'favorites',
      orderBy: 'id DESC',
    );

    if (mounted) {
      setState(() => _favorites = rows);
    }
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  // Tìm địa chỉ chữ bằng Nominatim.
  Future<LatLng> _geocode(String address) async {
    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'q': address,
        'format': 'jsonv2',
        'limit': '1',
        'countrycodes': 'vn',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'FlutterWeek07StudentExercise/1.0 '
            '(educational demo)',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 25));

    if (response.statusCode != 200) {
      throw Exception(
        'Lỗi tìm địa chỉ: HTTP ${response.statusCode}',
      );
    }

    final results = jsonDecode(response.body) as List;

    if (results.isEmpty) {
      throw Exception('Không tìm thấy: $address');
    }

    return LatLng(
      double.parse(results.first['lat'].toString()),
      double.parse(results.first['lon'].toString()),
    );
  }

  // Lấy đường đi bằng Valhalla.
  Future<Map<String, dynamic>> _getRoute(
    LatLng start,
    LatLng end,
    String vehicle,
  ) async {
    final request = {
      'locations': [
        {'lat': start.latitude, 'lon': start.longitude},
        {'lat': end.latitude, 'lon': end.longitude},
      ],
      'costing': vehicle,
      'units': 'kilometers',
      'directions_options': {'units': 'kilometers'},
    };

    final uri = Uri.https(
      'valhalla1.openstreetmap.de',
      '/route',
      {'json': jsonEncode(request)},
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 35),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Dịch vụ định tuyến lỗi HTTP ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body)
        as Map<String, dynamic>;

    if (data['trip'] == null) {
      throw Exception('Không có tuyến đường phù hợp');
    }

    final trip = data['trip'] as Map<String, dynamic>;
    final legs = trip['legs'] as List<dynamic>;

    if (legs.isEmpty) {
      throw Exception('Không có dữ liệu đường đi');
    }

    final points = <LatLng>[];

    for (final leg in legs) {
      final encoded = leg['shape'] as String;
      final decoded = _decodePolyline6(encoded);

      if (points.isNotEmpty && decoded.isNotEmpty) {
        decoded.removeAt(0);
      }

      points.addAll(decoded);
    }

    if (points.isEmpty) {
      throw Exception('Không đọc được hình dạng tuyến đường');
    }

    final summary = trip['summary'] as Map<String, dynamic>;

    return {
      'points': points,
      'distance': (summary['length'] as num).toDouble(),
      'duration': (summary['time'] as num).toDouble() / 60,
    };
  }

  // Valhalla dùng encoded polyline với độ chính xác 1e6.
  List<LatLng> _decodePolyline6(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    int readValue() {
      int result = 0;
      int shift = 0;

      while (true) {
        if (index >= encoded.length) {
          throw const FormatException('Polyline không hợp lệ');
        }

        final value = encoded.codeUnitAt(index++) - 63;

        result |= (value & 0x1f) << shift;

        if (value < 0x20) break;
        shift += 5;
      }

      return (result & 1) != 0
          ? ~(result >> 1)
          : result >> 1;
    }

    while (index < encoded.length) {
      lat += readValue();
      lng += readValue();

      points.add(LatLng(lat / 1e6, lng / 1e6));
    }

    return points;
  }

  void _fitRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    if (points.length == 1) {
      _map.move(points.first, 15);
      return;
    }

    _map.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.all(65),
      ),
    );
  }

  Future<void> _findRoute() async {
    if (_loading) return;

    final fromText = _from.text.trim();
    final toText = _to.text.trim();

    if (fromText.isEmpty || toText.isEmpty) {
      _message('Vui lòng nhập cả hai địa chỉ.');
      return;
    }

    setState(() => _loading = true);

    try {
      final start = await _geocode(fromText);

      // Giãn cách hai yêu cầu tìm địa chỉ để tôn trọng
      // giới hạn của dịch vụ Nominatim công cộng.
      await Future.delayed(const Duration(milliseconds: 1200));

      final end = await _geocode(toText);
      final result = await _getRoute(start, end, _vehicle);

      if (!mounted) return;

      final points = result['points'] as List<LatLng>;
      final distance = result['distance'] as double;
      final duration = result['duration'] as double;

      setState(() {
        _start = start;
        _end = end;
        _route = points;
        _info =
            '${distance.toStringAsFixed(2)} km | '
            '${duration.toStringAsFixed(0)} phút | '
            '${_vehicles[_vehicle]}';
      });

      _fitRoute(points);
    } catch (e) {
      _message('Không tìm được tuyến đường: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveFavorite() async {
    final db = _db;

    if (db == null) {
      _message('SQLite chưa sẵn sàng.');
      return;
    }

    if (_start == null || _end == null || _route.isEmpty) {
      _message('Hãy tìm đường trước khi lưu.');
      return;
    }

    // Lưu chính tuyến đường đang hiển thị.
    final result = await _getRoute(
      _start!,
      _end!,
      _vehicle,
    ).catchError((_) => <String, dynamic>{});

    // Tránh lưu thông tin không đầy đủ.
    if (result.isEmpty) {
      _message('Không xác nhận được dữ liệu tuyến đường.');
      return;
    }

    final points = result['points'] as List<LatLng>;

    await db.insert('favorites', {
      'from_address': _from.text.trim(),
      'to_address': _to.text.trim(),
      'vehicle': _vehicle,
      'start_lat': _start!.latitude,
      'start_lng': _start!.longitude,
      'end_lat': _end!.latitude,
      'end_lng': _end!.longitude,
      'route_json': jsonEncode(
        points.map((e) => [
          e.latitude,
          e.longitude,
        ]).toList(),
      ),
      'distance_km': result['distance'],
      'duration_min': result['duration'],
    });

    await _loadFavorites();
    _message('Đã lưu tuyến đường yêu thích!');
  }

  void _openFavorite(Map<String, Object?> item) {
    final raw = jsonDecode(
      item['route_json'] as String,
    ) as List;

    final points = raw.map<LatLng>((e) {
      return LatLng(
        (e[0] as num).toDouble(),
        (e[1] as num).toDouble(),
      );
    }).toList();

    setState(() {
      _from.text = item['from_address'] as String;
      _to.text = item['to_address'] as String;
      _vehicle = item['vehicle'] as String;

      _start = LatLng(
        (item['start_lat'] as num).toDouble(),
        (item['start_lng'] as num).toDouble(),
      );

      _end = LatLng(
        (item['end_lat'] as num).toDouble(),
        (item['end_lng'] as num).toDouble(),
      );

      _route = points;

      _info =
          '${(item['distance_km'] as num).toStringAsFixed(2)} km'
          ' | ${(item['duration_min'] as num).toStringAsFixed(0)} phút'
          ' | ${_vehicles[_vehicle]}';
    });

    _fitRoute(points);
  }

  Future<void> _deleteFavorite(int id) async {
    final db = _db;
    if (db == null) return;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    await _loadFavorites();
  }

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    _map.dispose();
    _db?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập về nhà - Tuần 07'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _from,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ xuất phát',
                    prefixIcon: Icon(Icons.trip_origin),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _to,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ điểm đến',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _vehicle,
                  decoration: const InputDecoration(
                    labelText: 'Phương tiện di chuyển',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: _vehicles.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _vehicle = value);
                    }
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          _loading ? null : _findRoute,
                      icon: const Icon(Icons.route),
                      label: Text(
                        _loading
                            ? 'Đang tìm...'
                            : 'Tìm đường',
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed:
                          _loading ? null : _saveFavorite,
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Lưu yêu thích'),
                    ),
                  ],
                ),
                if (_info.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _info,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _map,
              options: const MapOptions(
                initialCenter: _initial,
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/'
                      '{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.bai07_chuong4_multimedia',
                ),
                if (_route.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _route,
                        color: Colors.blue,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (_start != null)
                      Marker(
                        point: _start!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 45,
                        ),
                      ),
                    if (_end != null)
                      Marker(
                        point: _end!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 45,
                        ),
                      ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(
              'Tuyến đường yêu thích (${_favorites.length})',
            ),
            leading: const Icon(Icons.favorite),
            children: _favorites.map((item) {
              return ListTile(
                title: Text(
                  '${item['from_address']} → '
                  '${item['to_address']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _vehicles[item['vehicle']] ??
                      'Phương tiện',
                ),
                onTap: () => _openFavorite(item),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Xóa tuyến đường',
                  onPressed: () => _deleteFavorite(
                    item['id'] as int,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
