import 'package:flutter/material.dart';
import 'package:montirku/Pelanggan/keranjangPelanggan.dart';

class BelanjaPelanggan extends StatefulWidget {
  @override
  _BelanjaPelangganState createState() => _BelanjaPelangganState();
}

class _BelanjaPelangganState extends State<BelanjaPelanggan> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Belanja",
          style: TextStyle(color: Colors.black),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Colors.black),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Mau beli apa?",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Promo Banner
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image:
                            NetworkImage('https://via.placeholder.com/400x150'),
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
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Buy now",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    children: [
                      _buildCategoryButton("Oli", Icons.oil_barrel),
                      _buildCategoryButton("Ban", Icons.radio_button_checked),
                      _buildCategoryButton("Aki", Icons.battery_charging_full),
                      _buildCategoryButton("Lampu", Icons.lightbulb),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Penawaran Khusus
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Penawaran khusus",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lihat semua",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildProductCard(
                      image: 'https://via.placeholder.com/100',
                      name: "CVT Yamaha X-ride",
                      price: "Rp1.000.000",
                      discount: "50%",
                      category: "Untuk motor",
                    ),
                    const SizedBox(width: 16),
                    _buildProductCard(
                      image: 'https://via.placeholder.com/100',
                      name: "Ban Michelin Pilot",
                      price: "Rp480.000",
                      discount: "20%",
                      category: "Untuk motor",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Suku Cadang Favorit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Suku cadang favorit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lihat semua",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildProductCard(
                      image: 'https://via.placeholder.com/100',
                      name: "Oli Castrol",
                      price: "Rp120.000",
                      discount: "10%",
                      category: "Untuk motor",
                    ),
                    const SizedBox(width: 16),
                    _buildProductCard(
                      image: 'https://via.placeholder.com/100',
                      name: "Aki GS Astra",
                      price: "Rp550.000",
                      discount: "15%",
                      category: "Untuk motor",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigasi ke halaman sesuai dengan indeks navbar
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BelanjaPelanggan()),
              );
              print("Navigasi ke halaman Eksplor");
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KeranjangPelanggan()),
              );
              print("Navigasi ke halaman Keranjang");
              break;
            case 2:
              // Navigasi ke halaman Wishlist
              print("Navigasi ke halaman Wishlist");
              break;
            case 3:
              // Navigasi ke halaman Transaksi
              print("Navigasi ke halaman Transaksi");
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Eksplor",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Transaksi",
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String image,
    required String name,
    required String price,
    required String discount,
    required String category,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(image, height: 80, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            discount,
            style: const TextStyle(color: Colors.green),
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
