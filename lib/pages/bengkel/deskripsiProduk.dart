import 'package:flutter/material.dart';

class DeskripsiProdukPage extends StatelessWidget {
  final Map<String, dynamic> product;

  DeskripsiProdukPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(product['image']), // Gambar produk
              radius: 20, // Ukuran gambar
            ),
            SizedBox(width: 8), // Spasi antara gambar dan teks
            Expanded(
              child: Text(
                product['name'], // Nama produk
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, // Jika nama terlalu panjang
              ),
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Info produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kondisi'),
                Text('Baru', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kategori'),
                Text(
                  product['category'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Deskripsi produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              product['description'],
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
