
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class Bai04BTTL extends StatefulWidget {
  const Bai04BTTL({super.key});

  @override
  State<Bai04BTTL> createState() => _Bai04BTTLState();
}

class _Bai04BTTLState extends State<Bai04BTTL> {
  final MapController _mapController = MapController();

  final TextEditingController _startController =
      TextEditingController(text: '10.7729, 106.6597');

  final TextEditingController _endController =
      TextEditingController(text: '10.7769, 106.7009');

  static const LatLng _initialPosition =
      LatLng(10.7769, 106.7009);

  LatLng? _start;
  LatLng? _end;
  List<LatLng> _route = [];

  List<Map<String, dynamic>> _places = [];
  String _placeType = 'restaurant';
  String? _routeInfo;
  bool _loading = false;

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  LatLng? _parseCoordinate(String value) {
    final parts = value.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90) return null;
    if (lng < -180 || lng > 180) return null;

    return LatLng(lat, lng);
  }

  String _formatCoordinate(LatLng point) {
    return '${point.latitude.toStringAsFixed(6)}, '
        '${point.longitude.toStringAsFixed(6)}';
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Nhấp vào bản đồ để chọn điểm đến.
  void _selectDestination(LatLng point) {
    setState(() {
      _end = point;
      _endController.text = _formatCoordinate(point);
      _route = [];
      _routeInfo = null;
    });
  }

  // Lấy vị trí hiện tại làm điểm đích.
  Future<void> _useCurrentLocation() async {
    if (Platform.isWindows) {
      _showMessage(
        'GPS qua geolocator chưa hỗ trợ Windows. '
        'Hãy nhấp vào bản đồ để chọn điểm đích.',
      );
      return;
    }

    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        _showMessage('Vui lòng bật dịch vụ vị trí!');
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Chưa được cấp quyền vị trí!');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      _selectDestination(point);
      _mapController.move(point, 15);
    } catch (e) {
      _showMessage('Không lấy được vị trí: $e');
    }
  }

  // Tìm đường bằng OSRM.
  Future<void> _findRoute() async {
    if (_loading) return;

    final start = _parseCoordinate(_startController.text);
    final end = _parseCoordinate(_endController.text);

    if (start == null || end == null) {
      _showMessage('Tọa độ không hợp lệ!');
      return;
    }

    setState(() {
      _loading = true;
      _start = start;
      _end = end;
      _route = [];
      _routeInfo = null;
    });

    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['code'] != 'Ok' ||
          (data['routes'] as List).isEmpty) {
        throw Exception('Không tìm thấy tuyến đường');
      }

      final route = data['routes'][0];
      final coordinates =
          route['geometry']['coordinates'] as List;

      final points = coordinates.map<LatLng>((value) {
        return LatLng(
          (value[1] as num).toDouble(),
          (value[0] as num).toDouble(),
        );
      }).toList();

      final distance =
          (route['distance'] as num).toDouble() / 1000;
      final duration =
          (route['duration'] as num).toDouble() / 60;

      if (!mounted) return;

      setState(() {
        _route = points;
        _routeInfo =
            'Khoảng cách: ${distance.toStringAsFixed(2)} km'
            ' | Thời gian: ${duration.toStringAsFixed(0)} phút';
      });

      if (points.isNotEmpty) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(points),
            padding: const EdgeInsets.all(60),
          ),
        );
      }
    } catch (e) {
      _showMessage('Lỗi tìm đường: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // Tìm địa điểm xung quanh qua Overpass API.
  Future<void> _searchPlaces() async {
    if (_loading) return;

    final center =
        _parseCoordinate(_startController.text) ??
        _initialPosition;

    setState(() => _loading = true);

    try {
      final query = '''
[out:json][timeout:20];
(
  node["amenity"="$_placeType"]
    (around:2000,${center.latitude},${center.longitude});
  way["amenity"="$_placeType"]
    (around:2000,${center.latitude},${center.longitude});
  node["tourism"="$_placeType"]
    (around:2000,${center.latitude},${center.longitude});
  way["tourism"="$_placeType"]
    (around:2000,${center.latitude},${center.longitude});
);
out center 50;
''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {
          'Content-Type':
              'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {'data': query},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final elements = data['elements'] as List;

      final results = <Map<String, dynamic>>[];

      for (final item in elements) {
        final lat = item['lat'] ?? item['center']?['lat'];
        final lon = item['lon'] ?? item['center']?['lon'];

        if (lat == null || lon == null) continue;

        results.add({
          'name': item['tags']?['name'] ??
              'Địa điểm chưa có tên',
          'point': LatLng(
            (lat as num).toDouble(),
            (lon as num).toDouble(),
          ),
        });
      }

      if (!mounted) return;

      setState(() => _places = results);

      _mapController.move(center, 14);

      _showMessage(
        'Tìm thấy ${results.length} địa điểm.',
      );
    } catch (e) {
      _showMessage('Lỗi tìm địa điểm: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 04 - BTTL'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm xuất phát (lat, lng)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm đích (lat, lng)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          _loading ? null : _findRoute,
                      icon: const Icon(Icons.route),
                      label: const Text('Tìm đường'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _useCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text(
                        'Vị trí hiện tại làm đích',
                      ),
                    ),
                  ],
                ),
                if (_routeInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(_routeInfo!),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _placeType,
                        decoration: const InputDecoration(
                          labelText: 'Loại địa điểm',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'restaurant',
                            child: Text('Quán ăn'),
                          ),
                          DropdownMenuItem(
                            value: 'hospital',
                            child: Text('Bệnh viện'),
                          ),
                          DropdownMenuItem(
                            value: 'school',
                            child: Text('Trường học'),
                          ),
                          DropdownMenuItem(
                            value: 'hotel',
                            child: Text('Khách sạn'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _placeType = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed:
                          _loading ? null : _searchPlaces,
                      child: const Text('Tìm địa điểm'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nhấp trên bản đồ để chọn điểm đích.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialPosition,
                initialZoom: 13,
                onTap: (_, point) =>
                    _selectDestination(point),
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
                    ..._places.map((place) {
                      return Marker(
                        point: place['point'] as LatLng,
                        width: 35,
                        height: 35,
                        child: Tooltip(
                          message: place['name'] as String,
                          child: const Icon(
                            Icons.place,
                            color: Colors.orange,
                            size: 30,
                          ),
                        ),
                      );
                    }),
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
        ],
      ),
    );
  }
}
