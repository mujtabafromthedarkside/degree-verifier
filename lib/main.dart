import 'package:flutter/material.dart';
import 'package:degree_verifier/Pages/DegreeVerifier.dart';
import 'package:degree_verifier/Pages/DegreeGenerator.dart';
import 'package:degree_verifier/Pages/SplashScreen.dart';
import 'package:degree_verifier/Pages/Degree.dart';

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
        '/AddDegree': (context) => const DegreeGenerator(title: "Add Degree",),
        '/Degree': (context) => const Degree(),
      },
    );
  }
}