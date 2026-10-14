
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class Bai02BTHD extends StatefulWidget {
  const Bai02BTHD({super.key});

  @override
  State<Bai02BTHD> createState() => _Bai02BTHDState();
}

class _Bai02BTHDState extends State<Bai02BTHD> {
  final MapController _mapController = MapController();

  final TextEditingController _startController =
      TextEditingController(text: '10.7729, 106.6597');

  final TextEditingController _endController =
      TextEditingController(text: '10.7769, 106.7009');

  LatLng? _startLatLng;
  LatLng? _endLatLng;

  List<LatLng> _routePoints = [];
  bool _isLoading = false;
  String? _routeInfo;

  static const LatLng _initialPosition =
      LatLng(10.7769, 106.7009);

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // Chuyển chuỗi "lat, lng" thành tọa độ.
  LatLng? _parseCoordinate(String input) {
    final parts = input.split(',');

    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90) return null;
    if (lng < -180 || lng > 180) return null;

    return LatLng(lat, lng);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Gọi OSRM để tìm đường theo mạng lưới đường phố.
  Future<void> _findRoute() async {
    if (_isLoading) return;

    final start = _parseCoordinate(_startController.text);
    final end = _parseCoordinate(_endController.text);

    if (start == null || end == null) {
      _showMessage(
        'Vui lòng nhập đúng tọa độ: vĩ độ, kinh độ',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _startLatLng = start;
      _endLatLng = end;
      _routePoints = [];
      _routeInfo = null;
    });

    try {
      // OSRM yêu cầu thứ tự kinh độ, vĩ độ.
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
        throw Exception(
          'Máy chủ trả về lỗi ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body)
          as Map<String, dynamic>;

      if (data['code'] != 'Ok') {
        throw Exception('Không tìm thấy tuyến đường');
      }

      final routes = data['routes'] as List<dynamic>;

      if (routes.isEmpty) {
        throw Exception('Không có tuyến đường phù hợp');
      }

      final route = routes.first as Map<String, dynamic>;
      final geometry =
          route['geometry'] as Map<String, dynamic>;

      final coordinates =
          geometry['coordinates'] as List<dynamic>;

      final points = coordinates.map((coordinate) {
        final values = coordinate as List<dynamic>;

        // GeoJSON trả về [longitude, latitude].
        return LatLng(
          (values[1] as num).toDouble(),
          (values[0] as num).toDouble(),
        );
      }).toList();

      if (points.isEmpty) {
        throw Exception('Tuyến đường không có tọa độ');
      }

      final distance =
          (route['distance'] as num).toDouble() / 1000;

      final duration =
          (route['duration'] as num).toDouble() / 60;

      if (!mounted) return;

      setState(() {
        _routePoints = points;
        _routeInfo =
            'Quãng đường: ${distance.toStringAsFixed(2)} km'
            '  |  Ước tính: ${duration.toStringAsFixed(0)} phút';
      });

      // Hiển thị toàn bộ tuyến đường trên bản đồ.
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(points),
          padding: const EdgeInsets.all(60),
        ),
      );
    } catch (e) {
      _showMessage('Không tìm được đường đi: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 02 - BTHD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm xuất phát (lat, lng)',
                    prefixIcon: Icon(
                      Icons.trip_origin,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _endController,
                  decoration: const InputDecoration(
                    labelText: 'Điểm đến (lat, lng)',
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        _isLoading ? null : _findRoute,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.route),
                    label: Text(
                      _isLoading
                          ? 'Đang tìm đường...'
                          : 'Tìm đường đi',
                    ),
                  ),
                ),
                if (_routeInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _routeInfo!,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: _initialPosition,
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

                // Vẽ đường đi.
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: Colors.blue,
                        strokeWidth: 5,
                      ),
                    ],
                  ),

                // Đánh dấu điểm đầu và điểm cuối.
                MarkerLayer(
                  markers: [
                    if (_startLatLng != null)
                      Marker(
                        point: _startLatLng!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 45,
                        ),
                      ),
                    if (_endLatLng != null)
                      Marker(
                        point: _endLatLng!,
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
        ],
      ),
    );
  }
}
