import 'package:flutter/material.dart';

class DetailPesananPage extends StatelessWidget {
  final Map<String, dynamic> pesanan;

  DetailPesananPage({required this.pesanan});

  List<Map<String, dynamic>> _getFilteredStatus(String status) {
    final allStatus = [
      {
        'title': 'Pelanggan - 05 Nov 2022',
        'description': 'Pesanan dalam perjalanan',
        'icon': Icons.directions_bike,
        'color': Colors.yellow,
      },
      {
        'title': 'Bengkel - 05 Nov 2022',
        'description': 'Pesanan sudah diterima bengkel',
        'icon': Icons.check_circle,
        'color': Colors.blue,
      },
      {
        'title': 'MontirKu - 05 Nov 2022',
        'description': 'Pesanan sudah diverifikasi',
        'icon': Icons.check_circle_outline,
        'color': Colors.blue,
      },
      {
        'title': 'Pelanggan - 05 Nov 2022',
        'description': 'Pesanan dibatalkan',
        'icon': Icons.cancel,
        'color': Colors.red,
      },
      {
        'title': 'MontirKu - 05 Nov 2022',
        'description': 'Pesanan selesai',
        'icon': Icons.done_all,
        'color': Colors.green,
      },
    ];

    if (status == 'Dalam perjalanan') {
      return allStatus
          .where((item) =>
              item['description'] == 'Pesanan dalam perjalanan' ||
              item['description'] == 'Pesanan sudah diverifikasi')
          .toList();
    } else if (status == 'Pesanan dibatalkan') {
      return allStatus
          .where((item) =>
              item['description'] == 'Pesanan sudah diverifikasi' ||
              item['description'] == 'Pesanan dibatalkan')
          .toList();
    } else if (status == 'Pesanan selesai') {
      return allStatus
          .where((item) =>
              item['description'] == 'Pesanan sudah diverifikasi' ||
              item['description'] == 'Pesanan dalam perjalanan' ||
              item['description'] == 'Pesanan sudah diterima pelanggan' ||
              item['description'] == 'Pesanan selesai')
          .toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final filteredStatus = _getFilteredStatus(pesanan['status']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pesanan',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: filteredStatus.map<Widget>((status) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: status['color'],
                          child: Icon(
                            status['icon'],
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        if (filteredStatus.last != status)
                          Container(
                            height: 40,
                            width: 2,
                            color: Colors.grey[300],
                          ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status['title'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: status['color'],
                            ),
                          ),
                          Text(
                            status['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
