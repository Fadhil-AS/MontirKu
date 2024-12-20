import 'package:flutter/material.dart';
// import 'package:mindmend_ui/bottomNavbar.dart';
// import 'verifemail.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:montirku/pages/login/login.dart';

class DaftarPelanggan extends StatefulWidget {
  @override
  _DaftarPelangganState createState() => _DaftarPelangganState();
}

class _DaftarPelangganState extends State<DaftarPelanggan> {
  // Boolean untuk menentukan apakah password sedang ditampilkan atau disembunyikan
  final _namaLengkapController = TextEditingController();
  final _nomorTelephoneController = TextEditingController();
  final _alamatController = TextEditingController();
  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  Future<bool> _checkEmailExist(String email) async {
    final snapshot = await _database
        .child('tb_users')
        .orderByChild('email')
        .equalTo(email)
        .once();
    return snapshot.snapshot.value != null;
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _submitPelanggan() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    final namaLengkap = _namaLengkapController.text.trim();
    final alamat = _alamatController.text.trim();
    final nomorTelephone = _nomorTelephoneController.text.trim();
    final tanggalLahir = _dateController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (namaLengkap.isEmpty ||
        alamat.isEmpty ||
        nomorTelephone.isEmpty ||
        tanggalLahir.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _showSnackbar("Semua kolom harus diisi!");
      return;
    }

    bool isEmailExist = await _checkEmailExist(email);
    if (isEmailExist) {
      _showSnackbar("Email sudah terdaftar!");
      return;
    }

    try {
      // Hasilkan ID unik
      String idPelanggan = _database.child('tb_pelanggan').push().key!;
      String idUsers = _database.child('tb_users').push().key!;

      String hashedPassword = _hashPassword(password);

      // Simpan data pelanggan ke tb_pelanggan
      await _database.child('tb_pelanggan').child(idPelanggan).set({
        'id_pelanggan': idPelanggan,
        'nama_lengkap': namaLengkap,
        'nomor_telephone': nomorTelephone,
        'alamat': alamat,
        'tanggal_lahir': tanggalLahir,
      });

      // Simpan data pengguna ke tb_users
      await _database.child('tb_users').child(idUsers).set({
        'id_users': idUsers,
        'id_pelanggan': idPelanggan,
        'id_bengkel': null,
        'id_montir': null,
        'email': email,
        'password': hashedPassword,
      });

      _showSnackbar("Pendaftaran berhasil!");
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => BerandaPelanggan(
      //             idPelanggan: idPelanggan,
      //           )),
      // ); // Kembali ke halaman sebelumnya atau Dashboard W: HARUS DI EDIT
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      _showSnackbar("Terjadi kesalahan: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

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
                'Nama Lengkap',
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
                controller: _namaLengkapController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama lengkap',
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
                'Alamat lengkap',
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
                controller: _alamatController,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
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
                'Nomor Telephone',
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
                controller: _nomorTelephoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan nomor telephone',
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
                'Tanggal lahir',
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
                controller: _dateController, // Gunakan controller untuk tanggal
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan tanggal lahir',
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
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Batas awal tanggal
                    lastDate: DateTime.now(), // Batas akhir tanggal
                  );

                  if (pickedDate != null) {
                    // Jika pengguna memilih tanggal
                    _dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                },
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
                  onPressed: _submitPelanggan,
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
