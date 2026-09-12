import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PestAlertPage extends StatefulWidget {
  const PestAlertPage({super.key});

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
  //
  // These coordinates are examples for the SIH prototype.
  // Later, replace this list with data coming from your backend/API.
  //

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

      // Move map to farmer's location
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
    // Approximate bounding box of Maharashtra.
    //
    // This is sufficient for the prototype.
    // For production, use proper reverse geocoding/boundaries.

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

      // 150 km radius
      if (distance <= 150000) {
        alert.distanceKm = distance / 1000;
        nearby.add(alert);
      }
    }

    // Nearest alerts first
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

    // Farmer marker
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
              color: Colors.blue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 32,
            ),
          ),
        ),
      );
    }

    // Pest markers
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
        return const Color(0xFFE53935);

      case 'Medium':
        return const Color(0xFFE0A800);

      case 'Low':
        return const Color(0xFF36A269);

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
      backgroundColor = const Color(0xFFFFF1F1);
    } else if (alert.severity == 'Medium') {
      backgroundColor = const Color(0xFFFFFAE8);
    } else {
      backgroundColor = const Color(0xFFEEFBF4);
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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final nearbyAlerts = _getNearbyAlerts();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF278052),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Pest Alerts',
          style: TextStyle(
            color: Color(0xFF287B50),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _getFarmerLocation,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8),

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
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202020),
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
                    ),

                    child: const Row(
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
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
                      color: const Color(0xFFFFF1F1),
                      borderRadius:
                          BorderRadius.circular(7),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_off,
                          color: Colors.red,
                          size: 17,
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            _locationError!,
                            style:
                                const TextStyle(
                              fontSize: 9,
                              color: Colors.red,
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
                            bottom: 8),

                    padding:
                        const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFAE8),
                      borderRadius:
                          BorderRadius.circular(7),
                    ),

                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 16,
                        ),

                        SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            'You are currently outside Maharashtra. '
                            'Maharashtra pest alerts are shown on the map.',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF806000),
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

                  clipBehavior: Clip.hardEdge,

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
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      _legendItem(
                        Colors.blue,
                        'You',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        Colors.red,
                        'High',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        Colors.orange,
                        'Medium',
                      ),

                      const SizedBox(width: 15),

                      _legendItem(
                        Colors.green,
                        'Low',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 9),

                // ------------------------------------------------
                // CURRENT ALERTS
                // ------------------------------------------------

                const Row(
                  children: [
                    Text(
                      '⚠️',
                      style:
                          TextStyle(fontSize: 11),
                    ),

                    SizedBox(width: 3),

                    Text(
                      'Current Pest Alerts',
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

                const SizedBox(height: 7),

                // ------------------------------------------------
                // NO ALERTS
                // ------------------------------------------------

                if (!_loadingLocation &&
                    nearbyAlerts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(7),
                    ),

                    child: const Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF36A269),
                          size: 25,
                        ),

                        SizedBox(height: 5),

                        Text(
                          'No nearby pest alerts',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 2),

                        Text(
                          'No reported alerts within 150 km.',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                // ------------------------------------------------
                // ALERT LIST
                // ------------------------------------------------

                for (final alert in nearbyAlerts) ...[
                  _pestAlertCard(alert),

                  const SizedBox(height: 7),
                ],

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
                      const Color(0xFF20A963),

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