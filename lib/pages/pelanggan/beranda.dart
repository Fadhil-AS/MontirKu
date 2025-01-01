import 'package:flutter/material.dart';
import 'package:montirku/pages/pelanggan/riwayatPelanggan.dart';
import 'package:montirku/pages/pelanggan/serviceathomepage.dart';
import 'package:montirku/pages/pelanggan/serviceatworkshop.dart';
import 'package:montirku/pages/pelanggan/belanjaPelanggan.dart';
import 'package:montirku/pages/pelanggan/pelangganProfile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class BerandaPelanggan extends StatefulWidget {
  final String idPelanggan;

  const BerandaPelanggan({required this.idPelanggan, Key? key})
      : super(key: key);
  @override
  _BerandaPelangganState createState() => _BerandaPelangganState();
}

class _BerandaPelangganState extends State<BerandaPelanggan> {
  int _currentIndex = 0;
  String? namaPelanggan;
  String? namaFileGambar;
  String? namaKendaraan;
  File? _selectedImage;
  String? _savedImagePath;

  List<Map<String, dynamic>> riwayatPerbaikan = [];

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  @override
  void initState() {
    super.initState();
    _fetchPelangganData();
    _fetchGambarData();
    _fetchKendaraanData();
    _fetchRiwayatPerbaikan();
  }

  Future<void> _fetchPelangganData() async {
    try {
      final pelangganSnapshot =
          await _database.child('tb_pelanggan/${widget.idPelanggan}').get();

      if (pelangganSnapshot.exists) {
        final pelangganData = pelangganSnapshot.value as Map;
        setState(() {
          namaPelanggan = pelangganData['nama_lengkap'];
        });
      } else {
        setState(() {
          namaPelanggan = "Pelanggan";
        });
      }
    } catch (e) {
      print("Error fetching pelanggan data: $e");
    }
  }

  Future<void> _fetchGambarData() async {
    try {
      final gambarSnapshot = await _database
          .child('tb_gambar')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (gambarSnapshot.exists) {
        final gambarData = gambarSnapshot.value as Map;
        final gambar = gambarData.values.first as Map;

        final String fileName = gambar['nama_file'];
        final String filePath = 'assets/images/pelanggan/$fileName';

        if (File(filePath).existsSync()) {
          setState(() {
            namaFileGambar = fileName;
          });
        } else {
          setState(() {
            namaFileGambar = "default_profile.jpg";
          });
        }
      } else {
        setState(() {
          namaFileGambar = "default_profile.jpg";
        });
      }
    } catch (e) {
      print("Error fetching gambar data: $e");
      setState(() {
        namaFileGambar = "default_profile.jpg";
      });
    }
  }

  Future<void> _fetchKendaraanData() async {
    try {
      // Query data kendaraan berdasarkan id_pelanggan
      final snapshot = await _database
          .child('tb_kendaraan')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (snapshot.exists) {
        final kendaraanData = snapshot.value as Map;
        final kendaraan = kendaraanData.values.first as Map;

        setState(() {
          namaKendaraan = kendaraan['nama_kendaraan']; // Nama kendaraan
        });
      } else {
        setState(() {
          namaKendaraan =
              "Kendaraan belum terdaftar"; // Default jika tidak ada kendaraan
        });
      }
    } catch (e) {
      print("Error fetching kendaraan data: $e");
      setState(() {
        namaKendaraan = "Kendaraan belum terdaftar";
      });
    }
  }

  Future<void> _fetchRiwayatPerbaikan() async {
    try {
      // Query data perbaikan berdasarkan id_pelanggan
      final snapshot = await _database
          .child('tb_perbaikan')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        final List<Map<String, dynamic>> tempRiwayat = [];

        data.forEach((key, value) {
          tempRiwayat.add(value as Map<String, dynamic>);
        });

        setState(() {
          riwayatPerbaikan = tempRiwayat; // Simpan riwayat ke state
        });
      } else {
        setState(() {
          riwayatPerbaikan = []; // Kosongkan jika tidak ada data
        });
      }
    } catch (e) {
      print("Error fetching riwayat perbaikan: $e");
      setState(() {
        riwayatPerbaikan = [];
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    // Tentukan ucapan berdasarkan jam
    if (hour >= 0 && hour < 12) {
      return 'Selamat pagi';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  Widget _buildRiwayatPerbaikan() {
    if (riwayatPerbaikan.isEmpty) {
      return Center(
        child: Text(
          "Belum ada riwayat perbaikan",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      children: riwayatPerbaikan.map((perbaikan) {
        String status = perbaikan['status'] ?? 'Tidak diketahui';
        Color statusColor;

        // Tentukan warna berdasarkan status
        if (status == 'Sedang di servis') {
          statusColor = Colors.yellow;
        } else if (status == 'Servis dibatalkan') {
          statusColor = Colors.red;
        } else {
          statusColor = Colors.green;
        }

        return _buildHistoryCard(
          "Servis kendaraan", // Judul
          "${perbaikan['alamat_perbaikan']} · $status", // Subjudul
          statusColor, // Warna status
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getGreeting()}, ',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  namaPelanggan != null ? namaPelanggan! : "Loading...",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Stack(
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.notifications_none,
                //           color: Colors.black),
                //       onPressed: () {},
                //     ),
                //     Positioned(
                //       right: 8,
                //       top: 8,
                //       child: Container(
                //         width: 10,
                //         height: 10,
                //         decoration: BoxDecoration(
                //           color: Colors.red,
                //           shape: BoxShape.circle,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(width: 10),
                CircleAvatar(
                  key: ValueKey(
                    _selectedImage != null
                        ? _selectedImage!.path
                        : _savedImagePath ?? namaFileGambar,
                  ),
                  radius: 20,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_savedImagePath != null &&
                              File(_savedImagePath!).existsSync())
                          ? FileImage(File(_savedImagePath!))
                          : AssetImage(
                                  'assets/images/pelanggan/${namaFileGambar ?? "default_profile.jpg"}')
                              as ImageProvider,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PelangganProfile(idPelanggan: widget.idPelanggan),
                        ),
                      );

                      if (result != null && result is String) {
                        setState(() {
                          _savedImagePath = result;
                          _selectedImage = File(result);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Motor",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          namaKendaraan ?? "Belum terdaftar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.add_circle, color: Colors.white, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Services Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildServiceButton(
                    "Servis",
                    Icons.build,
                    isPopup: true,
                  ),
                  _buildServiceButton(
                    "Belanja",
                    Icons.shopping_cart,
                    targetPage: BelanjaPelanggan(
                      idPelanggan: widget.idPelanggan,
                    ),
                  ),
                  _buildServiceButton("Derek", Icons.local_shipping),
                ],
              ),

              const SizedBox(height: 16),
              // Promo Card
              Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image:
                            AssetImage("assets/images/bengkel/cvt-xride.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 500,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Discount up to 50%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Min. purchase Rp100.000",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green, // Warna background button
                            foregroundColor:
                                Colors.white, // Warna teks saat ditekan
                            shape: RoundedRectangleBorder(
                              // Bentuk tombol
                              borderRadius: BorderRadius.circular(
                                  12), // Radius sudut tombol
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20), // Padding tombol
                          ),
                          child: const Text(
                            "Buy now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Riwayat",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RiwayatPelanggan(idPelanggan: widget.idPelanggan),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.lightBlue, // Warna background tombol
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Membuat sudut membulat
                      ),
                      elevation: 2, // Efek bayangan tombol
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8), // Padding tombol
                    ),
                    child: Text(
                      'Lihat semua',
                      style: TextStyle(
                        color: Colors.white, // Warna teks tombol
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRiwayatPerbaikan(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Warna ikon aktif
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(String label, IconData icon,
      {Widget? targetPage, bool isPopup = false}) {
    return GestureDetector(
      onTap: () {
        if (isPopup) {
          _showServicePopup(context); // Panggil fungsi popup jika isPopup true
        } else if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  void _showServicePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildServicePopup(context),
    );
  }

  Widget _buildServicePopup(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih layanan kamu inginkan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceAtWorkshopPage(),
                    ),
                  );
                },
                child: Column(
                  children: const [
                    Icon(Icons.garage, size: 40, color: Colors.blue),
                    Text('Bengkel'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceAtHomePage(),
                    ),
                  );
                },
                child: Column(
                  children: const [
                    Icon(Icons.home, size: 40, color: Colors.blue),
                    Text('Rumah'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.check_circle, color: color),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
