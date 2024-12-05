import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'daftarprofil.dart';

class VerifEmail extends StatelessWidget {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  VerifEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verifikasi email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kami mengirimkan kode verifikasi ke\nuser@mail.com',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: screenHeight * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 65, // Perbesar ukuran lebar kotak input
                  height: 80, // Tambahkan tinggi kotak input
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index - 1]);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20), // Sesuaikan padding
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Radius border 16
                        borderSide: const BorderSide(
                          color: Color(0xffEEEEEE), // Warna #EEEEEE
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xffEEEEEE),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color:
                              Color(0xff007EA7), // Warna saat fokus (opsional)
                          width: 2.0,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 30, // Perbesar ukuran teks
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextButton(
              onPressed: () {
                // Tambahkan logika kirim ulang di sini
              },
              child: const Text(
                'Belum menerima kode? Kirim lagi',
                style: TextStyle(color: Color(0xff007EA7)),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(width: screenWidth * 0.015),
                SizedBox(
                  width: screenWidth * 0.14,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: Color(0xffEEEEEE), width: 2),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xff797979), // Warna ikon panah
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                SizedBox(
                  width: screenWidth * 0.65,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarProfil(),
                        ),
                      );
                      String code = _controllers.map((c) => c.text).join();
                      print("Kode verifikasi: $code");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff007EA7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Selanjutnya',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.2),
          ],
        ),
      ),
    );
  }
}
