import 'package:flutter/material.dart';
import 'screens/startup.dart';

void main() {
  runApp(const CropHealthApp());
}

class CropHealthApp extends StatelessWidget {
  const CropHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi Unnati',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3FBF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF20A963),
        ),
      ),

      // First screen when app opens
      home: const StartupPage(),
    );
  }
}