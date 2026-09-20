import 'package:flutter/material.dart';

class KrishiBottomNav extends StatelessWidget {
  const KrishiBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      backgroundColor: const Color(0xFFE1FBEA),
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      selectedIndex: selectedIndex,
      indicatorColor: Colors.transparent,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        // HOME
        NavigationDestination(
          icon: Icon(Icons.eco_outlined, color: Color(0xFF6C7471)),
          selectedIcon: Icon(Icons.eco, color: Color(0xFF00A650)),
          label: 'Home',
        ),

        // PEST MAP
        NavigationDestination(
          icon: Icon(Icons.map_outlined, color: Color(0xFF6C7471)),
          selectedIcon: Icon(Icons.map, color: Color(0xFF00A650)),
          label: 'Pest Map',
        ),

        // MARKETPLACE
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined, color: Color(0xFF6C7471)),
          selectedIcon: Icon(Icons.shopping_cart, color: Color(0xFF00A650)),
          label: 'Marketplace',
        ),

        // HELP
        NavigationDestination(
          icon: Icon(Icons.help_outline, color: Color(0xFF6C7471)),
          selectedIcon: Icon(Icons.help, color: Color(0xFF00A650)),
          label: 'Help',
        ),
      ],
    );
  }
}
