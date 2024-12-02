import 'package:flutter/material.dart';
import 'package:degree_verifier/DegreeVerifier.dart';
import 'package:degree_verifier/DegreeGenerator.dart';
import 'package:degree_verifier/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Degree Verification System Using Blockchain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/DegreeVerifier': (context) => const DegreeVerifier(title: "Verify Degree",),
        '/DegreeGenerator': (context) => const DegreeGenerator(title: "Generate Degree",),
      },
    );
  }
}