import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoUsers extends StatelessWidget {
  final String userName;
  final String userImage;
  final String userLocation;
  final String vehicleName;
  final String vehicleImage;
  final String complaint;

  InfoUsers({
    required this.userName,
    required this.userImage,
    required this.userLocation,
    required this.vehicleName,
    required this.vehicleImage,
    required this.complaint,
  }) {
    print('InfoUsers dibuka dengan data:');
    print('Nama: $userName');
    print('Lokasi: $userLocation');
    print('Kendaraan: $vehicleName');
    print('Keluhan: $complaint');
  }

  @override
  Widget build(BuildContext context) {
    // HTML untuk memuat Leaflet
    final String leafletHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
      </head>
      <body style="margin: 0; padding: 0;">
        <div id="map" style="width: 100%; height: 100vh;"></div>
        <script>
          var map = L.map('map').setView([-6.9745, 107.6302], 15);
          L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
          }).addTo(map);

          // Add a marker
          L.marker([-6.9745, 107.6302]).addTo(map)
            .bindPopup('Lokasi Pengguna')
            .openPopup();
        </script>
      </body>
      </html>
    ''';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Info Pengguna',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Peta lokasi pengguna
            Container(
              height: 300,
              child: WebViewWidget(
                controller: WebViewController()
                  ..loadHtmlString(leafletHtml) // Muat HTML string
                  ..setJavaScriptMode(JavaScriptMode.unrestricted),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informasi pengguna
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(userImage),
                        // onBackgroundImageError: (_, __) {
                        //   print('Error: Gambar $userImage tidak ditemukan');
                        // },
                        // child: Icon(Icons.person, size: 40, color: Colors.grey),
                        radius: 40,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(userLocation),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Detail kendaraan
                  Text(
                    "Detail Kendaraan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        vehicleImage,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 16),
                      Text(
                        vehicleName,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Keluhan pengguna
                  Text(
                    "Keluhan Pengguna",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    complaint,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
