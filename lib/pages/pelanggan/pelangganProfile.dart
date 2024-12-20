import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:montirku/pages/login/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PelangganProfile extends StatefulWidget {
  final String idPelanggan;

  const PelangganProfile({required this.idPelanggan, Key? key})
      : super(key: key);

  @override
  _PelangganProfileState createState() => _PelangganProfileState();
}

class _PelangganProfileState extends State<PelangganProfile> {
  File? _selectedImage;
  String? _savedImagePath;

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  String? namaLengkap;
  String? email;
  String? tanggalLahir;
  String? alamat;
  String? nomorTelepon;
  String? namaFileGambar;

  @override
  void initState() {
    super.initState();
    _fetchPelangganData();
    _fetchUserData();
    _loadSavedImagePath();
  }

  Future<void> _fetchPelangganData() async {
    try {
      final pelangganSnapshot =
          await _database.child('tb_pelanggan/${widget.idPelanggan}').get();

      if (pelangganSnapshot.exists) {
        final pelangganData = pelangganSnapshot.value as Map;

        setState(() {
          namaLengkap = pelangganData['nama_lengkap'];
          tanggalLahir = pelangganData['tanggal_lahir'];
          alamat = pelangganData['alamat'];
          nomorTelepon = pelangganData['nomor_telephone'];
          namaFileGambar = pelangganData['nama_file'] ?? "default_profile.jpg";
        });
      } else {
        setState(() {
          namaLengkap = "Tidak ditemukan";
          tanggalLahir = "-";
          alamat = "-";
          nomorTelepon = "-";
          namaFileGambar = "default_profile.jpg";
        });
      }
    } catch (e) {
      print("Error fetching pelanggan data: $e");
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userSnapshot = await _database
          .child('tb_users')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (userSnapshot.exists) {
        final userData = (userSnapshot.value as Map).values.first as Map;
        setState(() {
          email = userData['email'] ?? ""; // Set email
        });
      } else {
        setState(() {
          email = ""; // Default jika data tidak ditemukan
        });
      }
    } catch (e) {
      print("Error fetching user data: $e"); // Log error jika terjadi masalah
    }
  }

  Future<void> _loadSavedImagePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPath = prefs.getString('profile_image_path');
      if (savedPath != null && File(savedPath).existsSync()) {
        setState(() {
          _savedImagePath = savedPath;
          _selectedImage = File(savedPath);
        });
      } else {
        print("Saved image path does not exist or is null.");
      }
    } catch (e) {
      print("Error loading saved image path: $e");
    }
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Dialog pilihan untuk memilih dari galeri atau kamera
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                  await _saveImagePath(pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                  await _saveImagePath(pickedFile.path);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    try {
      // Perbarui data di tb_pelanggan
      await _database.child('tb_pelanggan/${widget.idPelanggan}').update({
        'nama_lengkap': namaLengkap,
        'tanggal_lahir': tanggalLahir,
        'alamat': alamat,
        'nomor_telephone': nomorTelepon,
      });
      print("Data tb_pelanggan berhasil diperbarui.");

      // Perbarui data di tb_gambar jika gambar baru dipilih
      if (_selectedImage != null) {
        final fileName = _selectedImage!.path.split('/').last;

        // Simpan nama file gambar di tb_gambar
        await _database.child('tb_gambar/${widget.idPelanggan}').update({
          'id_pelanggan': widget.idPelanggan,
          'nama_file': fileName,
        });
        print("Data tb_gambar berhasil diperbarui.");
      }

      // Perbarui data di tb_users
      final userSnapshot = await _database
          .child('tb_users')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (userSnapshot.exists) {
        final userKey = (userSnapshot.value as Map).keys.first;
        await _database.child('tb_users/$userKey').update({
          'email': email,
        });
        print("Data tb_users berhasil diperbarui.");
      }

      // Notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui!")),
      );
    } catch (e) {
      print("Error updating profile: $e");

      // Notifikasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui profil!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Profile Pelanggan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              _selectedImage != null
                  ? _selectedImage!.path // Kirim path gambar terbaru
                  : _savedImagePath ??
                      namaFileGambar, // Jika tidak ada perubahan, kirim gambar default
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: namaLengkap == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : _savedImagePath != null
                                    ? FileImage(File(
                                        _savedImagePath!)) // Menampilkan gambar dari galeri
                                    : AssetImage(
                                            'assets/images/pelanggan/${namaFileGambar ?? "default_profile.jpg"}')
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
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: namaLengkap,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          namaLengkap = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue:
                          email, // Gunakan nilai email yang diambil dari database
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          email =
                              value; // Perbarui nilai email saat pengguna mengetik
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: TextEditingController(text: tanggalLahir),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? initialDate;

                        // Parsing tanggal lahir menjadi DateTime
                        try {
                          if (tanggalLahir != null &&
                              tanggalLahir!.contains("/")) {
                            final parts = tanggalLahir!.split("/");
                            initialDate = DateTime(
                              int.parse(parts[2]), // Tahun
                              int.parse(parts[1]), // Bulan
                              int.parse(parts[0]), // Hari
                            );
                          } else if (tanggalLahir != null) {
                            initialDate = DateTime.parse(
                                tanggalLahir!); // Format yyyy-MM-dd
                          } else {
                            initialDate = DateTime.now(); // Default jika null
                          }
                        } catch (e) {
                          initialDate = DateTime
                              .now(); // Gunakan tanggal sekarang jika parsing gagal
                        }

                        // Menampilkan dialog DatePicker
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: initialDate!,
                          firstDate: DateTime(1900), // Batas awal tanggal
                          lastDate: DateTime.now(), // Batas akhir tanggal
                        );

                        // Jika pengguna memilih tanggal, perbarui tanggal lahir
                        if (pickedDate != null) {
                          setState(() {
                            tanggalLahir =
                                "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: alamat,
                      decoration: InputDecoration(
                        labelText: "Alamat",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          alamat = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: nomorTelepon,
                      keyboardType: TextInputType
                          .number, // Mengubah keyboard menjadi numerik
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Membatasi input hanya angka
                      ],
                      decoration: InputDecoration(
                        labelText: "Nomor Telepon",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          nomorTelepon = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text("Simpan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Keluar"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
