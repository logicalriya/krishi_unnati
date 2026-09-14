import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'crop_health_page.dart';
import 'soil_health_page.dart';
import 'pest_alert_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;
  String selectedLanguage = 'English';

  // ============================================================
  // LANGUAGE SELECTOR
  // ============================================================

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
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
              _languageOption(
                'English',
                'English',
              ),
              _languageOption(
                'বাংলা',
                'Bengali',
              ),
              _languageOption(
                'मराठी',
                'Marathi',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(
    String displayName,
    String languageName,
  ) {
    final bool isSelected =
        selectedLanguage == languageName;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: const Color(0xFF0BA951),
      ),
      title: Text(
        displayName,
        style: TextStyle(
          fontSize: 15,
          fontWeight:
              isSelected ? FontWeight.w800 : FontWeight.w600,
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
      MaterialPageRoute(
        builder: (context) => const CropHealthPage(),
      ),
    );
  }

  void openPestAlert() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PestAlertPage(),
      ),
    );
  }

  void openSoilHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SoilHealthPage(),
      ),
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
        // ADVICE / HELP
        showComingSoon('Advice / Help');
        break;

      case 2:
        // NEARBY
        showComingSoon('Nearby');
        break;

      case 3:
        // PEST MAP
        openPestAlert();
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

              // FARMER PROFILE
              _buildFarmerProfile(),

              // CROP TOOLS
              _buildCropTools(),

              // GET HELP
              _buildSectionTitle(
                icon: Icons.help_outline,
                title: 'GET HELP',
              ),

              _buildHelpTools(),

              // TODAY'S ALERTS
              _buildAlerts(),

              const SizedBox(height: 25),
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
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFDDF9E7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // LOGO CIRCLE
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.agriculture,
              size: 27,
              color: Color(0xFF0BA951),
            ),
          ),

          const SizedBox(width: 12),

          // APP NAME
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KRISHI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                    color: Color(0xFF195B37),
                  ),
                ),
                Text(
                  'UNNATI',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    height: .95,
                    color: Color(0xFF0BA951),
                  ),
                ),
              ],
            ),
          ),

          // LANGUAGE BUTTON
          GestureDetector(
            onTap: _showLanguageSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFB9E6C8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.language,
                    size: 15,
                    color: Color(0xFF1D5737),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    selectedLanguage == 'English'
                        ? 'EN'
                        : selectedLanguage == 'Bengali'
                            ? 'BN'
                            : 'MR',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D5737),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: Color(0xFF1D5737),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // NOTIFICATION
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFB9E6C8),
              ),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 21,
              color: Color(0xFF1C1C1C),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FARMER PROFILE
  // ============================================================

  Widget _buildFarmerProfile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // FARMER AVATAR
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE5F7EB),
                border: Border.all(
                  color: const Color(0xFFCAEBD7),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.agriculture,
                size: 32,
                color: Color(0xFF27864B),
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Ramesh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF195C36),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Ready to take care of your crops?',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFF00A651),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: const BoxDecoration(
              color: Color(0xFFDDF8E8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF0AA552),
            ),
          ),

          const SizedBox(width: 9),

          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF195B37),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CROP TOOLS
  // ============================================================

  Widget _buildCropTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          // ROW 1
          Row(
            children: [
              Expanded(
                child: _featureCard(
                  icon: Icons.camera_alt_outlined,
                  title: 'IMAGE PEST\nDETECTION',
                  subtitle: 'SCAN FROM PHOTO',
                  onTap: openCropHealth,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _featureCard(
                  icon: Icons.biotech_outlined,
                  title: 'SOIL HEALTH\nANALYSIS',
                  subtitle: 'TEST SOIL',
                  onTap: openSoilHealth,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // ROW 2
          Row(
            children: [
              Expanded(
                child: _featureCard(
                  icon: Icons.videocam_outlined,
                  title: 'LIVE CAMERA PEST',
                  subtitle: 'REAL-TIME SCAN',
                  onTap: () {
                    showComingSoon(
                      'Live Camera Pest Detection',
                    );
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _featureCard(
                  icon: Icons.wb_sunny_outlined,
                  title: 'WEATHER\nADVISORY',
                  subtitle: 'LOCAL FORECAST',
                  onTap: () {
                    showComingSoon('Weather Advisory');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          height: 159,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FBF4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: Color(0xFF252934),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  letterSpacing: .8,
                  color: Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GET HELP
  // ============================================================

  Widget _buildHelpTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          // VOICE SUPPORT
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              onTap: () {
                showComingSoon('Voice Support');
              },
              child: Container(
                height: 96,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDD62),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.mic_none,
                      size: 30,
                      color: Color(0xFF533800),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'VOICE SUPPORT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF533800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY'S ALERTS
  // ============================================================

  Widget _buildAlerts() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.grass,
                  size: 18,
                  color: Color(0xFF11934B),
                ),

                const SizedBox(width: 7),

                const Expanded(
                  child: Text(
                    "TODAY'S ALERTS",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF198047),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: openPestAlert,
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0CA34E),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 91,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _alertCard(
                  icon: Icons.eco_outlined,
                  title: 'Monsoon Care',
                  description:
                      'Check wheat crops for yellow rust after rain.',
                  green: true,
                ),

                const SizedBox(width: 11),

                GestureDetector(
                  onTap: openPestAlert,
                  child: _alertCard(
                    icon: Icons.shield_outlined,
                    title: 'Pest Alert',
                    description:
                        'Local pest activity detected nearby.',
                    green: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertCard({
    required IconData icon,
    required String title,
    required String description,
    required bool green,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: green
            ? const Color(0xFF11A650)
            : const Color(0xFFFFDE63),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.07),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: green
                  ? Colors.white.withOpacity(.18)
                  : Colors.white.withOpacity(.45),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: green
                  ? Colors.white
                  : const Color(0xFF654A00),
              size: 23,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: green
                        ? Colors.white
                        : const Color(0xFF594100),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    height: 1.2,
                    color: green
                        ? const Color(0xFFE2F9E9)
                        : const Color(0xFF725900),
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
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Color(0xFF00A650),
          ),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.help_outline,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.help,
            color: Color(0xFF00A650),
          ),
          label: 'Advice / Help',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.location_on_outlined,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.location_on,
            color: Color(0xFF00A650),
          ),
          label: 'Nearby',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.map_outlined,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.map,
            color: Color(0xFF00A650),
          ),
          label: 'Pest Map',
        ),
      ],
    );
  }
}