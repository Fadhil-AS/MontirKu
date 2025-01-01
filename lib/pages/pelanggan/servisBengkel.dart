import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServisBengkel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // HTML untuk memuat Leaflet
    final String leafletHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
        <style>
          #map {
            height: 100vh; /* Pastikan peta mengambil tinggi penuh layar */
            margin: 0;
          }
          body {
            padding: 0;
            margin: 0;
          }
        </style>
      </head>
      <body>
        <div id="map"></div>
        <script>
          var map = L.map('map').setView([-6.9745, 107.6302], 15); // Atur lokasi awal
          L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© OpenStreetMap contributors'
          }).addTo(map);

          // Tambahkan marker
          L.marker([-6.9745, 107.6302]).addTo(map)
            .bindPopup('Bengkel Ajwa')
            .openPopup();
        </script>
      </body>
      </html>
    ''';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Peta
          Expanded(
            child: WebViewWidget(
              controller: WebViewController()
                ..loadHtmlString(leafletHtml) // Muat HTML
                ..setJavaScriptMode(JavaScriptMode.unrestricted) // Aktifkan JavaScript
                ..setBackgroundColor(const Color(0x00000000)), // Latar belakang transparan
            ),
          ),
          // Kontainer dengan daftar bengkel
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom pencarian
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Cari bengkel",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Daftar bengkel
                  Text(
                    "Bengkel terdekat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // ListView dengan ikon
                  Expanded(
                    child: ListView(
                      children: [
                        _buildWorkshopItem(
                          context,
                          "Bengkel Ajwa",
                          "Jl. Telekomunikasi No. 203, Bojongsoang, Bandung",
                          Icons.build, // Ikon untuk bengkel
                        ),
                        _buildWorkshopItem(
                          context,
                          "Tambal Ban Sukapura",
                          "Jl. Sukapura No. 69, Dayeuhkolot, Bandung",
                          Icons.handyman, // Ikon untuk tambal ban
                        ),
                        _buildWorkshopItem(
                          context,
                          "Bengkel Jaya Motor",
                          "Jl. Raya Bojongsoang No. 50, Bojongsoang, Bandung",
                          Icons.car_repair, // Ikon untuk bengkel mobil
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopItem(
    BuildContext context,
    String name,
    String address,
    IconData icon, // Parameter untuk ikon
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.blue[100],
        child: Icon(icon, color: Colors.blue, size: 30), // Ikon untuk bengkel
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(address),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print("Navigasi ke detail $name");
      },
    );
  }
}
