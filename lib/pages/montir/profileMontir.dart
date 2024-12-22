import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montirku/pages/login/landing.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMontirPage extends StatefulWidget {
  final String idMontir; // Required parameter

  const ProfileMontirPage({required this.idMontir, Key? key}) : super(key: key);

  @override
  _ProfileMontirPageState createState() => _ProfileMontirPageState();
}

class _ProfileMontirPageState extends State<ProfileMontirPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bengkelController = TextEditingController();

  File? _imageFile;

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  @override
  void initState() {
    super.initState();
    // Default values (replace with actual data if available)
    _fetchData();
    _loadImagePath();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bengkelController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      // Ambil data montir
      final montirSnapshot =
          await _database.child('tb_montir').child(widget.idMontir).get();
      if (montirSnapshot.exists) {
        final montirData = montirSnapshot.value as Map;
        _nameController.text = montirData['nama_lengkap'] ?? '';
        _birthdateController.text = montirData['tanggal_lahir'] ?? '';
        _addressController.text = montirData['alamat'] ?? '';
        _phoneController.text = montirData['nomor_telephone'] ?? '';

        // Ambil data user
        final userSnapshot = await _database
            .child('tb_users')
            .orderByChild('id_montir')
            .equalTo(widget.idMontir)
            .get();
        if (userSnapshot.exists) {
          final userData = (userSnapshot.value as Map).values.first;
          _emailController.text = userData['email'] ?? '';
        }

        // Ambil data bengkel
        if (montirData['id_bengkel'] != null) {
          final bengkelSnapshot = await _database
              .child('tb_bengkel')
              .child(montirData['id_bengkel'])
              .get();
          if (bengkelSnapshot.exists) {
            final bengkelData = bengkelSnapshot.value as Map;
            _bengkelController.text = bengkelData['nama_bengkel'] ?? '';
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

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
                    _imageFile = File(pickedFile.path);
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
                    _imageFile = File(pickedFile.path);
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

  Future<void> _saveImagePath(String imagePath) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', imagePath);
      print('Path gambar berhasil disimpan: $imagePath');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan path gambar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui foto profil')),
      );
    }
  }

  Future<void> _loadImagePath() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('profile_image_path');

      if (imagePath != null && File(imagePath).existsSync()) {
        setState(() {
          _imageFile = File(imagePath);
        });
        print('Path gambar ditemukan: $imagePath');
      } else {
        print('Path gambar tidak ditemukan, menggunakan default.');
      }
    } catch (e) {
      print('Terjadi kesalahan saat memuat path gambar: $e');
    }
  }

  Future<void> _updateData() async {
    try {
      // Update data di tb_montir
      final montirUpdates = {
        'nama_lengkap': _nameController.text,
        'tanggal_lahir': _birthdateController.text,
        'alamat': _addressController.text,
        'nomor_telephone': _phoneController.text,
        'id_bengkel':
            _bengkelController.text.isNotEmpty ? _bengkelController.text : null,
      };
      await _database
          .child('tb_montir')
          .child(widget.idMontir)
          .update(montirUpdates);
      print("Data montir berhasil diperbarui.");

      // Update data di tb_users
      final userSnapshot = await _database
          .child('tb_users')
          .orderByChild('id_montir')
          .equalTo(widget.idMontir)
          .get();

      if (userSnapshot.exists) {
        final userId = (userSnapshot.value as Map).keys.first;
        final userUpdates = {'email': _emailController.text};
        await _database.child('tb_users').child(userId).update(userUpdates);
        print("Data pengguna berhasil diperbarui.");
      }

      // Update data di tb_bengkel
      if (_bengkelController.text.isNotEmpty) {
        final bengkelSnapshot = await _database
            .child('tb_bengkel')
            .orderByChild('nama_bengkel')
            .equalTo(_bengkelController.text)
            .get();

        if (bengkelSnapshot.exists) {
          final bengkelId = (bengkelSnapshot.value as Map).keys.first;
          final bengkelUpdates = {
            'nama_bengkel': _bengkelController.text,
            'alamat': _addressController.text,
            'nomor_telephone': _phoneController.text,
          };
          await _database
              .child('tb_bengkel')
              .child(bengkelId)
              .update(bengkelUpdates);
          await _database.child('tb_montir').child(widget.idMontir).update({
            'id_bengkel': bengkelId,
          });
          print("Data bengkel berhasil diperbarui.");
        } else {
          // Buat entri baru
          final newBengkelRef = _database.child('tb_bengkel').push();
          await newBengkelRef.set({
            'nama_bengkel': _bengkelController.text,
            'alamat': _addressController.text,
            'nomor_telephone': _phoneController.text,
          });
          await _database.child('tb_montir').child(widget.idMontir).update({
            'id_bengkel': newBengkelRef.key,
          });
          print("Data bengkel baru berhasil ditambahkan.");
        }
      }

      // Notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diperbarui')),
      );
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat memperbarui data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Montir', style: TextStyle(color: Colors.white)),
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
                          ? FileImage(_imageFile!) // Gambar dari lokal
                          : AssetImage(
                                  'assets/images/montir/default_profile.jpg')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
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
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _bengkelController,
                decoration: InputDecoration(
                  labelText: "Nama Bengkel",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Tanggal Lahir
              TextField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _birthdateController.text =
                            "${selectedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  });
                },
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
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateData,
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
