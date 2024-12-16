import 'package:flutter/material.dart';
// import 'package:montirku/pages/montir/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:montirku/pages/login/landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan binding dijalankan sebelum inisialisasi
  try {
    await Firebase.initializeApp(); // Inisialisasi Firebase
    print("Koneksi Firebase BERHASIL!");

    // Inisialisasi Firebase Database dengan URL yang benar
    FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          "https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
  } catch (e) {
    print("Koneksi Firebase GAGAL: $e");
  } // Inisialisasi Firebase
  runApp(const MontirApp());
}

class MontirApp extends StatelessWidget {
  const MontirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Montir App',
      home: const SplashScreen(),
    );
  }
}
