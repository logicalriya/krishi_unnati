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
  // READ SCREEN / ACCESSIBILITY TOGGLE
  // ============================================================

  bool _readScreenEnabled = false;

  // ============================================================
  // LOCATION
  // ============================================================

  String _locationText = 'Getting your location...';
  bool _locationLoading = true;

  // ============================================================
  // DEMO RECOMMENDATIONS
  // ============================================================

  final List<Map<String, String>> _recommendations = [
    {
      'name': 'NPK 10:26:26 Fertilizer',
      'category': 'Fertilizer',
      'price': '₹1,250',
      'distance': '3.2 km',
      'seller': 'Green Farm Supplies',
      'image':
      'https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Battery Powered Sprayer',
      'category': 'Farming Tool',
      'price': '₹3,499',
      'distance': '5.8 km',
      'seller': 'Kisan Equipment Store',
      'image':
      'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Organic Neem Fertilizer',
      'category': 'Crop Protection',
      'price': '₹699',
      'distance': '7.1 km',
      'seller': 'Agro Green Mart',
      'image':
      'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Hand Cultivator Tool Set',
      'category': 'Farming Tool',
      'price': '₹899',
      'distance': '8.4 km',
      'seller': 'Farm Tools Hub',
      'image':
      'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Micronutrient Soil Mix',
      'category': 'Soil Nutrient',
      'price': '₹549',
      'distance': '10.2 km',
      'seller': 'Krishi Seva Store',
      'image':
      'https://images.unsplash.com/photo-1598514982901-ae627a7e0a7f?auto=format&fit=crop&w=600&q=80',
    },
  ];

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

            _buildReadScreenBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  14,
                  18,
                  22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: kTextDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Find farming products and services',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildRecommendationCard(),

                    const SizedBox(height: 20),

                    const Text(
                      'What are you looking for?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                      ),
                    ),

                    const SizedBox(height: 12),


                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildToolsCard(),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildFertilizersCard(),
                          ),
                        ],
                      ),
                    ),
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
  // READ SCREEN BAR
  // ============================================================

  Widget _buildReadScreenBar() {
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
            child: const Icon(Icons.hearing, size: 22, color: Color(0xFF17375E)),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'READ SCREEN',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF26303A)),
              ),
              SizedBox(height: 2),
              Text(
                'ASSISTANCE TOOLS',
                style: TextStyle(fontSize: 10, letterSpacing: .4, color: Color(0xFF6C7075)),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.volume_up_outlined, size: 20, color: Color(0xFF596069)),
          const SizedBox(width: 6),
          Switch(
            value: _readScreenEnabled,
            onChanged: (value) {
              setState(() => _readScreenEnabled = value);
              // TODO: hook up actual screen-reading (e.g. flutter_tts) here.
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF0BA951),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 12),
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
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: kGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Text(
              'Krishi Unnati',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: kPrimaryGreen,
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius: BorderRadius.circular(11),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: kGreen,
                size: 25,
              ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kSoftGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: kGreen,
                  size: 28,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Products',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryGreen,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Recommended by Krishi Unnati',
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: _showAllRecommendations,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 5,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: kGreen,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                return _buildRecommendationItem(
                  _recommendations[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECOMMENDATION ITEM
  // ============================================================

  Widget _buildRecommendationItem(
      Map<String, String> item,
      ) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCF9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDDEBDD),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Image.network(
              item['image'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: kSoftGreen,
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: kGreen,
                      size: 38,
                    ),
                  ),
                );
              },
              loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                  ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  color: kSoftGreen,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kGreen,
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                9,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['category'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kGreen,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    item['name'] ?? 'Product Name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Text(
                        item['price'] ?? '₹ --',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kGreen,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        item['distance'] ?? '-- km',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['seller'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: kTextGrey,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: kGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VIEW ALL RECOMMENDATIONS
  // ============================================================

  void _showAllRecommendations() {
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
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 4,
                    ),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      10,
                      8,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recommended Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextDark,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 1,
                    color: Color(0xFFE8E8E8),
                  ),

                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        14,
                        16,
                        24,
                      ),
                      itemCount: _recommendations.length,
                      itemBuilder: (context, index) {
                        final item = _recommendations[index];

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FCF9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFDDEBDD),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 115,
                                height: 115,
                                child: Image.network(
                                  item['image'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                      ) {
                                    return Container(
                                      color: kSoftGreen,
                                      child: const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: kGreen,
                                        size: 38,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['category'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: kGreen,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        item['name'] ??
                                            'Product Name',
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w700,
                                          color: kTextDark,
                                        ),
                                      ),

                                      const SizedBox(height: 7),

                                      Row(
                                        children: [
                                          Text(
                                            item['price'] ??
                                                '₹ --',
                                            style:
                                            const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700,
                                              color: kGreen,
                                            ),
                                          ),

                                          const SizedBox(width: 9),

                                          Icon(
                                            Icons
                                                .location_on_outlined,
                                            size: 14,
                                            color: Colors
                                                .grey.shade600,
                                          ),

                                          const SizedBox(width: 3),

                                          Text(
                                            item['distance'] ??
                                                '-- km',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors
                                                  .grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 7),

                                      Text(
                                        item['seller'] ?? '',
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: kTextGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
            20,
            20,
            20,
            28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: kGreen,
                    size: 28,
                  ),

                  SizedBox(width: 11),

                  Text(
                    'Product Details',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Product Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 13,
                  color: kTextGrey,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                '₹ --',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: kGreen,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Distance',
                style: TextStyle(
                  fontSize: 13,
                  color: kTextGrey,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                '-- km',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'Contact Seller',
                    style: TextStyle(
                      fontSize: 15,
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
  //
  // Used inside an IntrinsicHeight + Expanded pair in build(), so
  // both cards are forced to the same height regardless of subtitle
  // length. The Spacer below pushes the button to the bottom of
  // whichever height that ends up being, so both buttons line up
  // even when one card's text is shorter than the other's.
  // ============================================================

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: kGreen,
              size: 29,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kTextDark,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.3,
              color: kTextGrey,
            ),
          ),

          // Pushes the button to the bottom of the card so both cards'
          // buttons align horizontally regardless of subtitle length.
          const Spacer(),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      buttonText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                  ),
                ],
              ),
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kSoftGreen,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.near_me_outlined,
            color: kGreen,
            size: 23,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'Nearby shops will be shown based on your detected location.',
              style: TextStyle(
                fontSize: 13,
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
      padding: const EdgeInsets.symmetric(vertical: 9),
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
          horizontal: 12,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: selected ? kSoftGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? kGreen
                  : Colors.grey.shade500,
              size: 24,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                color: selected
                    ? kGreen
                    : Colors.grey.shade500,
                fontSize: 12,
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