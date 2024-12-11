import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Servis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Servis Kendaraan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Ganti Oli'),
            RadioListTile(
              title: Text('Oli Standar - Rp62.000'),
              value: 'standar',
              groupValue: 'oli',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: Text('Oli Spesial - Rp85.000'),
              value: 'spesial',
              groupValue: 'oli',
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            Text('Keluhan Motor'),
            CheckboxListTile(
              title: Text('Ban Kempes - Gratis'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Ban Bocor - Rp30.000'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Rem Kurang Pakem - Gratis'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Ganti Kampas Rem Depan - Rp350.000'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Ganti Kampas Rem Belakang - Rp360.000'),
              value: false,
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Keluhan Lainnya (Opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Tambahkan Pesanan - Rp582.000'),
            ),
          ],
        ),
      ),
    );
  }
}
