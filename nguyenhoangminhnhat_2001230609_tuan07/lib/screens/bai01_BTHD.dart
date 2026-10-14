
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Bai01BTHD extends StatefulWidget {
  const Bai01BTHD({super.key});

  @override
  State<Bai01BTHD> createState() => _Bai01BTHDState();
}

class _Bai01BTHDState extends State<Bai01BTHD> {
  final MapController _mapController = MapController();

  static const LatLng _initialPosition =
      LatLng(10.7769, 106.7009);

  LatLng? _currentPosition;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage('Vui lòng bật dịch vụ vị trí!');
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('Bạn chưa cấp quyền vị trí!');
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        _showMessage(
          'Quyền vị trí đã bị từ chối vĩnh viễn. '
          'Hãy bật lại trong Cài đặt.',
        );
        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final LatLng location = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = location;
      });

      _mapController.move(location, 16);
    } catch (e) {
      _showMessage('Không lấy được vị trí: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Navigator - Bài 1'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.example.bai07_chuong4_multimedia',
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  width: 90,
                  height: 90,
                  child: const Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 45,
                      ),
                      Text(
                        'Bạn ở đây',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _loading ? null : _getCurrentLocation,
        tooltip: 'Lấy vị trí hiện tại',
        child: _loading
            ? const CircularProgressIndicator()
            : const Icon(Icons.my_location),
      ),
    );
  }
}
