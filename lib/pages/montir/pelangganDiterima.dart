import 'package:flutter/material.dart';
import 'package:montirku/pages/montir/halamanPesan.dart';
import 'package:montirku/pages/montir/infoUsers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Pelangganditerima extends StatefulWidget {
  final String idMontir; // ID Montir untuk filter data
  const Pelangganditerima({required this.idMontir, Key? key}) : super(key: key);

  @override
  State<Pelangganditerima> createState() => _PelangganditerimaState();
}

class _PelangganditerimaState extends State<Pelangganditerima> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  List<Map<String, dynamic>> acceptedCustomers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAcceptedCustomers();
  }

  Future<void> _fetchAcceptedCustomers() async {
    try {
      final snapshot = await _database
          .child('tb_perbaikan')
          .orderByChild('id_montir')
          .equalTo(widget.idMontir)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> fetchedCustomers =
            data.entries.map((entry) {
          final perbaikan = entry.value as Map<dynamic, dynamic>;
          return {
            'name': perbaikan['id_pelanggan'] ?? 'Tidak diketahui',
            'phone': '081XXXXXX', // Sesuaikan jika ada nomor telepon
            'profile':
                'assets/images/default.jpg', // Gunakan default jika tidak ada
            'location':
                perbaikan['alamat_perbaikan'] ?? 'Lokasi tidak tersedia',
            'vehicle': perbaikan['id_kendaraan'] ?? 'Kendaraan tidak diketahui',
            'vehicleImage':
                'assets/images/default_vehicle.jpg', // Gunakan default jika tidak ada
            'complaint': perbaikan['keluhan'] ?? 'Keluhan tidak tersedia',
          };
        }).toList();

        setState(() {
          acceptedCustomers = fetchedCustomers;
          isLoading = false;
        });
      } else {
        setState(() {
          acceptedCustomers = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching accepted customers: $e");
      setState(() {
        acceptedCustomers = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelanggan Diterima',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : acceptedCustomers.isEmpty
              ? Center(child: Text("Tidak ada pelanggan yang diterima."))
              : ListView.builder(
                  itemCount: acceptedCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = acceptedCustomers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(customer['profile']!),
                        ),
                        title: Text(customer['name']!),
                        subtitle: Text(customer['phone']!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.info, color: Colors.lightBlue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InfoUsers(
                                      userName: customer['name']!,
                                      userImage: customer['profile']!,
                                      userLocation: customer['location']!,
                                      vehicleName: customer['vehicle']!,
                                      vehicleImage: customer['vehicleImage']!,
                                      complaint: customer['complaint']!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.message, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HalamanPesan(
                                      userName: customer['name']!,
                                      userImage: customer['profile']!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
