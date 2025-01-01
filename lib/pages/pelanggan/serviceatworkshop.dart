import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ServiceAtWorkshopPage extends StatefulWidget {
  @override
  _ServiceAtWorkshopPageState createState() => _ServiceAtWorkshopPageState();
}

class _ServiceAtWorkshopPageState extends State<ServiceAtWorkshopPage> {
  LatLng _currentLocation = LatLng(-6.9175, 107.6191); // Default: Bandung
  bool _locationLoaded = false;
  LatLng? _selectedWorkshop;

  final List<LatLng> _workshops = [
    LatLng(-6.974324, 107.629115), // Bengkel Ajwa
    LatLng(-6.975435, 107.633245), // Tambal Ban Sukapura
    LatLng(-6.979642, 107.636872), // Bengkel Jaya Motor
  ];

  final List<String> _workshopNames = [
    "Bengkel Ajwa",
    "Tambal Ban Sukapura",
    "Bengkel Jaya Motor",
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Minta izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Ambil lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _locationLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Bengkel")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 15,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedWorkshop = null; // Reset pilihan saat peta diklik
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              
            ],
          ),
          if (_selectedWorkshop != null) ...[
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Bengkel yang Dipilih:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _workshopNames[_workshops.indexOf(_selectedWorkshop!)],
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _selectedWorkshop == null
                  ? null
                  : () {
                      print(
                          "Konfirmasi reservasi di: ${_workshopNames[_workshops.indexOf(_selectedWorkshop!)]}");
                      // Navigasi atau tindakan konfirmasi
                    },
              child: Text("Konfirmasi Lokasi"),
            ),
          ),
        ],
      ),
    );
  }
}
