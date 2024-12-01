import 'package:flutter/material.dart';
import 'package:montirku/widgets/notification_card.dart';

class MontirHomePage extends StatelessWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${getGreeting()},\nFadhil',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
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
                          'Rp 5,000,000',
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
                    Text('Servis'),
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
                        Icons.car_rental,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Derek'),
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
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pelanggan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  NotificationCard(
                    title: 'Dede',
                    time: '18:30',
                    leadingIcon: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/dede.jpg'),
                    ),
                  ),
                  NotificationCard(
                    title: 'Heru',
                    time: '19:00',
                    leadingIcon: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/heru.jpg'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Obrolan',
          ),
        ],
      ),
    );
  }
}
