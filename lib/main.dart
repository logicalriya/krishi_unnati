import 'package:flutter/material.dart';
import 'welcome/startup.dart';
import 'screens/farmers/farmer_dashboard.dart';
import 'state/app_locale.dart';
import 'state/app_session.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await FirebaseBootstrap.tryInitialize();

  runApp(const CropHealthApp());
}

class CropHealthApp extends StatelessWidget {
  const CropHealthApp({super.key});

  @override
  Widget build(BuildContext context) {


    return AppLocaleProvider(
      child: AppSessionProvider(
        child: MaterialApp(
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

          home: const AppEntryPage(),
        ),
      ),
    );
  }
}

class AppEntryPage extends StatelessWidget {
  const AppEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = AppSession.of(context);

    if (!session.loaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (session.isLoggedIn && session.user?['role'] == 'farmer') {
      return const HomePage();
    }

    return const StartupPage();
  }
}