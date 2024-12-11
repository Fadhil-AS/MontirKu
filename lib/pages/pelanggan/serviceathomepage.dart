import 'package:flutter/material.dart';
import 'package:montirku/pages/pelanggan/servicedetails.dart';
class ServiceAtHomePage extends StatefulWidget {
  @override
  _ServiceAtHomePageState createState() => _ServiceAtHomePageState();
}

class _ServiceAtHomePageState extends State<ServiceAtHomePage> {
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Servis di Rumah',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text('Maps User'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Alamat Lengkap',
                              hintText: 'Masukkan alamat lengkap Anda',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetailsPage(),
                                ),
                              );
                            },
                            child: Text('Konfirmasi Alamat'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}