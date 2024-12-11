import 'package:flutter/material.dart';

class RiwayatPelanggan extends StatefulWidget {
  @override
  _RiwayatPelangganState createState() => _RiwayatPelangganState();
}

class _RiwayatPelangganState extends State<RiwayatPelanggan> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  horizontal: -40, // Ukuran horizontal untuk mengatur lebar warna biru
                ),
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 4, // Padding untuk jarak teks
                ),
                labelColor: Colors.white, // Warna teks untuk tab aktif
                unselectedLabelColor: Colors.black, // Warna teks untuk tab tidak aktif
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
                  _buildHistoryList(),
                  // Derek Tab
                  Center(child: Text("Riwayat Derek kosong.")),
                  // Belanja Tab
                  Center(child: Text("Riwayat Belanja kosong.")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView(
      children: [
        // Grouped by Date
        const Text(
          "11 Nov 2022",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildHistoryCard(
          title: "Servis kendaraan",
          subtitle: "11 Nov 2022 · Sedang di servis",
          color: Colors.yellow,
        ),
        const SizedBox(height: 16),
        const Text(
          "05 Nov 2022",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildHistoryCard(
          title: "Servis kendaraan",
          subtitle: "5 Nov 2022 · Servis dibatalkan",
          color: Colors.red,
        ),
        const SizedBox(height: 8),
        _buildHistoryCard(
          title: "Servis kendaraan",
          subtitle: "5 Nov 2022 · Servis berhasil",
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        const Text(
          "03 Nov 2022",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildHistoryCard(
          title: "Servis kendaraan",
          subtitle: "3 Nov 2022 · Servis berhasil",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildHistoryCard({required String title, required String subtitle, required Color color}) {
    return Container(
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
