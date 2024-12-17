import 'package:flutter/material.dart';
import 'package:montirku/pages/montir/homePage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DaftarMontir extends StatefulWidget {
  @override
  State<DaftarMontir> createState() => _DaftarMontirState();
}

class _DaftarMontirState extends State<DaftarMontir> {
  final _namaLengkapController = TextEditingController();
  final _nomorTelephoneController = TextEditingController();
  final _alamatController = TextEditingController();
  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  void _submitToDatabase() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackbar("Email tidak boleh kosong!");
      return;
    }

    bool isEmailExist = await _checkEmailExist(email);

    if (isEmailExist) {
      _showSnackbar("Email sudah terdaftar!");
    } else {
      await _saveMontirData();
      _showSnackbar("Pendaftaran montir berhasil!");
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

  Future<void> _saveMontirData() async {
    try {
      // Generate unique IDs
      String idMontir = _database.child('tb_montir').push().key!;
      String idUsers = _database.child('tb_users').push().key!;

      // Hash the password
      String hashedPassword = _hashPassword(_passwordController.text);

      // Simpan data ke tb_montir
      await _database.child('tb_montir').child(idMontir).set({
        'id_montir': idMontir,
        'nama_lengkap': _namaLengkapController.text,
        'nomor_telephone': _nomorTelephoneController.text,
        'alamat': _alamatController.text,
        'tanggal_lahir': _dateController.text,
      });

      // Simpan data ke tb_users
      await _database.child('tb_users').child(idUsers).set({
        'id_users': idUsers,
        'id_bengkel': null,
        'id_montir': idMontir,
        'id_pelanggan': null,
        'email': _emailController.text,
        'password': hashedPassword,
      });

      // Navigasi ke halaman sukses atau dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MontirHomePage()),
      );
    } catch (e) {
      _showSnackbar("Terjadi kesalahan, coba lagi!");
      print("Error: $e");
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar menjadi montir'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Daftarkan diri anda disini.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 16),
              TextField(
                controller: _namaLengkapController,
                decoration: InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.supervised_user_circle_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateController, // Gunakan controller untuk tanggal
                readOnly: true, // Agar tidak dapat diketik langsung
                decoration: InputDecoration(
                  labelText: 'Tanggal lahir',
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nomorTelephoneController,
                keyboardType: TextInputType
                    .number, // Menentukan jenis keyboard hanya angka
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
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat lengkap',
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
                    Text('Daftar', style: TextStyle(color: Colors.white)),
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
