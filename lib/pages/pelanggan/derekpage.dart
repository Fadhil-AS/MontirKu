import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TowPage extends StatefulWidget {
  @override
  _TowPageState createState() => _TowPageState();
}

class _TowPageState extends State<TowPage> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;

  final List<Map<String, dynamic>> towOptions = [
    {
      'type': 'Small',
      'price': 'Rp100,000',
      'details': 'Small tow truck, suitable for compact cars.',
      'image': 'assets/images/small_tow.jpg',
    },
    {
      'type': 'Medium',
      'price': 'Rp150,000',
      'details': 'Medium tow truck for mid-size vehicles.',
      'image': 'assets/images/medium_tow.jpg',
    },
    {
      'type': 'Large',
      'price': 'Rp200,000',
      'details': 'Large tow truck for heavy vehicles.',
      'image': 'assets/images/large_tow.jpg',
    },
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Derek'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition ?? LatLng(0, 0),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          tabs: towOptions.map((option) {
                            return Tab(text: option['type']);
                          }).toList(),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                towOptions[selectedIndex]['image'],
                                height: 100,
                              ),
                              Text(
                                towOptions[selectedIndex]['details'],
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                towOptions[selectedIndex]['price'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Konfirmasi Derek Berhasil!'),
                              ),
                            );
                          },
                          child: Text('Konfirmasi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
