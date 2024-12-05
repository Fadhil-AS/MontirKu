import 'package:flutter/material.dart';
// import 'package:montirku/pages/montir/homePage.dart';
import 'package:montirku/pages/login/landing.dart';

void main() {
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
