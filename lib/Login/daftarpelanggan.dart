import 'package:flutter/material.dart';
// import 'package:mindmend_ui/bottomNavbar.dart';
import 'verifemail.dart';
import 'dart:async';

class DaftarPelanggan extends StatefulWidget {
  @override
  _DaftarPelangganState createState() => _DaftarPelangganState();
}

class _DaftarPelangganState extends State<DaftarPelanggan> {
  // Boolean untuk menentukan apakah password sedang ditampilkan atau disembunyikan
  bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                  icon: const Icon(Icons.close),
                  color: Color(0xFF00171F),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Daftar Menjadi Pelanggan',
                style: TextStyle(
                    color: Color(0xFF00171F),
                    fontSize: 21,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Mari mulai dengan data pribadimu.',
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
                'Nama Pengguna',
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
                decoration: InputDecoration(
                  hintText: 'Masukkan nama anda',
                  hintStyle: TextStyle(
                    color: Color(0xff797979),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Color(0xffEEEEEE)), // Default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xff4483F7), width: 2.0), // Fokus border
                  ),
                ),
                style: TextStyle(color: Colors.black),
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
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Masukkan email anda',
                  hintStyle: TextStyle(
                    color: Color(0xff797979),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: Color(0xffEEEEEE)), // Default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xff4483F7), width: 2.0), // Fokus border
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                'Password',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // Teks menjadi titik-titik
                    decoration: InputDecoration(
                      hintText: 'Masukkan password anda',
                      hintStyle: TextStyle(
                        color: Color(0xff797979),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Color(0xffEEEEEE)), // Default border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Color(0xff4483F7),
                            width: 2.0), // Fokus border
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            // Ketika tombol ditekan, perbarui nilai boolean
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Password harus minimal 8 karakter.',
                    style: TextStyle(
                      color: Color(0xff969696), // Warna merah untuk menonjolkan
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    // Periksa apakah email dan password kosong
                    if (_isEmailAndPasswordEmpty()) {
                      // Jika kosong, tampilkan popup "Login Failed"
                      _showLoginFailedDialog(context);
                    } else {
                      // Jika tidak kosong, lanjutkan login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifEmail(),
                        ),
                      );
                    }
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
                        'Selanjutnya',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
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

  // Fungsi untuk memeriksa apakah email dan password kosong
  bool _isEmailAndPasswordEmpty() {
    // Periksa apakah email atau password kosong
    return _emailController.text.isEmpty || _passwordController.text.isEmpty;
  }

  // Fungsi untuk melakukan login
  // void _login() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => BottomNavBar()),
  //   );
  // }

  // Fungsi untuk menampilkan popup "Login Failed"
  Future<void> _showLoginFailedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // User harus menekan tombol untuk menutup dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Daftar Gagal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Email dan/atau password tidak boleh kosong.',
                  style: TextStyle(color: Color(0xFF797979)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF007EA7)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}
