import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:montirku/pages/bengkel/dashboard.dart';
import 'package:montirku/pages/montir/homePage.dart';
import 'package:montirku/pages/pelanggan/beranda.dart';

class AuthService {
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://starink-92d82-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // Fungsi login utama
  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Hash password yang dimasukkan
      String hashedPassword = _hashPassword(password);

      // Cari email di tb_users
      final snapshot = await _db
          .child('tb_users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value == null) {
        _showDialog(context, "Login Gagal", "Email tidak ditemukan.");
        return;
      }

      // Ambil data user
      final userData = (snapshot.snapshot.value as Map).values.first;
      if (userData['password'] != hashedPassword) {
        _showDialog(context, "Login Gagal", "Password salah.");
        return;
      }

      // Periksa peran berdasarkan ID yang tersedia
      if (userData['id_bengkel'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else if (userData['id_montir'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MontirHomePage()),
        );
      } else if (userData['id_pelanggan'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BerandaPelanggan(
                    idPelanggan: userData['id_pelanggan'],
                  )),
        );
      } else {
        _showDialog(context, "Login Gagal", "Akun tidak memiliki peran.");
      }
    } catch (e) {
      _showDialog(context, "Error", "Terjadi kesalahan: $e");
    }
  }

  // Fungsi untuk menampilkan dialog error
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk hashing password menggunakan SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
