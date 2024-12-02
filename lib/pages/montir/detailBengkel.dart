import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBengkel extends StatelessWidget {
  final String bengkelName = "Bengkel StarInk";
  final double latitude = -6.97479;
  final double longitude = 107.63492;

  void _openGoogleMaps() async {
    String googleMapUrl = '';
    // Jika platform lain, gunakan URL web sebagai fallback
    googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('$latitude,$longitude')}';
    final Uri uri = Uri.parse(googleMapUrl);

    try {
      // Langsung mencoba meluncurkan URL tanpa canLaunchUrl
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Jika gagal, tampilkan pesan kesalahan
      print("Error: $e");
      // Anda dapat menggunakan SnackBar atau dialog untuk memberitahu pengguna
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tidak dapat membuka peta')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail bengkel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Bengkel
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/bengkel.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              // Nama Bengkel dan Detail Lokasi
              Text(
                'Bengkel motor',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Bengkel StarInk',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Jl. Telekomunikasi No. 203 - Bojongsoang, Bandung',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text(
                    '4.5',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(' (10 Ulasan)', style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 16),
              // Tombol "Lihat di Peta"
              ElevatedButton.icon(
                onPressed: _openGoogleMaps,
                icon: Icon(Icons.map, color: Colors.blue),
                label: Text('Lihat di peta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              // Tentang Bengkel
              Text(
                'Tentang bengkel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Bengkel StarInk menawarkan anda servis bengkel yang maksimal dari ahlinya. Anda akan disuguhkan dengan berbagai kenyamanan dari kami saat servis berlangsung.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              // Fasilitas
              Text(
                'Fasilitas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.tv, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Televisi'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.battery_charging_full, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Isi daya elektronik'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.chair, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Area Nongkrong'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
