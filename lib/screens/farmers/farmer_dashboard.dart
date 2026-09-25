import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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


  bool _weatherInitStarted = false;


  bool _locationResolved = false;
  bool _weatherResolved = false;


  int _retryCount = 0;
  static const int _maxRetries = 1;

  // ============================================================
  // LIVE WEATHER DATA (Open-Meteo — no API key required)
  // ============================================================

  String temperature = '--°C';
  String weatherCondition = 'Loading...';

  // ============================================================
  // LOCATION & WEATHER PIPELINE (NO HARDCODED DEFAULTS)
  // ============================================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    final session = AppSession.of(context);
    if (!_weatherInitStarted && session.loaded) {
      _weatherInitStarted = true;
      _initLocationAndWeather();
    }
  }

  Future<void> _initLocationAndWeather() async {
    final session = AppSession.of(context);
    final user = session.user;

    final village = (user?['village'] ?? '').toString().trim();
    final district = (user?['district'] ?? '').toString().trim();
    final registeredLocation =
    [village, district].where((s) => s.isNotEmpty).join(', ');

    // STEP 1: IMMEDIATELY FETCH WEATHER FOR REGISTERED DISTRICT/VILLAGE
    if (registeredLocation.isNotEmpty) {
      await _loadWeatherFromRegisteredAddress(village, district);
    }

    // STEP 2: TRY CACHED GPS FIX (FAST)
    try {
      final lastKnown = await Geolocator.getLastKnownPosition()
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      if (lastKnown != null && mounted) {
        _loadWeather(lastKnown.latitude, lastKnown.longitude);
        _fetchPlacemark(lastKnown.latitude, lastKnown.longitude, registeredLocation);
      }
    } catch (_) {}

    // STEP 3: LIVE GPS LOOKUP
    await _requestBackgroundGps(registeredLocation);

    // STEP 4: if, after everything above, we still have nothing resolved
    // (common on a brand-new install: no cached GPS fix yet, cold GPS
    // lock takes too long, and the address geocode may have raced with
    // a slow network on first launch), retry once after a short delay
    // instead of leaving the user stuck on "Location Unavailable".
    if (mounted && !_locationResolved && _retryCount < _maxRetries) {
      _retryCount++;
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && !_locationResolved) {
        await _initLocationAndWeather();
      }
    }
  }


  Future<void> _loadWeatherFromRegisteredAddress(String village, String district) async {
    final locationName = [village, district].where((s) => s.isNotEmpty).join(', ');
    if (locationName.isEmpty) return;

    if (mounted && !_locationResolved) {
      setState(() {
        _liveLocationText = locationName;
      });
    }

    // Attempt 1: Native geocoding lookups for the user's registered location
    final searchQueries = [
      if (village.isNotEmpty && district.isNotEmpty) '$village, $district, India',
      if (district.isNotEmpty) '$district, India',
      if (village.isNotEmpty) '$village, India',
    ];

    for (final query in searchQueries) {
      try {
        final locations = await locationFromAddress(query)
            .timeout(const Duration(seconds: 4), onTimeout: () => []);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          await _loadWeather(loc.latitude, loc.longitude);
          return;
        }
      } catch (_) {}
    }

    // Attempt 2: Geocoding API lookup for the registered city/district name
    final searchName = district.isNotEmpty ? district : village;
    if (searchName.isNotEmpty) {
      try {
        final uri = Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(searchName)}&count=1&language=en&format=json',
        );
        final res = await http.get(uri).timeout(const Duration(seconds: 4));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final results = data['results'] as List?;
          if (results != null && results.isNotEmpty) {
            final lat = (results[0]['latitude'] as num).toDouble();
            final lon = (results[0]['longitude'] as num).toDouble();
            await _loadWeather(lat, lon);
          }
        }
      } catch (_) {}
    }
  }

  Future<void> _requestBackgroundGps(String registeredLocation) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 3), onTimeout: () => false);

      if (!serviceEnabled) {
        _resolveLocationFallback(registeredLocation);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission()
          .timeout(const Duration(seconds: 3), onTimeout: () => LocationPermission.denied);

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _resolveLocationFallback(registeredLocation);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      ).timeout(const Duration(seconds: 20));

      if (mounted) {
        _loadWeather(position.latitude, position.longitude);
        await _fetchPlacemark(position.latitude, position.longitude, registeredLocation);
      }
    } catch (_) {
      _resolveLocationFallback(registeredLocation);
    } finally {
      if (mounted && _liveLocationLoading) {
        setState(() {
          _liveLocationLoading = false;
        });
      }
    }
  }

  void _resolveLocationFallback(String registeredLocation) {
    if (!mounted) return;

    // If something has already resolved the location (e.g. the registered
    // address lookup succeeded, or a cached GPS fix came back), a later
    // GPS timeout/denial should NOT wipe that out. Only fall back to
    // "Location Unavailable" style text if nothing has loaded yet.
    if (_locationResolved) return;

    setState(() {
      _liveLocationText = registeredLocation.isNotEmpty
          ? registeredLocation
          : 'Location Unavailable';
      _liveLocationLoading = false;
    });
  }

  Future<void> _fetchPlacemark(double lat, double lon, String registeredLocation) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon)
          .timeout(const Duration(seconds: 4), onTimeout: () => []);

      if (!mounted) return;

      final place = placemarks.isNotEmpty ? placemarks.first : null;
      final area = [
        place?.subLocality,
        place?.locality,
        place?.administrativeArea,
      ].whereType<String>().where((v) => v.isNotEmpty).join(', ');

      setState(() {
        _liveLocationText = area.isNotEmpty
            ? area
            : (registeredLocation.isNotEmpty ? registeredLocation : 'GPS Location');
        _liveLocationLoading = false;
        _locationResolved = true;
      });
    } catch (_) {
      if (!mounted) return;
      _resolveLocationFallback(registeredLocation);
    }
  }

  Future<void> _loadWeather(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
            '?latitude=$lat&longitude=$lon&current_weather=true',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final current = data['current_weather'] as Map<String, dynamic>?;

        if (current != null && mounted) {
          final temp = (current['temperature'] as num).round();
          final code = current['weathercode'] as int;

          setState(() {
            temperature = '$temp°C';
            weatherCondition = _weatherCodeToText(code);
            _weatherResolved = true;
            _locationResolved = true;
            _liveLocationLoading = false;
          });
        }
      }
    } catch (_) {}
  }

  /// Maps Open-Meteo's WMO weather codes to short display text.
  /// Reference: https://open-meteo.com/en/docs (WMO Weather interpretation codes)
  String _weatherCodeToText(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code >= 85 && code <= 86) return 'Snow showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Unknown';
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

  void openSoilHealth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SoilHealthHubPage()),
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
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildHeader(),
            _buildAccessibilityBar(),
            _buildFarmerHome(),
            const SizedBox(height: 12),
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
      MaterialPageRoute(builder: (context) => const StartupPage()),
          (route) => false,
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FarmerProfilePage()),
    );
  }

  Widget _buildHeader() {
    final t = AppLocale.of(context).t;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t('appName'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF195B37),
              ),
            ),
          ),
          IconButton(
            onPressed: _openProfile,
            icon: const Icon(
              Icons.settings_outlined,
              size: 26,
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
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F1F3),
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E5EA),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.hearing,
              size: 22,
              color: Color(0xFF17375E),
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'READ SCREEN',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26303A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ASSISTANCE TOOLS',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: .4,
                  color: Color(0xFF6C7075),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.volume_up_outlined,
            size: 20,
            color: Color(0xFF596069),
          ),
          const SizedBox(width: 6),
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
    final session = AppSession.of(context);
    if (!session.loaded) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final user = session.user;

    final rawName = user?['fullName'] ?? user?['name'] ?? user?['phone'] ?? '';
    final fullName = rawName.toString().trim();
    final village = (user?['village'] ?? '').toString().trim();
    final district = (user?['district'] ?? '').toString().trim();

    final registeredLocation =
    [village, district].where((value) => value.isNotEmpty).join(', ');

    final displayLocation = _liveLocationLoading
        ? (registeredLocation.isNotEmpty ? registeredLocation : 'Getting your location...')
        : (_liveLocationText == 'Getting your location...'
        ? (registeredLocation.isNotEmpty ? registeredLocation : 'Location Unavailable')
        : _liveLocationText);

    final greetingName = fullName.isEmpty
        ? 'Farmer'
        : fullName.split(RegExp(r'\s+')).take(2).join(' ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        children: [
          _buildWeatherInformationCard(
            displayLocation: displayLocation,
            greetingName: greetingName,
          ),

          const SizedBox(height: 18),

          // QUICK ACTION CARDS
          Row(
            children: [
              Expanded(
                child: _dashboardButton(
                  icon: Icons.eco_outlined,
                  iconBackground: const Color(0xFFE0F7E9),
                  title: 'Find Pest\nor Diseases',
                  onTap: openCropHealth,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dashboardButton(
                  icon: Icons.biotech_outlined,
                  iconBackground: const Color(0xFFE0F7E9),
                  title: 'Check Your\nSoil Health',
                  onTap: openSoilHealth,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _dashboardButton(
                  icon: Icons.history,
                  iconBackground: const Color(0xFFE0F7E9),
                  title: 'Check Your History\n(last 30 days)',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FarmerHistoryPage()),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildAskQuestion(),

          const SizedBox(height: 12),
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
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE9E1), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Color(0xFF2E9E5B),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  displayLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E9E5B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Hello, $greetingName!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Ready to get the best crop?',
            style: TextStyle(fontSize: 15, color: Color(0xFF555D63)),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF1FBF5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDF5E6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined,
                    size: 28,
                    color: Color(0xFF2E9E5B),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Today's Weather",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2E9E5B),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    Text(
                      weatherCondition,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF555D63)),
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
  // ASK A QUESTION
  // ============================================================

  Widget _buildAskQuestion() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE5DF), width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF2E9E5B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ask a Question',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE8),
              borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 8),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFFD940)),
                  ),
                  child: const TextField(
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'What you want to know...',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7C8187)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: Icon(
                        Icons.mic_none,
                        size: 24,
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
        height: 96,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDCE5DF), width: 1),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 24, color: const Color(0xFF2E9E5B)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.2,
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