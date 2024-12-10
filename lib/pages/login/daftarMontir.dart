import 'package:flutter/material.dart';
import 'package:montirku/pages/login/daftarMontirEmail.dart';
import 'package:flutter/services.dart';

class DaftarMontir extends StatelessWidget {
  final TextEditingController _dateController = TextEditingController();

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DaftarMontirEmail()),
                  );
                },
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
