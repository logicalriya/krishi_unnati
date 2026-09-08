import 'package:flutter/material.dart';
import 'screens/home_page.dart';



void main() {
  runApp(const CropHealthApp());
}

class CropHealthApp extends StatelessWidget {
  const CropHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Health',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3FBF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF20A963),
        ),
      ),
      home: const HomePage(),
    );
  }
}