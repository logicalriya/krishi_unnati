import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/bottom_nav.dart';
import '../../state/app_locale.dart';
import '../../state/app_session.dart';
import '../../welcome/startup.dart';
import 'crop_health_page.dart';
import 'soil_health_hub_page.dart';
import 'pest_alert_page.dart';
import 'help_assistance_page.dart';
import 'marketplace_page.dart';
import 'farmer_profile_page.dart';
import 'farmer_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedBottomIndex = 0;
  bool accessibilityMode = false;

  String _liveLocationText = 'Getting your location...';
  bool _liveLocationLoading = true;

  // ============================================================
  // DYNAMIC WEATHER DATA
  // ============================================================

  String temperature = '--°C';
  String weatherCondition = 'Loading...';

  // ============================================================
  // DYNAMIC ALERT DATA
  // ============================================================

  List<Map<String, String>> pestAlerts = [];

  List<Map<String, String>> weatherAlerts = [];

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadLiveLocation();
  }

  // ============================================================
  // LIVE LOCATION
  // ============================================================

  Future<void> _loadLiveLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _liveLocationText = 'Location services are off';
          _liveLocationLoading = false;
        });

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _liveLocationText = 'Location permission denied';
          _liveLocationLoading = false;
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      final Placemark? place =
          placemarks.isNotEmpty ? placemarks.first : null;

      final area = [
        place?.subLocality,
        place?.locality,
        place?.administrativeArea,
      ]
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .join(', ');

      setState(() {
        _liveLocationText =
            area.isNotEmpty ? area : 'Live location detected';
        _liveLocationLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _liveLocationText = 'Unable to get live location';
        _liveLocationLoading = false;
      });
    }
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
        builder: (context) => const SoilHealthHubPage(),
      ),
    );
  }

  void openHelpAssistance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpAssistancePage(),
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
  // OPEN ALL ALERTS
  // ============================================================

  void openAllAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlertsPage(
          pestAlerts: pestAlerts,
          weatherAlerts: weatherAlerts,
        ),
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
  }

  // ============================================================
  // BUILD HOME TAB
  // ============================================================

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            _buildHeader(),
            _buildAccessibilityBar(),
            _buildFarmerHome(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FBF6),
      body: IndexedStack(
        index: selectedBottomIndex,
        children: [
          _buildHomeTab(),
          const PestAlertPage(embedded: true),
          const MarketplacePage(embedded: true),
          const HelpAssistancePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Future<void> _logout() async {
    final session = AppSession.of(context);

    await session.logout();

    if (!mounted) return;

    Navigator.of(context).pop();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const StartupPage(),
      ),
      (route) => false,
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FarmerProfilePage(),
      ),
    );
  }

  Widget _buildHeader() {
    final t = AppLocale.of(context).t;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD0D3D7),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t('appName'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF195B37),
              ),
            ),
          ),
          IconButton(
            onPressed: _openProfile,
            icon: const Icon(
              Icons.settings_outlined,
              size: 22,
              color: Color(0xFF20252B),
            ),
            tooltip: t('settings'),
          ),
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
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD0D3D7),
          ),
        ),
      ),
      child: Row(
        children: [
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
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
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
    final user = AppSession.of(context).user;

    final fullName =
        (user?['fullName'] ?? 'Farmer').toString();

    final village =
        (user?['village'] ?? '').toString().trim();

    final district =
        (user?['district'] ?? '').toString().trim();

    final registeredLocation = [
      village,
      district,
    ]
        .where((value) => value.isNotEmpty)
        .join(', ');

    final displayLocation = _liveLocationLoading
        ? (registeredLocation.isNotEmpty
            ? registeredLocation
            : 'Maharashtra, India')
        : (_liveLocationText ==
                    'Location permission denied' ||
                _liveLocationText ==
                    'Location services are off' ||
                _liveLocationText ==
                    'Unable to get live location'
            ? (registeredLocation.isNotEmpty
                ? registeredLocation
                : 'Maharashtra, India')
            : _liveLocationText);

    final greetingName = fullName.isEmpty
        ? 'Farmer'
        : fullName
            .split(RegExp(r'\s+'))
            .take(2)
            .join(' ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        14,
        12,
        0,
      ),
      child: Column(
        children: [
          _buildWeatherInformationCard(
            displayLocation: displayLocation,
            greetingName: greetingName,
          ),

          const SizedBox(height: 14),

          // QUICK ACTION CARDS

          Row(
            children: [
              Expanded(
                child: _dashboardButton(
                  icon: Icons.eco_outlined,
                  iconBackground:
                      const Color(0xFFE0F7E9),
                  title: 'Find Pest\nor Diseases',
                  onTap: openCropHealth,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dashboardButton(
                  icon: Icons.biotech_outlined,
                  iconBackground:
                      const Color(0xFFE0F7E9),
                  title: 'Check Your\nSoil Health',
                  onTap: openSoilHealth,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _dashboardButton(
                  icon: Icons.wb_sunny_outlined,
                  iconBackground:
                      const Color(0xFFFFF4D8),
                  title: "Check Today's\nWeather",
                  onTap: () {
                    showComingSoon(
                      "Today's Weather",
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dashboardButton(
                  icon: Icons.history,
                  iconBackground:
                      const Color(0xFFE0F7E9),
                  title:
                      'Check Your History\n(last 30 days)',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const FarmerHistoryPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // TODAY'S ALERTS

          _buildTodaysAlerts(),

          const SizedBox(height: 14),

          // ASK A QUESTION

          _buildAskQuestion(),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ============================================================
  // WEATHER INFORMATION CARD
  // ============================================================

  Widget _buildWeatherInformationCard({
    required String displayLocation,
    required String greetingName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        14,
        13,
        14,
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFDDE9E1),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xFF2E9E5B),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  displayLocation,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E9E5B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            'Hello, $greetingName!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Ready to get the best crop?',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF555D63),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFF1FBF5),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDF5E6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined,
                    size: 23,
                    color: Color(0xFF2E9E5B),
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Today's Weather",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E9E5B),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    Text(
                      weatherCondition,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF555D63),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY'S ALERTS
  // ============================================================

  Widget _buildTodaysAlerts() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Today's Alerts",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: openAllAlerts,
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E9E5B),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 92,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics:
                const BouncingScrollPhysics(),
            children: [
              ...pestAlerts.map(
                (alert) => Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 9,
                  ),
                  child: _alertCard(
                    icon:
                        Icons.bug_report_outlined,
                    iconColor:
                        const Color(0xFFE68A00),
                    backgroundColor:
                        const Color(0xFFFFF8E7),
                    title:
                        alert['title'] ??
                            'Pest Alert',
                    subtitle:
                        alert['message'] ?? '',
                    type: 'Pest Alert',
                  ),
                ),
              ),

              ...weatherAlerts.map(
                (alert) => Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 9,
                  ),
                  child: _alertCard(
                    icon:
                        Icons.cloud_outlined,
                    iconColor:
                        const Color(0xFF2E7D9E),
                    backgroundColor:
                        const Color(0xFFEAF7FB),
                    title:
                        alert['title'] ??
                            'Weather Alert',
                    subtitle:
                        alert['message'] ?? '',
                    type: 'Weather Alert',
                  ),
                ),
              ),

              if (pestAlerts.isEmpty &&
                  weatherAlerts.isEmpty)
                _emptyAlertCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _alertCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required String type,
  }) {
    return Container(
      width: 210,
      height: 88,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE1E8E3),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF6C7471),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyAlertCard() {
    return Container(
      width: 210,
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE1E8E3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_none,
            color: Color(0xFF2E9E5B),
            size: 25,
          ),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'No alerts for today',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555D63),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ASK A QUESTION
  // ============================================================

  Widget _buildAskQuestion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDCE5DF),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF2E9E5B),
                  size: 19,
                ),
              ),

              const SizedBox(width: 9),

              const Text(
                'Ask a Question',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            padding:
                const EdgeInsets.fromLTRB(
              8,
              8,
              8,
              9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE8),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 2),
                  child: Text(
                    'ASK EXPERTS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF814B18),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(9),
                    border: Border.all(
                      color:
                          const Color(0xFFFFD940),
                    ),
                  ),
                  child: const TextField(
                    style: TextStyle(
                      fontSize: 11,
                    ),
                    decoration:
                        InputDecoration(
                      hintText:
                          'What you want to know...',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color:
                            Color(0xFF7C8187),
                      ),
                      border:
                          InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 8,
                      ),
                      suffixIcon: Icon(
                        Icons.mic_none,
                        size: 21,
                        color:
                            Color(0xFF444A51),
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
        height: 82,
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFDCE5DF),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 20,
                color: const Color(0xFF2E9E5B),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                height: 1.15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return KrishiBottomNav(
      selectedIndex: selectedBottomIndex,
      onDestinationSelected: onBottomNavigation,
    );
  }
}

// ==================================================================
// ALL ALERTS PAGE
// ==================================================================

class AlertsPage extends StatelessWidget {
  final List<Map<String, String>> pestAlerts;
  final List<Map<String, String>> weatherAlerts;

  const AlertsPage({
    super.key,
    required this.pestAlerts,
    required this.weatherAlerts,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> allAlerts = [
      ...pestAlerts.map(
        (alert) => {
          ...alert,
          'type': 'Pest Alert',
        },
      ),
      ...weatherAlerts.map(
        (alert) => {
          ...alert,
          'type': 'Weather Alert',
        },
      ),
    ];

    return Scaffold(
      backgroundColor:
          const Color(0xFFF1FBF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Today's Alerts",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172033),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF172033),
        ),
      ),
      body: allAlerts.isEmpty
          ? const Center(
              child: Text(
                'No alerts available',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C7471),
                ),
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              physics:
                  const BouncingScrollPhysics(),
              itemCount: allAlerts.length,
              itemBuilder:
                  (context, index) {
                final alert =
                    allAlerts[index];

                final bool isPest =
                    alert['type'] ==
                        'Pest Alert';

                return Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  padding:
                      const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                    border: Border.all(
                      color:
                          const Color(0xFFDDE8E0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Color(0x0A000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration:
                            BoxDecoration(
                          color: isPest
                              ? const Color(
                                  0xFFFFF4D8,
                                )
                              : const Color(
                                  0xFFEAF7FB,
                                ),
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Icon(
                          isPest
                              ? Icons
                                  .bug_report_outlined
                              : Icons
                                  .cloud_outlined,
                          color: isPest
                              ? const Color(
                                  0xFFE68A00,
                                )
                              : const Color(
                                  0xFF2E7D9E,
                                ),
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 11),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              alert['type'] ??
                                  'Alert',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color: isPest
                                    ? const Color(
                                        0xFFE68A00,
                                      )
                                    : const Color(
                                        0xFF2E7D9E,
                                      ),
                              ),
                            ),

                            const SizedBox(
                                height: 3),

                            Text(
                              alert['title'] ??
                                  'Alert',
                              style:
                                  const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color: Color(
                                  0xFF172033,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              alert['message'] ??
                                  '',
                              style:
                                  const TextStyle(
                                fontSize: 10,
                                color: Color(
                                  0xFF60686D,
                                ),
                              ),
                            ),

                            if (alert['time'] !=
                                null) ...[
                              const SizedBox(
                                  height: 6),
                              Text(
                                alert['time']!,
                                style:
                                    const TextStyle(
                                  fontSize: 8,
                                  color: Color(
                                    0xFF89908C,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}