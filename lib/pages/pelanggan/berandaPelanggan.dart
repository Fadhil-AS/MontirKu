import 'package:flutter/material.dart';
import 'package:montirku/Pelanggan/riwayatPelanggan.dart';

class BerandaPelanggan extends StatefulWidget {
  @override
  _BerandaPelangganState createState() => _BerandaPelangganState();
}

class _BerandaPelangganState extends State<BerandaPelanggan> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Selamat pagi,",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  "User",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "MOTOR",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "X-ride 125",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.add_circle, color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Services Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildServiceButton("Servis", Icons.build),
                  _buildServiceButton("Belanja", Icons.shopping_cart),
                  _buildServiceButton("Derek", Icons.local_shipping),
                ],
              ),
              const SizedBox(height: 16),
              // Promo Card
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://via.placeholder.com/300x150', // Replace with real image URL
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 500,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Discount up to 50%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Min. purchase Rp100.000",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Buy now",
                          style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Riwayat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RiwayatPelanggan()),
                      );
                    },
                    child: const Text(
                      "Lihat semua",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                "Servis kendaraan",
                "7 Nov 2022 · Sedang di servis",
                Colors.yellow,
              ),
              const SizedBox(height: 8),
              _buildHistoryCard(
                "Servis kendaraan",
                "5 Nov 2022 · Servis dibatalkan",
                Colors.red,
              ),
              const SizedBox(height: 8),
              _buildHistoryCard(
                "Servis kendaraan",
                "2 Nov 2022 · Servis berhasil",
                Colors.green,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Warna ikon aktif
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25, // Mengurangi ukuran ikon
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 4), // Mengurangi jarak
        Text(label),
      ],
    );
  }

  Widget _buildHistoryCard(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.check_circle, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
