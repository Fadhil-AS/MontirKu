import 'package:flutter/material.dart';
import 'package:montirku/pages/montir/halamanPesan.dart';
import 'package:montirku/pages/montir/infoUsers.dart';

class Pelangganditerima extends StatelessWidget {
  final List<Map<String, String>> acceptedCustomers = [
    {
      'name': 'Dede',
      'phone': '081234567890',
      'profile': 'assets/images/dede.jpg',
      'location': 'Jl. Telekomunikasi, Dayeuhkolot',
      'vehicle': 'Motor: X-ride 125',
      'vehicleImage': 'assets/images/Xride125.jpg',
      'complaint': 'Oli Kering',
    },
    {
      'name': 'Heru',
      'phone': '081987654321',
      'profile': 'assets/images/heru.jpg',
      'location': 'Jl. Telekomunikasi, Dayeuhkolot',
      'vehicle': 'Motor: Nmax 155',
      'vehicleImage': 'assets/images/NMAX155.jpg',
      'complaint': 'Mesin mati total',
    },
    {
      'name': 'Siti',
      'phone': '081234111122',
      'profile': 'assets/images/siti.jpg',
      'location': 'Jl. Telekomunikasi, Dayeuhkolot',
      'vehicle': 'Motor: Honda Supra',
      'vehicleImage': 'assets/images/supraX.jpg',
      'complaint': 'Mesin mati total',
    },
  ];

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
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
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
                      print('Detail pengguna:');
                      print('Nama: ${customer['name']}');
                      print('Lokasi: ${customer['location']}');
                      print('Kendaraan: ${customer['vehicle']}');
                      print('Keluhan: ${customer['complaint']}');

                      print('Navigasi ke InfoUsers dimulai...');
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
                      ).then((value) {
                        print('Kembali dari InfoUsers');
                      });
                      print('Navigasi ke InfoUsers selesai.');
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
                      print('Kirim pesan ke ${customer['name']}');
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
