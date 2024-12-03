import 'package:flutter/material.dart';

class LupaPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff071327),
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 20.0, top: 20),
      //     child: IconButton(
      //       icon: Icon(Icons.arrow_back),
      //       color: Colors.white,
      //       onPressed: () {
      //         Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      //       },
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup halaman
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Color(0xFF00171F),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Lupa Password?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Tenang, gausah panik. Masukan email yang terdaftar untuk ganti password kamu.",
                style: TextStyle(
                    color: Color(0xff797979),
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                'Email',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff797979),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                // controller: _emailController,
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Color(0xff071327),
                  hintText: 'Masukkan email anda',
                  hintStyle: TextStyle(
                      color: Color(0xff797979),
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Color(0xff465060)),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi yang akan dijalankan saat tombol "Next" ditekan
                    Navigator.pushNamed(context, '/newpassword');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff007EA7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
