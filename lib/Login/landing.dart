import 'package:flutter/material.dart';
import 'pilihdaftar.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });

    // Tampilan Splash Screen
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEF9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_rounded,
              size: 100,
              color: const Color(0xFF007EA7),
            ),
            const SizedBox(height: 20),
            const Text(
              'MontirKu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00171F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFBBDEF9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.05, left: screenWidth * 0.05),
            child: Row(
              children: [
                Icon(
                  Icons.build_rounded,
                  size: 25,
                  color: const Color(0xFF007EA7),
                ),
                SizedBox(
                  width: screenWidth * 0.03,
                ),
                Text(
                  'MontirKu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00171F),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.build_rounded,
                  size: 50,
                  color: const Color(0xFF007EA7),
                ),
                // Container(
                //   width: screenWidth * 0.6,
                //   height: screenHeight * 0.3,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('assets/car.png'),
                //       fit: BoxFit.contain,
                //     ),
                //   ),
                // ),
                SizedBox(height: screenHeight * 0.02),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Servis kendaraanmu kapanpun, dimanapun',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF00171F),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.06, horizontal: screenWidth * 0.1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PilihDaftar(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Color(0xFF007EA7),
                    ),
                    child: const Text('Daftar',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xffECECEC),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Atau',
                        style: TextStyle(color: Color(0xff797979)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xffECECEC),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.06,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
