import 'package:flutter/material.dart';
import 'package:montirku/pages/pelanggan/belanjaPelanggan.dart';

class KeranjangPelanggan extends StatefulWidget {
  final String idPelanggan; // Tambahkan parameter idPelanggan

  const KeranjangPelanggan({required this.idPelanggan, Key? key})
      : super(key: key);

  @override
  _KeranjangPelangganState createState() => _KeranjangPelangganState();
}

class _KeranjangPelangganState extends State<KeranjangPelanggan> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BelanjaPelanggan(
                        idPelanggan: widget.idPelanggan,
                      )),
            );
          },
        ),
        title: const Text(
          "Keranjang",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 1, // Keranjang sebagai tab aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigasi ke halaman sesuai dengan indeks navbar
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BelanjaPelanggan(
                          idPelanggan: widget.idPelanggan,
                        )),
              );
              print("Navigasi ke halaman Eksplor");
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KeranjangPelanggan(
                          idPelanggan: widget.idPelanggan,
                        )),
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
        selectedItemColor: Color(0xFF007EA7),
        unselectedItemColor: Colors.grey,
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
}
