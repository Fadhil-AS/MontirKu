import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class RiwayatPelanggan extends StatefulWidget {
  final String idPelanggan;

  const RiwayatPelanggan({required this.idPelanggan, Key? key})
      : super(key: key);

  @override
  _RiwayatPelangganState createState() => _RiwayatPelangganState();
}

class _RiwayatPelangganState extends State<RiwayatPelanggan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  List<Map<String, dynamic>> servisRiwayat = [];
  List<Map<String, dynamic>> derekRiwayat = [];
  List<Map<String, dynamic>> belanjaRiwayat = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _fetchRiwayatData() async {
    try {
      // Ambil data perbaikan untuk "Servis" dan "Derek"
      final snapshot = await _database
          .child('tb_perbaikan')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        final List<Map<String, dynamic>> tempServis = [];
        final List<Map<String, dynamic>> tempDerek = [];

        data.forEach((key, value) {
          final perbaikan = value as Map<String, dynamic>;
          if (perbaikan['id_kendaraan'] != null) {
            tempServis.add(perbaikan);
          } else if (perbaikan['id_derek'] != null) {
            tempDerek.add(perbaikan);
          }
        });

        setState(() {
          servisRiwayat = tempServis;
          derekRiwayat = tempDerek;
        });
      }

      // Ambil data "Belanja" jika ada
      final belanjaSnapshot = await _database
          .child('tb_belanja')
          .orderByChild('id_pelanggan')
          .equalTo(widget.idPelanggan)
          .get();

      if (belanjaSnapshot.exists) {
        final data = belanjaSnapshot.value as Map;
        final List<Map<String, dynamic>> tempBelanja = [];

        data.forEach((key, value) {
          tempBelanja.add(value as Map<String, dynamic>);
        });

        setState(() {
          belanjaRiwayat = tempBelanja;
        });
      }
    } catch (e) {
      print("Error fetching riwayat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Riwayat",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs for "Servis," "Derek," and "Belanja"
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.blue, // Warna biru untuk tab aktif
                  borderRadius: BorderRadius.circular(20), // Radius bulat
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal:
                      -40, // Ukuran horizontal untuk mengatur lebar warna biru
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4, // Padding untuk jarak teks
                ),
                labelColor: Colors.white, // Warna teks untuk tab aktif
                unselectedLabelColor:
                    Colors.black, // Warna teks untuk tab tidak aktif
                tabs: const [
                  Tab(text: "Servis"),
                  Tab(text: "Derek"),
                  Tab(text: "Belanja"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab content (categorized history entries)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Servis Tab
                   _buildHistoryList(servisRiwayat, "Servis kendaraan"),
                  _buildHistoryList(derekRiwayat, "Derek kendaraan"),
                  _buildHistoryList(belanjaRiwayat, "Belanja pelanggan"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> riwayat, String title) {
    if (riwayat.isEmpty) {
      return Center(
        child: Text(
          "Belum ada riwayat $title.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: riwayat.length,
      itemBuilder: (context, index) {
        final item = riwayat[index];
        return _buildHistoryCard(
          title: title,
          subtitle:
              "${item['alamat_perbaikan'] ?? 'Alamat tidak tersedia'} · ${item['keluhan'] ?? 'Keluhan tidak tersedia'}",
          color: Colors.blue,
        );
      },
    );
  }

  Widget _buildHistoryCard(
      {required String title, required String subtitle, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
