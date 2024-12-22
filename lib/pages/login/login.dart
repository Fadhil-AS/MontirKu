import 'package:flutter/material.dart';
// import 'package:mindmend_ui/bottomNavbar.dart';
import 'lupapassword.dart';
import 'dart:async';
import 'package:montirku/services/authService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Boolean untuk menentukan apakah password sedang ditampilkan atau disembunyikan
  bool _isPasswordVisible = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

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
                'Masuk',
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
                'Masuk ke MontirKu',
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
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Teks menjadi titik-titik
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
                    borderSide:
                        BorderSide(color: Color(0xffEEEEEE)), // Default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xff4483F7), width: 2.0), // Fokus border
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
            ),
            SizedBox(height: 20),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => LupaPass(),
            //       ),
            //     );
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 30),
            //     child: Text(
            //       'Lupa Password?',
            //       style: TextStyle(
            //           color: Color(0xff007EA7),
            //           fontSize: 14,
            //           fontWeight: FontWeight.normal),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      _showLoginFailedDialog(context);
                    } else {
                      _authService
                          .loginUser(
                        context: context,
                        email: email,
                        password: password,
                      )
                          .catchError((e) {
                        print("Error during loginUser: $e");
                      });
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
                        'Masuk',
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xffECECEC),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Text(
                //     'Atau',
                //     style: TextStyle(color: Color(0xff797979)),
                //   ),
                // ),
                // Expanded(
                //   child: Divider(
                //     color: Color(0xffECECEC),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: 30),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30),
            //   child: SizedBox(
            //     width: screenWidth,
            //     height: screenHeight * 0.06,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // Aksi yang akan dijalankan saat tombol "Login" ditekan
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(16.0),
            //           side: BorderSide(color: Color(0xffEEEEEE), width: 1),
            //         ),
            //         elevation: 0,
            //       ),
            //       child: Container(
            //         width: double.infinity,
            //         padding: EdgeInsets.symmetric(vertical: 0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Icon(
            //               Icons.g_translate,
            //               color: Colors.black,
            //             ), // Icon Google
            //             SizedBox(width: 8), // Spasi antara icon dan teks
            //             Padding(
            //               padding: const EdgeInsets.only(left: 50.0),
            //               child: Text(
            //                 'Continue with Google',
            //                 style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.normal),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
  //   String idMontir = await _authService.getLoggedInMontirId();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MontirHomePage(idMontir: idMontir),
  //     ),
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
          title: Text('Login Gagal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Email dan/atau password salah.',
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
