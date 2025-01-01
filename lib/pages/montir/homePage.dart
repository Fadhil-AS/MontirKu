import 'package:flutter/material.dart';
import 'package:montirku/widgets/notification_card.dart';
import 'package:montirku/pages/montir/pelangganDiterima.dart';
import 'package:montirku/pages/montir/detailBengkel.dart';
import 'package:montirku/pages/montir/profileMontir.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MontirHomePage extends StatefulWidget {
  final String idMontir;

  const MontirHomePage({required this.idMontir, Key? key}) : super(key: key);
  @override
  _MontirHomePageState createState() => _MontirHomePageState();
}

class _MontirHomePageState extends State<MontirHomePage> {
  int _currentIndex = 0;
  String? namaMontir;
  List<Map<String, dynamic>> perbaikanList = [
    {
      'title': 'Dede',
      'jenisKeluhan': 'Oli kering',
      'image': 'assets/images/dede.jpg',
    },
    {
      'title': 'Heru',
      'jenisKeluhan': 'Mogok',
      'image': 'assets/images/heru.jpg',
    },
  ];

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // Daftar halaman
  // final List<Widget> _pages = [
  //   HomePageContent(),
  //   Pelangganditerima(), // Halaman pelanggan diterima
  // ];
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    print("MontirHomePage initState - ID Montir: ${widget.idMontir}");
    _fetchMontirData();
    _fetchPerbaikanData();
  }

  Future<void> _fetchMontirData() async {
    try {
      print("Fetching data for ID Montir: ${widget.idMontir}");
      final montirSnapshot =
          await _database.child('tb_montir').child(widget.idMontir).get();

      if (montirSnapshot.exists) {
        final montirData = montirSnapshot.value as Map<dynamic, dynamic>;
        print("Data Montir: $montirData");

        setState(() {
          namaMontir = montirData['nama_lengkap'] ?? 'Nama Tidak Diketahui';
          _pages = [
            HomePageContent(
              idMontir: widget.idMontir,
              namaMontir: namaMontir,
              perbaikanList: perbaikanList,
              onReject: removeCard,
            ),
            Pelangganditerima(
                // idMontir: widget.idMontir,
                ),
          ];
        });
      } else {
        print("Montir tidak ditemukan");
        setState(() {
          _pages = [
            Center(
              child: Text("Montir tidak ditemukan"),
            ),
            Pelangganditerima(
                // idMontir: widget.idMontir,
                ),
          ];
        });
      }
    } catch (e) {
      print("Error fetching montir data: $e");
      setState(() {
        _pages = [
          Center(
            child: Text("Terjadi kesalahan saat mengambil data."),
          ),
          Pelangganditerima(
              // idMontir: widget.idMontir,
              ),
        ];
      });
    }
  }

  Future<void> _fetchPerbaikanData() async {
    try {
      final perbaikanSnapshot = await _database
          .child('tb_perbaikan')
          .orderByChild('id_montir')
          .equalTo(widget.idMontir)
          .get();

      if (perbaikanSnapshot.exists) {
        print("Data ditemukan: ${perbaikanSnapshot.value}");
        final data = (perbaikanSnapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        final List<Map<String, dynamic>> fetchedData =
            data.entries.map((entry) {
          return {
            "idPerbaikan": entry.key,
            ...entry.value as Map<String, dynamic>,
          };
        }).toList();

        setState(() {
          perbaikanList = fetchedData;
        });
      } else {
        print(
            "Tidak ada perbaikan ditemukan untuk id_montir: ${widget.idMontir}");
        setState(() {
          perbaikanList = [];
        });
      }
    } catch (e) {
      print("Error fetching perbaikan data: $e");
    }
  }

  void removeCard(int index) {
    setState(() {
      perbaikanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building MontirHomePage - Current Index: $_currentIndex");
    print("Pages Available: $_pages");

    return Scaffold(
      body: _pages.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print("Bottom Navigation Changed - Current Index: $_currentIndex");
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pelanggan',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final String idMontir;
  final String? namaMontir;
  final List<Map<String, dynamic>> perbaikanList;
  final void Function(int index) onReject;

  const HomePageContent({
    required this.idMontir,
    this.namaMontir,
    required this.perbaikanList,
    required this.onReject,
    Key? key,
  }) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('profile_image_path');

      if (imagePath != null && File(imagePath).existsSync()) {
        setState(() {
          _profileImage = File(imagePath);
        });
      } else {
        print('Path gambar tidak ditemukan, menggunakan default.');
      }
    } catch (e) {
      print('Terjadi kesalahan saat memuat path gambar: $e');
    }
  }

  double calculatePercentage(List<Map<String, dynamic>> list, String category) {
    if (list.isEmpty) return 0.0;
    final total = list.length;
    final count = list.where((item) => item['kategori'] == category).length;
    return (count / total) * 100;
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

  @override
  Widget build(BuildContext context) {
    print("Rendering HomePageContent - Nama Montir: ${widget.namaMontir}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.namaMontir != null
              ? '${getGreeting()}, \n${widget.namaMontir}'
              : 'Sedang memuat...',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileMontirPage(idMontir: widget.idMontir),
                  ),
                ).then((_) {
                  _loadProfileImage();
                });
              },
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/images/montir/default_profile.jpg')
                        as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo Anda',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Rp 0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Cashout'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.build,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                        '${calculatePercentage(widget.perbaikanList, 'Servis').toStringAsFixed(1)}%'),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.car_crash,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                        '${calculatePercentage(widget.perbaikanList, 'derek').toStringAsFixed(1)}%'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Bengkel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/profile_bengkel.jpg'),
                ),
                title: Text('Bengkel StarInk'),
                subtitle:
                    Text('Jl. Telekomunikasi No. 203\nBojongsoang, Bandung'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBengkel(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pelanggan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: widget.perbaikanList.isEmpty
                  ? Center(child: Text("Tidak ada data pelanggan"))
                  : ListView.builder(
                      itemCount: widget.perbaikanList.length,
                      itemBuilder: (context, index) {
                        final perbaikan = widget.perbaikanList[index];
                        return NotificationCard(
                          title: perbaikan['title'],
                          jenisKeluhan: perbaikan['jenisKeluhan'],
                          leadingIcon: CircleAvatar(
                            backgroundImage: AssetImage(perbaikan['image']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
