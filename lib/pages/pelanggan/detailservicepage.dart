import 'package:flutter/material.dart';

class DetailServicePage extends StatefulWidget {
  @override
  _DetailServicePageState createState() => _DetailServicePageState();
}

class _DetailServicePageState extends State<DetailServicePage> {
  Map<String, bool> selectedServices = {
    "Ganti Oli Mesin": false,
    "Ganti Oli Gardan": false,
  };

  double totalCost = 0.0;
  double mechanicFee = 50000.0; // Biaya montir
  double appFee = 10000.0; // Biaya aplikasi
  Map<String, double> servicePrices = {
    "Ganti Oli Mesin": 150000.0,
    "Ganti Oli Gardan": 100000.0,
  };

  TextEditingController notesController = TextEditingController();

  void _updateTotalCost() {
    double serviceCost = selectedServices.entries
        .where((entry) => entry.value)
        .map((entry) => servicePrices[entry.key] ?? 0.0)
        .fold(0.0, (sum, element) => sum + element);
    setState(() {
      totalCost = serviceCost + mechanicFee + appFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Layanan:", style: TextStyle(fontSize: 18)),
            ...servicePrices.keys.map((service) {
              return CheckboxListTile(
                title: Text(service),
                value: selectedServices[service],
                onChanged: (value) {
                  setState(() {
                    selectedServices[service] = value ?? false;
                    _updateTotalCost();
                  });
                },
              );
            }).toList(),
            Divider(),
            Text("Total Harga:", style: TextStyle(fontSize: 18)),
            Text("Rp ${totalCost.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Rincian Biaya:"),
            Text("- Biaya Montir: Rp ${mechanicFee.toStringAsFixed(0)}"),
            Text("- Biaya Aplikasi: Rp ${appFee.toStringAsFixed(0)}"),
            SizedBox(height: 20),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Catatan untuk Montir",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implementasi konfirmasi layanan
                print(
                    "Layanan Terpilih: ${selectedServices.entries.where((entry) => entry.value).map((entry) => entry.key).toList()}");
                print("Catatan: ${notesController.text}");
              },
              child: Text("Konfirmasi"),
            ),
          ],
        ),
      ),
    );
  }
}
