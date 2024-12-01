import 'package:flutter/material.dart';
import 'pages/montir/homePage.dart';

void main() {
  runApp(const MontirApp());
}

class MontirApp extends StatelessWidget {
  const MontirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MontirHomePage(),
    );
  }
}
