import 'package:flutter/material.dart';
import 'package:montirku/pages/Login/daftarpelanggan.dart';

class PilihDaftar extends StatelessWidget {
  const PilihDaftar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEF9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.05, left: screenWidth * 0.05),
            child: Row(
              children: [
                Icon(
                  Icons.build_rounded,
                  size: 25,
                  color: const Color(0xFF007EA7),
                ),
                SizedBox(
                  width: screenWidth * 0.03,
                ),
                Text(
                  'MontirKu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00171F),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.build_rounded,
                  size: 50,
                  color: const Color(0xFF007EA7),
                ),
                // Container(
                //   width: screenWidth * 0.6,
                //   height: screenHeight * 0.3,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('assets/car.png'),
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.02),
                // Teks di bawah gambar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Servis kendaraanmu kapanpun, dimanapun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF00171F),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Container dengan radius dan tombol
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02, horizontal: screenWidth * 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup halaman
                    },
                    icon: const Icon(Icons.close),
                    color: Color(0xFF00171F),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarPelanggan(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Color(0xFF007EA7),
                    ),
                    child: const Text('Daftar Pelanggan',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk daftar
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Color(0xFF007EA7),
                    ),
                    child: const Text('Daftar Montir',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk daftar
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Color(0xFF007EA7),
                    ),
                    child: const Text('Daftar Pelanggan',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
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
