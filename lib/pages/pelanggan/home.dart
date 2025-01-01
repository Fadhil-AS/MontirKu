import 'package:flutter/material.dart';

import 'derekpage.dart';
import 'serviceathomepage.dart';
import 'serviceatworkshop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Selamat pagi,\nUser',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/heru.jpg'),
              radius: 18,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset('assets/images/supraX.jpg', width: 50),
                title: Text('MOTOR'),
                subtitle: Text('X-ride 125'),
                trailing: IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionCard(Icons.build, 'Servis', context),
                _buildActionCard(Icons.shopping_cart, 'Belanja', context),
                _buildActionCard(Icons.local_taxi, 'Derek', context),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              width: double.infinity,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Discount up to 50%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Min. purchase Rp100.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    Colors.orange,
                    'Servis kendaraan',
                    '7 Nov 2022 - Sedang di servis',
                  ),
                  _buildHistoryItem(
                    Colors.red,
                    'Servis kendaraan',
                    '5 Nov 2022 - Servis dibatalkan',
                  ),
                  _buildHistoryItem(
                    Colors.green,
                    'Servis kendaraan',
                    '5 Nov 2022 - Servis berhasil',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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

  Widget _buildActionCard(IconData icon, String label, BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (label == 'Servis') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildServicePopup(context);
                },
              );
            }else if (label == 'Derek') {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TowPage(), // Halaman untuk layanan derek
                ),
              );
            }
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildServicePopup(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pilih layanan yang kamu inginkan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
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
                  children: [
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
                  children: [
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

  Widget _buildHistoryItem(Color color, String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(Icons.build, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
