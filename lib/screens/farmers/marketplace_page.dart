import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'farmer_dashboard.dart';
import 'pest_alert_page.dart';
import 'help_assistance_page.dart';
import 'farming_tools_page.dart';
import 'fertilizers_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key, this.embedded = false});

  /// When true, this page is being shown as a tab inside the persistent
  /// bottom-nav shell (see farmer_dashboard.dart). In that case the shell
  /// already provides the bottom nav bar, so this page's own (duplicated)
  /// bottom nav row is not rendered, avoiding a double nav bar.
  final bool embedded;

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _currentIndex = 2;

  // ============================================================
  // KRISHI UNNATI AGRICULTURE THEME
  // ============================================================

  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kPrimaryGreen = Color(0xFF1B5E20);
  static const Color kSoftGreen = Color(0xFFE8F5E9);
  static const Color kPaleGreen = Color(0xFFF4FAF4);

  static const Color kTextDark = Color(0xFF263238);
  static const Color kTextGrey = Color(0xFF607D8B);

  // ============================================================
  // LOCATION
  // ============================================================

  String _locationText = 'Getting your location...';
  bool _locationLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location services are turned off';
          _locationLoading = false;
        });

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location permission denied';
          _locationLoading = false;
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location permission denied permanently';
          _locationLoading = false;
        });

        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;

          final String area = place.subLocality?.isNotEmpty == true
              ? place.subLocality!
              : place.locality ?? '';

          final String city = place.locality?.isNotEmpty == true
              ? place.locality!
              : place.administrativeArea ?? '';

          final String location = [
            area,
            city,
          ].where((value) => value.isNotEmpty).toSet().join(', ');

          if (!mounted) return;

          setState(() {
            _locationText =
                location.isNotEmpty ? location : 'Location detected';
            _locationLoading = false;
          });
        }
      } catch (_) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location detected';
          _locationLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _locationText = 'Unable to fetch location';
        _locationLoading = false;
      });
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void _navigateToPestMap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PestAlertPage(),
      ),
    );
  }

  void _navigateToHelp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpAssistancePage(),
      ),
    );
  }

  void _openTools() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FarmingToolsPage(),
      ),
    );
  }

  void _openFertilizers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FertilizersPage(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaleGreen,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),

                    const SizedBox(height: 18),

                    const Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Find farming products and services',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildRecommendationCard(),

                    const SizedBox(height: 18),

                    const Text(
                      'What are you looking for?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildToolsCard(),

                    const SizedBox(height: 10),

                    _buildFertilizersCard(),

                    const SizedBox(height: 16),

                    _buildNearbyCard(),
                  ],
                ),
              ),
            ),

            if (!widget.embedded) _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: kGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Text(
              'Krishi Unnati',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryGreen,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: kGreen,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: kSoftGreen,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: kGreen,
            size: 21,
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tools, fertilizers...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: kTextGrey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 35,
              minHeight: 35,
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.mic_none,
              color: kGreen,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT RECOMMENDATION
  // ============================================================

  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFC8E6C9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kSoftGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: kGreen,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Product',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryGreen,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Recommended by Krishi Unnati',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================================
          // DYNAMIC PRODUCT NAME
          // Backend can replace this value dynamically.
          // ======================================================

          const Text(
            'Product Name',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: kTextDark,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              // PRICE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kSoftGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: kGreen,
                      size: 15,
                    ),
                    Text(
                      '--',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 9),

              // DISTANCE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: kTextGrey,
                      size: 15,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '-- km',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              // CONTACT
              Expanded(
                child: SizedBox(
                  height: 37,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.phone_outlined,
                      size: 16,
                    ),
                    label: const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              // MORE DETAILS
              Expanded(
                child: SizedBox(
                  height: 37,
                  child: OutlinedButton(
                    onPressed: () {
                      _showProductDetails();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kGreen,
                      side: const BorderSide(
                        color: kGreen,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'More Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MORE DETAILS
  // ============================================================

  void _showProductDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: kGreen,
                    size: 25,
                  ),

                  SizedBox(width: 10),

                  Text(
                    'Product Details',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Product Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 11,
                  color: kTextGrey,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                '₹ --',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kGreen,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Distance',
                style: TextStyle(
                  fontSize: 11,
                  color: kTextGrey,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                '-- km',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 18,
                  ),
                  label: const Text(
                    'Contact Seller',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // TOOLS
  // ============================================================

  Widget _buildToolsCard() {
    return _buildCategoryCard(
      icon: Icons.handyman_outlined,
      title: 'Farming Tools',
      subtitle: 'Ploughs, harrows, sickles, hoes and more',
      buttonText: 'Find Tools',
      onTap: _openTools,
    );
  }

  // ============================================================
  // FERTILIZERS
  // ============================================================

  Widget _buildFertilizersCard() {
    return _buildCategoryCard(
      icon: Icons.science_outlined,
      title: 'Chemicals & Fertilizers',
      subtitle: 'Fertilizers, micronutrients and crop protection',
      buttonText: 'Explore Products',
      onTap: _openFertilizers,
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: kSoftGreen,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: kGreen,
              size: 26,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.25,
                    color: kTextGrey,
                  ),
                ),

                const SizedBox(height: 9),

                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 5),

                        const Icon(
                          Icons.arrow_forward,
                          size: 15,
                        ),
                      ],
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
  // NEARBY
  // ============================================================

  Widget _buildNearbyCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: kSoftGreen,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.near_me_outlined,
            color: kGreen,
            size: 21,
          ),

          SizedBox(width: 9),

          Expanded(
            child: Text(
              'Nearby shops will be shown based on your detected location.',
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: kTextGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            0,
            Icons.eco_outlined,
            'Home',
          ),
          _buildNavItem(
            1,
            Icons.map_outlined,
            'Pest Map',
          ),
          _buildNavItem(
            2,
            Icons.shopping_cart_outlined,
            'Marketplace',
          ),
          _buildNavItem(
            3,
            Icons.help_outline,
            'Help',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
  ) {
    final bool selected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            _navigateToHome();
            break;

          case 1:
            _navigateToPestMap();
            break;

          case 2:
            break;

          case 3:
            _navigateToHelp();
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected ? kSoftGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? kGreen
                  : Colors.grey.shade500,
              size: 22,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                color: selected
                    ? kGreen
                    : Colors.grey.shade500,
                fontSize: 10.5,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}