import 'package:flutter/material.dart';
import 'package:montirku/pages/bengkel/detailPesanan.dart';

class RiwayatPesananPage extends StatefulWidget {
  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _riwayatPesanan = [
    {
      'date': '11 Nov 2022',
      'items': [
        {
          'name': 'CVT Yamaha X-Ride',
          'status': 'Dalam perjalanan',
          'iconColor': Colors.yellow,
          'icon': Icons.directions_bike,
        },
      ],
    },
    {
      'date': '05 Nov 2022',
      'items': [
        {
          'name': 'Ban Supra-X',
          'status': 'Pesanan dibatalkan',
          'iconColor': Colors.red,
          'icon': Icons.cancel,
        },
        {
          'name': 'Oli NMAX-155',
          'status': 'Pesanan selesai',
          'iconColor': Colors.green,
          'icon': Icons.check_circle,
        },
      ],
    },
    {
      'date': '03 Nov 2022',
      'items': [
        {
          'name': 'CVT Yamaha X-Ride',
          'status': 'Pesanan selesai',
          'iconColor': Colors.green,
          'icon': Icons.check_circle,
        },
      ],
    },
  ];

  List<Map<String, dynamic>> _filteredPesanan = [];

  @override
  void initState() {
    super.initState();
    _filteredPesanan = _riwayatPesanan; // Awalnya tampilkan semua data
  }

  void _filterRiwayatPesanan(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPesanan = _riwayatPesanan;
      });
      return;
    }

    final filtered = _riwayatPesanan
        .map((riwayat) {
          final filteredItems = (riwayat['items'] as List).where((item) {
            final name = item['name'].toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();

          if (filteredItems.isNotEmpty) {
            return {
              'date': riwayat['date'],
              'items': filteredItems,
            };
          }
          return null;
        })
        .where((riwayat) => riwayat != null)
        .toList();

    setState(() {
      _filteredPesanan = filtered.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter dan Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterRiwayatPesanan(value),
                    decoration: InputDecoration(
                      hintText: 'Cari riwayat pesanan',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Daftar Riwayat Pesanan
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPesanan.length,
                itemBuilder: (context, index) {
                  final riwayat = _filteredPesanan[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riwayat['date'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      ...riwayat['items'].map<Widget>((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: item['iconColor'],
                              child: Icon(item['icon'], color: Colors.white),
                            ),
                            title: Text(item['name']),
                            subtitle: Text(item['status']),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPesananPage(
                                    pesanan: {
                                      'name': item['name'],
                                      'status':
                                          item['status'], // Status pesanan
                                    },
                                  ),
                                ),
                              );
                              print('Klik item: ${item['name']}');
                            },
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 16),
                    ],
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
