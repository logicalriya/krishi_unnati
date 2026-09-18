import 'package:flutter/material.dart';

import '../admins/admin_dashboard.dart';
import 'crop_health_page.dart';
import 'soil_health_page.dart';
import 'pest_alert_page.dart';
import 'help_assistance_page.dart';
import 'marketplace_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;
  String selectedLanguage = 'English';
  bool accessibilityMode = false;

  // ============================================================
  // LANGUAGE SELECTOR
  // ============================================================

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF195B37),
                ),
              ),
              const SizedBox(height: 15),

              _languageOption('English', 'English'),
              _languageOption('বাংলা', 'Bengali'),
              _languageOption('मराठी', 'Marathi'),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String displayName, String languageName) {
    final bool isSelected = selectedLanguage == languageName;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: const Color(0xFF0BA951),
      ),
      title: Text(
        displayName,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: const Color(0xFF303030),
        ),
      ),
      onTap: () {
        setState(() {
          selectedLanguage = languageName;
        });

        Navigator.pop(context);
      },
    );
  }

  // ============================================================
  // PAGE NAVIGATION
  // ============================================================

  void openCropHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CropHealthPage()),
    );
  }

  void openPestAlert() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PestAlertPage()),
    );
  }

  void openSoilHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SoilHealthPage()),
    );
  }

  void openHelpAssistance() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpAssistancePage()),
    );
  }

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void onBottomNavigation(int index) {
    setState(() {
      selectedBottomIndex = index;
    });

    switch (index) {
      case 0:
        // HOME
        break;

      case 1:
        // PEST MAP
        openPestAlert();
        break;

      case 2:
        // MARKETPLACE
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MarketplacePage()),
        );
        break;

      case 3:
        // HELP
        openHelpAssistance();
        break;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFBF5),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              // HEADER
              _buildHeader(),

              // ACCESSIBILITY
              _buildAccessibilityBar(),

              // MAIN FARMER CONTENT
              _buildFarmerHome(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          // BACK BUTTON
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Color(0xFF20252B),
            ),
          ),

          const Spacer(),

          // LOGO
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF2D9B57),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 16),
          ),

          const SizedBox(width: 10),

          // APP NAME
          const Text(
            'Krishi Unnati',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),

          const Spacer(),

          // LANGUAGE
          GestureDetector(
            onTap: _showLanguageSelector,
            child: const Icon(
              Icons.translate,
              size: 24,
              color: Color(0xFF20252B),
            ),
          ),

          const SizedBox(width: 7),

          Text(
            selectedLanguage == 'English'
                ? 'A'
                : selectedLanguage == 'Bengali'
                ? 'অ'
                : 'अ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20252B),
            ),
          ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }

  // ============================================================
  // ACCESSIBILITY BAR
  // ============================================================

  Widget _buildAccessibilityBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F1F3),
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          // ACCESSIBILITY ICON
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E5EA),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.hearing,
              size: 18,
              color: Color(0xFF17375E),
            ),
          ),

          const SizedBox(width: 8),

          // TEXT
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accessibility Mode',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26303A),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'ASSISTANCE TOOLS',
                style: TextStyle(
                  fontSize: 6.5,
                  letterSpacing: .4,
                  color: Color(0xFF6C7075),
                ),
              ),
            ],
          ),

          const Spacer(),

          const Icon(
            Icons.volume_up_outlined,
            size: 16,
            color: Color(0xFF596069),
          ),

          const SizedBox(width: 5),

          Switch(
            value: accessibilityMode,
            onChanged: (value) {
              setState(() {
                accessibilityMode = value;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF0BA951),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FARMER HOME
  // ============================================================

  Widget _buildFarmerHome() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      child: Column(
        children: [
          // ------------------------------------------------------
          // LOCATION + WEATHER
          // ------------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Color(0xFF1E6B38),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Maharashtra, India',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E6B38),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Hello, Ramesh!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Ready to get the best crop?',
                      style: TextStyle(fontSize: 12, color: Color(0xFF454B52)),
                    ),
                  ],
                ),
              ),

              // WEATHER CARD
              Container(
                width: 43,
                height: 53,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD4D7DA)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x15000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 19,
                      color: Color(0xFF17375E),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '32°C',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF20252B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // FIND PEST OR DISEASES
          // ------------------------------------------------------
          _dashboardButton(
            icon: Icons.eco_outlined,
            iconBackground: const Color(0xFFE4E7E9),
            title: 'Find Pest\nor Diseases',
            onTap: openCropHealth,
          ),

          const SizedBox(height: 10),

          // ------------------------------------------------------
          // SOIL HEALTH
          // ------------------------------------------------------
          _dashboardButton(
            icon: Icons.biotech_outlined,
            iconBackground: const Color(0xFFCCFFF0),
            title: 'Check Your\nSoil Health',
            onTap: openSoilHealth,
          ),

          const SizedBox(height: 29),

          // ------------------------------------------------------
          // ASK A QUESTION
          // ------------------------------------------------------
          _buildAskQuestion(),

          const SizedBox(height: 15),

          // ------------------------------------------------------
          // HISTORY
          // ------------------------------------------------------
          GestureDetector(
            onTap: () {
              showComingSoon('History');
            },
            child: Container(
              height: 42,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC7CBD0), width: 1.3),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),

                  Icon(Icons.history, size: 26, color: Color(0xFF172033)),

                  SizedBox(width: 8),

                  Text(
                    'HISTORY (last 30 days)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF172033),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "Need any help?" REMOVED
        ],
      ),
    );
  }

  // ============================================================
  // DASHBOARD BUTTON
  // ============================================================

  Widget _dashboardButton({
    required IconData icon,
    required Color iconBackground,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFC7CBD0), width: 1.3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 19),

            // ICON
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: const Color(0xFF263F35)),
            ),

            const Spacer(),

            // TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),

            const Spacer(),

            const SizedBox(width: 19),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ASK QUESTION
  // ============================================================

  Widget _buildAskQuestion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFC7CBD0), width: 1.3),
      ),
      child: Column(
        children: [
          // ASK A QUESTION TITLE
          Row(
            children: [
              Container(
                height: 33,
                width: 33,
                decoration: const BoxDecoration(
                  color: Color(0xFF17375E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 19,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Ask a Question',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ASK EXPERTS AREA
          Container(
            padding: const EdgeInsets.fromLTRB(7, 8, 7, 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE8),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    'ASK EXPERTS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF814B18),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // QUESTION FIELD
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFFFFD940)),
                  ),
                  child: const TextField(
                    style: TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      hintText: 'What you want to know...',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C8187),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 8,
                      ),
                      suffixIcon: Icon(
                        Icons.mic_none,
                        size: 21,
                        color: Color(0xFF444A51),
                      ),
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

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return NavigationBar(
      height: 72,
      backgroundColor: const Color(0xFFE1FBEA),
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      selectedIndex: selectedBottomIndex,
      indicatorColor: Colors.transparent,
      onDestinationSelected: onBottomNavigation,

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
