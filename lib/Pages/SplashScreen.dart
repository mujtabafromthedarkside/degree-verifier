import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to the next screen
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the next screen after some time

      Navigator.pushNamed(context, '/DegreeVerifier');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Build the SplashScreen UI
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          // TopSplashDesign(),
          // BottomSplashDesign(),
          Center(
            child: Image.asset(
              'lib/assets/our_logo.png',
              width: 300,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Positioned(
          //   top: 0,
          //   child: Image.asset(
          //     'lib/assets/images/Background.png',
          //     width: size.width,
          //     fit: BoxFit.fitWidth,
          //   ),
          // ),
        ]));
  }
}
