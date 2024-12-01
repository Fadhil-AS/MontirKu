import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final Widget? leadingIcon;

  const NotificationCard({
    required this.title,
    required this.time,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leadingIcon ??
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
        title: Text(title),
        subtitle: Text(time),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Konfirmasi'),
                    content: Text('Yakin ingin menolak pesanan ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                          print('Pesanan ditolak');
                        },
                        child: Text('Tolak'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(70, 30),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Tolak'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Konfirmasi'),
                    content: Text('Terima pesanan?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                          print('Pesanan diterima');
                        },
                        child: Text('Terima'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(70, 30),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Terima'),
            ),
          ],
        ),
      ),
    );
  }
}
