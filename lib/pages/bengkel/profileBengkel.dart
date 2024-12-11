import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montirku/pages/login/landing.dart';
import 'dart:io';

class ProfileBengkelPage extends StatefulWidget {
  @override
  _ProfileBengkelPageState createState() => _ProfileBengkelPageState();
}

class _ProfileBengkelPageState extends State<ProfileBengkelPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nomorTelephoneController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default values (replace with actual data if available)
    _nameController.text = "Bengkel StarInk";
    _nomorTelephoneController.text = "081234567890";
    _addressController.text = "Jl. Telekomunikasi, Bandung";
    _emailController.text = "BengkelStarInk@gmail.com";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nomorTelephoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path); // Simpan file gambar
        });
      } else {
        print('Tidak ada gambar yang dipilih.');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Bengkel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto Profile
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(
                              _imageFile!) // Menampilkan gambar dari galeri
                          : AssetImage('assets/images/profile_bengkel.jpg')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Nama Lengkap
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nama Bengkel",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Tanggal Lahir
              TextField(
                controller: _nomorTelephoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Alamat
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Nomor Telepon
              TextField(
                controller: _emailController,
                keyboardType: TextInputType
                    .emailAddress, // Mengatur keyboard untuk input email
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Masukkan email Anda",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Membuat sudut membulat
                  ), // Menambahkan ikon email
                ),
                onChanged: (value) {
                  // Validasi atau logika saat teks diubah
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    print("Email tidak valid");
                  }
                },
              ),

              SizedBox(height: 24),
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Simpan data (implementasi sesuai kebutuhan)
                    print("Data disimpan:");
                    print("Nama: ${_nameController.text}");
                    print("Tanggal Lahir: ${_nomorTelephoneController.text}");
                    print("Alamat: ${_addressController.text}");
                    print("Nomor Telepon: ${_emailController.text}");
                  },
                  child: Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              // SizedBox(height: 24),
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  },
                  child: Text('Keluar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
