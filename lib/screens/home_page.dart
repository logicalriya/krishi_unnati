import 'package:flutter/material.dart';
import 'crop_health_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;

  // ----------------------------------------------------------
  // NAVIGATION
  // ----------------------------------------------------------

  void openCropHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CropHealthPage(),
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

  // ----------------------------------------------------------
  // BOTTOM NAVIGATION
  // ----------------------------------------------------------

  void onBottomNavigation(int index) {
    setState(() {
      selectedBottomIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        openCropHealth();
        break;

      case 2:
        showComingSoon('Live Camera');
        break;

      case 3:
        showComingSoon('Advice / Help');
        break;

      case 4:
        showComingSoon('Nearby');
        break;
    }
  }

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

              // =================================================
              // HEADER
              // =================================================

              _buildHeader(),

              // =================================================
              // STATUS BAR
              // =================================================

              _buildStatusBar(),

              // =================================================
              // FARMER PROFILE
              // =================================================

              _buildFarmerProfile(),

              // =================================================
              // CHECK MY CROP
              // =================================================

              _buildSectionTitle(
                icon: Icons.crop_free,
                title: 'CHECK MY CROP',
              ),

              _buildSecureFieldCheck(),

              // =================================================
              // CROP TOOLS
              // =================================================

              _buildCropTools(),

              // =================================================
              // GET HELP
              // =================================================

              _buildSectionTitle(
                icon: Icons.help_outline,
                title: 'GET HELP',
              ),

              _buildHelpTools(),

              // =================================================
              // LOCAL & OFFLINE
              // =================================================

              _buildSectionTitle(
                icon: Icons.location_on_outlined,
                title: 'LOCAL & OFFLINE',
              ),

              _buildLocalTools(),

              // =================================================
              // TODAY'S ALERTS
              // =================================================

              _buildAlerts(),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      // =========================================================
      // BOTTOM NAVIGATION
      // =========================================================

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFDDF9E7),
      padding: const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        12,
      ),
      child: Column(
        children: [

          const Text(
            'KRISHI UNNATI',
            style: TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
              color: Color(0xFF0BA951),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [

              const Expanded(
                child: Text(
                  "Farmer's Dashboard",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF303030),
                  ),
                ),
              ),

              // LANGUAGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF1D5737),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 15,
                      color: Color(0xFF1D5737),
                    ),
                    SizedBox(width: 3),
                    Text(
                      'ENGLISH',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D5737),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 25),

              const Icon(
                Icons.notifications_none,
                size: 25,
                color: Color(0xFF1C1C1C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BAR
  // ============================================================

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5FFF9),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD9EFE1),
          ),
        ),
      ),
      child: Row(
        children: [

          _statusBadge(
            icon: Icons.cloud_off,
            text: 'OFFLINE / 2G SYNC',
          ),

          const SizedBox(width: 8),

          _statusBadge(
            icon: Icons.shield_outlined,
            text: 'SECURE DATA',
          ),
        ],
      ),
    );
  }

  Widget _statusBadge({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9EC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFB8EACB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color(0xFF158B49),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Color(0xFF197342),
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
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        20,
      ),
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

            // FARMER IMAGE / AVATAR
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

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Welcome, Ramesh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF195C36),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      _profileBadge('Village: Solan'),
                      const SizedBox(width: 6),
                      _profileBadge('ID: #8821'),
                    ],
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

  Widget _profileBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBCE8CA),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8,
          color: Color(0xFF198448),
          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        10,
      ),
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
  // SECURE FIELD CHECK
  // ============================================================

  Widget _buildSecureFieldCheck() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCEB),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFF5E8A2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [

            Row(
              children: [

                const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFFB47B00),
                  size: 18,
                ),

                const SizedBox(width: 7),

                const Expanded(
                  child: Text(
                    'Secure Field Check',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF714916),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFECCB50),
                    ),
                  ),
                  child: const Text(
                    'OFFICIAL SECURITY BADGE',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB27B00),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: Container(
                    height: 47,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: const Color(0xFFF0D75A),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Enter Field ID or Name...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF858585),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 48,
                  height: 47,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE873),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFF593D00),
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CROP TOOLS
  // ============================================================

  Widget _buildCropTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        24,
      ),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _featureCard(
                  icon: Icons.camera_alt_outlined,
                  title: 'IMAGE PEST\nDETECTION',
                  subtitle: 'SCAN FROM PHOTO',
                  onTap: () {
                    showComingSoon('Image Pest Detection');
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _featureCard(
                  icon: Icons.bug_report_outlined,
                  title: 'CROP DISEASE\nDETECTION',
                  subtitle: 'CHECK LEAVES',
                  onTap: openCropHealth,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Row(
            children: [

              Expanded(
                child: _featureCard(
                  icon: Icons.videocam_outlined,
                  title: 'LIVE CAMERA PEST',
                  subtitle: 'REAL-TIME SCAN',
                  onTap: () {
                    showComingSoon('Live Camera Pest Detection');
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _featureCard(
                  icon: Icons.biotech_outlined,
                  title: 'SOIL HEALTH\nANALYSIS',
                  subtitle: 'TEST SOIL',
                  onTap: () {
                    showComingSoon('Soil Health Analysis');
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
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        24,
      ),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: _helpCard(
                  icon: Icons.eco_outlined,
                  title: 'DISEASE\nMANAGEMENT',
                  subtitle: 'EXPERT ADVICE',
                  green: true,
                  onTap: () {
                    showComingSoon('Disease Management');
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _helpCard(
                  icon: Icons.person_outline,
                  title: 'EXPERT\nVALIDATION',
                  subtitle: 'TRUST INDICATOR',
                  onTap: () {
                    showComingSoon('Expert Validation');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

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

          const SizedBox(height: 11),

          Row(
            children: [

              Expanded(
                child: _helpCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'REFERRAL HELP',
                  subtitle: 'REQUEST VISIT',
                  onTap: () {
                    showComingSoon('Referral Help');
                  },
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: _helpCard(
                  icon: Icons.warning_amber_outlined,
                  title: 'REPORT ISSUE',
                  subtitle: 'GOVT SUPPORT',
                  onTap: () {
                    showComingSoon('Report Issue');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _helpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool green = false,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          height: 158,
          decoration: BoxDecoration(
            color: green
                ? const Color(0xFF12A650)
                : Colors.white,
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

              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: green
                      ? Colors.white.withOpacity(.18)
                      : const Color(0xFFF0FBF4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: green
                      ? Colors.white
                      : const Color(0xFF202020),
                ),
              ),

              const SizedBox(height: 11),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: green
                      ? Colors.white
                      : const Color(0xFF252934),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: .7,
                  color: green
                      ? const Color(0xFFB9F1CC)
                      : const Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOCAL & OFFLINE
  // ============================================================

  Widget _buildLocalTools() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        24,
      ),
      child: Row(
        children: [

          Expanded(
            child: _featureCard(
              icon: Icons.map_outlined,
              title: 'PEST MAP',
              subtitle: 'DISEASE AREAS',
              onTap: () {
                showComingSoon('Pest Map');
              },
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: _featureCard(
              icon: Icons.inventory_2_outlined,
              title: 'NEARBY MARKET',
              subtitle: 'GET WHAT YOU NEED',
              onTap: () {
                showComingSoon('Nearby Market');
              },
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
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
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
                  onTap: () {
                    showComingSoon('All Alerts');
                  },
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              children: [

                _alertCard(
                  icon: Icons.eco_outlined,
                  title: 'Monsoon Care',
                  description:
                      'Check wheat crops for yellow rust after rain.',
                  green: true,
                ),

                const SizedBox(width: 11),

                _alertCard(
                  icon: Icons.shield_outlined,
                  title: 'Pest Alert',
                  description:
                      'Local pest activity detected nearby.',
                  green: false,
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

      onDestinationSelected:
          onBottomNavigation,

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
            Icons.camera_alt_outlined,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.camera_alt,
            color: Color(0xFF00A650),
          ),
          label: 'Scan',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.videocam_outlined,
            color: Color(0xFF6C7471),
          ),
          selectedIcon: Icon(
            Icons.videocam,
            color: Color(0xFF00A650),
          ),
          label: 'Live Camera',
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
          label: 'Advice/Help',
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
      ],
    );
  }
}