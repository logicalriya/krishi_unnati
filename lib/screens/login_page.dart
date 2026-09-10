import 'package:flutter/material.dart';
import 'home_page.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.agriculture,
                size: 80,
              ),

              const SizedBox(height: 20),

              const Text(
                'Krishi Unnati',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Select your dashboard',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              // Farmer Dashboard
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.agriculture),
                  label: const Text(
                    'Farmer Dashboard',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HomePage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Admin Dashboard
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text(
                    'Admin Dashboard',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AdminDashboard(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}