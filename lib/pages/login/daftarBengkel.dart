import 'package:flutter/material.dart';
import 'package:montirku/pages/bengkel/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DaftarBengkel extends StatefulWidget {
  @override
  State<DaftarBengkel> createState() => _DaftarBengkelState();
}

class _DaftarBengkelState extends State<DaftarBengkel> {
  final _namaBengkelController = TextEditingController();
  final _nomorTelephoneController = TextEditingController();
  final _alamatBengkelController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  void _submitToDatabase() async {
    FocusScope.of(context).unfocus(); // Menutup keyboard
    try {
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        _showSnackbar("Email tidak boleh kosong!");
        return;
      }

      // Periksa apakah email sudah terdaftar
      bool isEmailExist = await _checkEmailExist(email);
      if (isEmailExist) {
        _showSnackbar("Email sudah terdaftar!");
        return;
      }
      // Hasilkan ID unik untuk tb_bengkel dan tb_users
      String idBengkel = _database.child('tb_bengkel').push().key!;
      String idUsers = _database.child('tb_users').push().key!;

      String hashedPassword = _hashPassword(_passwordController.text);

      // Simpan data ke tabel tb_bengkel
      await _database.child('tb_bengkel').child(idBengkel).set({
        'id_bengkel': idBengkel,
        'nama_bengkel': _namaBengkelController.text,
        'nomor_telephone': _nomorTelephoneController.text,
        'alamat': _alamatBengkelController.text,
      });

      // Simpan data ke tabel tb_users
      await _database.child('tb_users').child(idUsers).set({
        'id_users': idUsers,
        'id_bengkel': idBengkel,
        'id_montir': null,
        'id_pelanggan': null,
        'email': _emailController.text,
        'password': hashedPassword,
      });

      print("Data berhasil disimpan ke Firebase!");

      // Tampilkan notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan!')),
      );

      // Reset semua input field
      _namaBengkelController.clear();
      _nomorTelephoneController.clear();
      _alamatBengkelController.clear();
      _emailController.clear();
      _passwordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } catch (e) {
      print("Error saat menyimpan data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan, coba lagi!')),
      );
    }
  }

  Future<bool> _checkEmailExist(String email) async {
    final snapshot = await _database
        .child('tb_users')
        .orderByChild('email')
        .equalTo(email)
        .once();

    return snapshot.snapshot.value != null;
  }

  // Fungsi untuk menampilkan Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Bengkel'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Daftarkan bengkel anda disini.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 16),
              TextField(
                controller: _namaBengkelController,
                decoration: InputDecoration(
                  labelText: 'Nama bengkel',
                  prefixIcon: Icon(Icons.car_rental),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nomorTelephoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nomor telephone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _alamatBengkelController,
                decoration: InputDecoration(
                  labelText: 'Alamat bengkel',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'user@gmail.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Kata sandi',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitToDatabase,
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => DaftarBengkelEmail()),
                //   );
                // },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // Warna biru muda
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Radius sudut tombol
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16), // Padding tombol
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Selanjutnya', style: TextStyle(color: Colors.white)),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
