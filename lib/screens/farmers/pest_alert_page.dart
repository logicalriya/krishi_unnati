import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../farmer_extras/pest_map_screen.dart';

class PestAlertPage extends StatefulWidget {
  const PestAlertPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PestAlertPage> createState() => _PestAlertPageState();
}

class _PestAlertPageState extends State<PestAlertPage> {
  final MapController _mapController = MapController();

  Position? _farmerPosition;

  bool _loadingLocation = true;
  String? _locationError;

  // Maharashtra center
  static const LatLng _maharashtraCenter = LatLng(
    19.7515,
    75.7139,
  );

  // ------------------------------------------------------------
  // SAMPLE PEST ALERT DATA
  // ------------------------------------------------------------

  final List<PestAlert> _allAlerts = [
    PestAlert(
      pest: 'Cotton Bollworm',
      location: 'Akola',
      latitude: 20.7002,
      longitude: 77.0082,
      severity: 'High',
    ),
    PestAlert(
      pest: 'Pink Bollworm',
      location: 'Amravati',
      latitude: 20.9374,
      longitude: 77.7796,
      severity: 'Medium',
    ),
    PestAlert(
      pest: 'Onion Thrips',
      location: 'Nashik',
      latitude: 19.9975,
      longitude: 73.7898,
      severity: 'High',
    ),
    PestAlert(
      pest: 'Fall Armyworm',
      location: 'Pune',
      latitude: 18.5204,
      longitude: 73.8567,
      severity: 'Medium',
    ),
    PestAlert(
      pest: 'Sugarcane Borer',
      location: 'Kolhapur',
      latitude: 16.7050,
      longitude: 74.2433,
      severity: 'Low',
    ),
    PestAlert(
      pest: 'Stem Borer',
      location: 'Nagpur',
      latitude: 21.1458,
      longitude: 79.0882,
      severity: 'Medium',
    ),
    PestAlert(
      pest: 'Fruit Fly',
      location: 'Aurangabad',
      latitude: 19.8762,
      longitude: 75.3433,
      severity: 'Low',
    ),
    PestAlert(
      pest: 'Whitefly',
      location: 'Jalgaon',
      latitude: 21.0077,
      longitude: 75.5626,
      severity: 'High',
    ),
  ];

  // ------------------------------------------------------------
  // CURRENT ALERT DATA
  //
  // DEMO DATA IS SHOWN FOR NOW.
  //
  // Later this list can be populated from the backend / ML /
  // pest-alert API without changing the UI structure.
  // ------------------------------------------------------------

  final List<Map<String, String>> _demoPestDiseases = [
    {
      'name': 'Aphid Infestation',
      'crop': 'Wheat',
      'location': 'Ludhiana West',
      'distance': '2.4 km away',
      'severity': 'High',
      'time': '2 hours ago',
    },
    {
      'name': 'Brown Plant Hopper',
      'crop': 'Rice',
      'location': 'Amritsar',
      'distance': '5.8 km away',
      'severity': 'Medium',
      'time': '4 hours ago',
    },
    {
      'name': 'Leaf Blast Disease',
      'crop': 'Rice',
      'location': 'Patiala',
      'distance': '8.1 km away',
      'severity': 'High',
      'time': '6 hours ago',
    },
    {
      'name': 'Cotton Bollworm',
      'crop': 'Cotton',
      'location': 'Bathinda',
      'distance': '11.6 km away',
      'severity': 'Medium',
      'time': '1 day ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getFarmerLocation();
  }

  // ============================================================
  // GET FARMER LOCATION
  // ============================================================

  Future<void> _getFarmerLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          _loadingLocation = false;
          _locationError =
              'Location services are turned off.';
        });
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _loadingLocation = false;
          _locationError =
              'Location permission was denied.';
        });
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        setState(() {
          _loadingLocation = false;
          _locationError =
              'Location permission is permanently denied.';
        });
        return;
      }

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _farmerPosition = position;
        _loadingLocation = false;
      });

      _mapController.move(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        9.0,
      );
    } catch (e) {
      setState(() {
        _loadingLocation = false;
        _locationError =
            'Unable to get your location.';
      });
    }
  }

  // ============================================================
  // CHECK WHETHER FARMER IS IN MAHARASHTRA
  // ============================================================

  bool _isInMaharashtra(Position position) {
    return position.latitude >= 15.5 &&
        position.latitude <= 22.1 &&
        position.longitude >= 72.5 &&
        position.longitude <= 80.9;
  }

  // ============================================================
  // GET NEARBY ALERTS
  // ============================================================

  List<PestAlert> _getNearbyAlerts() {
    if (_farmerPosition == null) {
      return [];
    }

    final farmer = _farmerPosition!;

    List<PestAlert> nearby = [];

    for (final alert in _allAlerts) {
      final distance = Geolocator.distanceBetween(
        farmer.latitude,
        farmer.longitude,
        alert.latitude,
        alert.longitude,
      );

      if (distance <= 150000) {
        alert.distanceKm = distance / 1000;
        nearby.add(alert);
      }
    }

    nearby.sort(
      (a, b) =>
          (a.distanceKm ?? 999)
              .compareTo(b.distanceKm ?? 999),
    );

    return nearby;
  }

  // ============================================================
  // MAP MARKERS
  // ============================================================

  List<Marker> _buildMarkers() {
    final List<Marker> markers = [];

    if (_farmerPosition != null) {
      markers.add(
        Marker(
          point: LatLng(
            _farmerPosition!.latitude,
            _farmerPosition!.longitude,
          ),
          width: 45,
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFF2563EB),
              size: 32,
            ),
          ),
        ),
      );
    }

    final nearbyAlerts = _getNearbyAlerts();

    for (final alert in nearbyAlerts) {
      markers.add(
        Marker(
          point: LatLng(
            alert.latitude,
            alert.longitude,
          ),
          width: 40,
          height: 40,
          child: Icon(
            Icons.bug_report,
            color: _severityColor(alert.severity),
            size: 25,
          ),
        ),
      );
    }

    return markers;
  }

  // ============================================================
  // SEVERITY COLOR
  // ============================================================

  Color _severityColor(String severity) {
    switch (severity) {
      case 'High':
        return const Color(0xFFD83A3A);

      case 'Medium':
        return const Color(0xFFD99A18);

      case 'Low':
        return const Color(0xFF2E8B57);

      default:
        return Colors.grey;
    }
  }

  // ============================================================
  // ALERT CARD
  // ============================================================

  Widget _pestAlertCard(PestAlert alert) {
    final color = _severityColor(alert.severity);

    Color backgroundColor;

    if (alert.severity == 'High') {
      backgroundColor = const Color(0xFFFFF4F4);
    } else if (alert.severity == 'Medium') {
      backgroundColor = const Color(0xFFFFFBEE);
    } else {
      backgroundColor = const Color(0xFFF0FAF4);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: color,
            size: 17,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  alert.pest,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${alert.location} • '
                  '${alert.distanceKm?.toStringAsFixed(1)} km away',
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(0.25),
                width: 0.7,
              ),
            ),
            child: Text(
              alert.severity,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CURRENT ALERT CARD
  //
  // NO IMAGES ARE ADDED.
  // IMAGE AREA IS KEPT AS A PLACEHOLDER FOR FUTURE DYNAMIC DATA.
  // ============================================================

  Widget _demoPestDiseaseCard(
      Map<String, String> item) {
    final String severity =
        item['severity'] ?? 'Medium';

    final bool isHigh = severity == 'High';
    final bool isMedium = severity == 'Medium';

    final Color severityColor = isHigh
        ? const Color(0xFFD83A3A)
        : isMedium
            ? const Color(0xFFD99A18)
            : const Color(0xFF2E8B57);

    final Color severityBackground = isHigh
        ? const Color(0xFFFFF4F4)
        : isMedium
            ? const Color(0xFFFFFBEE)
            : const Color(0xFFF0FAF4);

    final Color severityBorder =
        severityColor.withOpacity(0.42);

    return Container(
      width: 315,
      height: 145,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: severityBorder,
          width: isHigh ? 1.6 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(
              isHigh
                  ? 0.12
                  : isMedium
                      ? 0.09
                      : 0.06,
            ),
            blurRadius: isHigh ? 8 : 6,
            spreadRadius: isHigh ? 0.5 : 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // IMAGE PLACEHOLDER
          SizedBox(
            width: 108,
            height: double.infinity,
            child: Container(
              color: const Color(0xFFEAF5EE),
              child: const Icon(
                Icons.bug_report,
                color: Color(0xFF2E8B57),
                size: 40,
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                12,
                12,
                9,
                10,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // SEVERITY + TIME
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: severityBackground,
                          border: Border.all(
                            color: severityBorder,
                            width: 0.9,
                          ),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          severity.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight:
                                FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                      ),
                      Text(
                        item['time']!,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // TITLE
                  Text(
                    item['name']!,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color: Color(0xFF202020),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // LOCATION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF666666),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${item['distance']} • '
                          '${item['location']}',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color:
                                Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // CROP
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_outlined,
                        size: 14,
                        color: Color(0xFF2E8B57),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['crop']!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF2E8B57),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        size: 19,
                        color: Color(0xFF555555),
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
  // VIEW ALL CURRENT ALERTS
  // ============================================================

  void _showAllDemoPestDiseases() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
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
                  // TOP HANDLE
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 8,
                      bottom: 3,
                    ),
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // HEADER
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      12,
                      6,
                      8,
                      6,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Alerts',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202020),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 1,
                    color: Color(0xFFE8E8E8),
                  ),

                  // SCROLLABLE ALERT LIST
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding:
                          const EdgeInsets.fromLTRB(
                        12,
                        12,
                        12,
                        20,
                      ),
                      itemCount:
                          _demoPestDiseases.length,
                      itemBuilder:
                          (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child:
                              _demoPestDiseaseCard(
                            _demoPestDiseases[index],
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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5FAF7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        // No back arrow on this page.
        automaticallyImplyLeading: false,

        title: const Text(
          'Pest Alerts',
          style: TextStyle(
            color: Color(0xFF2E8B57),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Live Pest Map',
            icon: const Icon(
              Icons.map_outlined,
              color: Color(0xFF2E8B57),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PestMapScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _getFarmerLocation,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------

                const Padding(
                  padding: EdgeInsets.only(
                    left: 2,
                    top: 10,
                    bottom: 8,
                  ),

                  child: Row(
                    children: [
                      Text(
                        '🌱',
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(width: 3),

                      Text(
                        'Pest Hotspots Near You',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF202020),
                        ),
                      ),
                    ],
                  ),
                ),

                // ------------------------------------------------
                // LOCATION STATUS
                // ------------------------------------------------

                if (_loadingLocation)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color(0xFFDDEBE2),
                      ),
                    ),

                    child: const Row(
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2E8B57),
                          ),
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Getting your location...',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_locationError != null)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFF4F4),
                      borderRadius:
                          BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color(0xFFE9A4A4),
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_off,
                          color: Color(0xFFD83A3A),
                          size: 17,
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            _locationError!,
                            style:
                                const TextStyle(
                              fontSize: 9,
                              color: Color(0xFFD83A3A),
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed:
                              _getFarmerLocation,
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF2E8B57),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ------------------------------------------------
                // OUTSIDE MAHARASHTRA
                // ------------------------------------------------

                if (_farmerPosition != null &&
                    !_isInMaharashtra(
                        _farmerPosition!))
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(
                      bottom: 8,
                    ),

                    padding:
                        const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFFBEE),
                      borderRadius:
                          BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color(0xFFE3BE62),
                      ),
                    ),

                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFFD99A18),
                          size: 16,
                        ),

                        SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            'You are currently outside Maharashtra. '
                            'Maharashtra pest alerts are shown on the map.',
                            style: TextStyle(
                              fontSize: 9,
                              color:
                                  Color(0xFF806000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ------------------------------------------------
                // MAP
                // ------------------------------------------------

                Container(
                  height: 180,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(5),
                  ),

                  clipBehavior:
                      Clip.hardEdge,

                  child: FlutterMap(
                    mapController:
                        _mapController,

                    options: MapOptions(
                      initialCenter:
                          _maharashtraCenter,
                      initialZoom: 6.5,
                    ),

                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/'
                            '{z}/{x}/{y}.png',

                        userAgentPackageName:
                            'com.krishiunnati.app',
                      ),

                      MarkerLayer(
                        markers:
                            _buildMarkers(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ------------------------------------------------
                // MAP LEGEND
                // ------------------------------------------------

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFDDEBE2),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      _legendItem(
                        const Color(0xFF2563EB),
                        'You',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        const Color(0xFFD83A3A),
                        'High',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        const Color(0xFFD99A18),
                        'Medium',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        const Color(0xFF2E8B57),
                        'Low',
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // CURRENT ALERTS
                // ==================================================

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '⚠️',
                          style:
                              TextStyle(fontSize: 12),
                        ),

                        SizedBox(width: 4),

                        Text(
                          'Current Alerts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xFF202020),
                          ),
                        ),
                      ],
                    ),

                    TextButton(
                      onPressed:
                          _showAllDemoPestDiseases,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize:
                            const Size(55, 30),
                        tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF2E8B57),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                SizedBox(
                  height: 145,
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal,
                    physics:
                        const BouncingScrollPhysics(),
                    itemCount:
                        _demoPestDiseases.length,
                    itemBuilder:
                        (context, index) {
                      return _demoPestDiseaseCard(
                        _demoPestDiseases[index],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),

      // ----------------------------------------------------------
      // CURRENT LOCATION BUTTON
      // ----------------------------------------------------------

      floatingActionButton:
          _farmerPosition == null
              ? null
              : FloatingActionButton.small(
                  backgroundColor:
                      const Color(0xFF2563EB),

                  onPressed: () {
                    _mapController.move(
                      LatLng(
                        _farmerPosition!
                            .latitude,
                        _farmerPosition!
                            .longitude,
                      ),
                      10,
                    );
                  },

                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
    );
  }

  // ============================================================
  // LEGEND ITEM
  // ============================================================

  Widget _legendItem(
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 3),

        Text(
          text,
          style: const TextStyle(
            fontSize: 7.5,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PEST ALERT MODEL
// ================================================================

class PestAlert {
  final String pest;
  final String location;
  final double latitude;
  final double longitude;
  final String severity;

  double? distanceKm;

  PestAlert({
    required this.pest,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.severity,
  });
}