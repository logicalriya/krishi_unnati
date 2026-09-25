import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../data/maharashtra.dart';
import '../../data/pest_dataset.dart';
import '../../services/local_db.dart';
import '../../state/app_locale.dart';

// ============================================================
// DYNAMIC HOTSPOT MODEL
// ============================================================
class _Hotspot {
  final String pest;
  final String crop;
  final String severity;
  final String distance;
  final String timeAgo;
  final int ageHours;
  final LatLng point;

  const _Hotspot(
      this.pest,
      this.crop,
      this.severity,
      this.distance,
      this.timeAgo,
      this.ageHours,
      this.point,
      );
}

// ============================================================
// PEST ALERT PAGE WIDGET
// ============================================================
class PestAlertPage extends StatefulWidget {
  const PestAlertPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<PestAlertPage> createState() => _PestAlertPageState();
}

class _PestAlertPageState extends State<PestAlertPage> {
  final MapController _mapController = MapController();

  // Maharashtra centroid fallback
  static const LatLng _maharashtraCenter = LatLng(19.7515, 75.7139);
  LatLng _currentCenter = _maharashtraCenter;
  Position? _farmerPosition;

  bool _loadingLocation = true;
  String? _locationError;
  bool _readScreenEnabled = false;

  String _selectedCropType = 'All Crops';
  String _selectedTimeRange = 'Last 7 Days';

  static const List<String> _timeRangeOptions = [
    'Last 24 Hours',
    'Last 7 Days',
    'Last 30 Days',
  ];

  late List<_Hotspot> _hotspots;

  @override
  void initState() {
    super.initState();
    _hotspots = _generateHotspots();
    _getFarmerLocation();
  }

  // ============================================================
  // GENERATE DYNAMIC HOTSPOTS (From Pest Dataset)
  // ============================================================
  List<_Hotspot> _generateHotspots() {
    final random = Random(42);
    final severities = ['High', 'Medium', 'Low']; // Mapped to UI Colors

    return List.generate(8, (i) {
      final pest = fieldPestDataset[random.nextInt(fieldPestDataset.length)];
      final ageHours = random.nextInt(30) + 1;
      final lat = _currentCenter.latitude + (random.nextDouble() - 0.5) * 0.6;
      final lon = _currentCenter.longitude + (random.nextDouble() - 0.5) * 0.6;

      return _Hotspot(
        pest.name,
        pest.crop,
        severities[random.nextInt(severities.length)],
        '${(random.nextDouble() * 8 + 0.5).toStringAsFixed(1)} km',
        '${ageHours}h ago',
        ageHours,
        LatLng(lat, lon),
      );
    });
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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loadingLocation = false;
          _locationError = 'Location services are turned off.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          _loadingLocation = false;
          _locationError = 'Location permission is denied.';
        });
        return;
      }

      // Try a cached fix first so the map can center immediately if one
      // exists, while the fresh fix below is still being acquired.
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        setState(() {
          _currentCenter = LatLng(lastKnown.latitude, lastKnown.longitude);
        });
      }

      // LocationAccuracy.medium resolves noticeably faster than .high with
      // little practical difference for this use case — this screen only
      // needs to place you on a regional map, not lane-level precision.
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 8));

      if (mounted) {
        setState(() {
          _farmerPosition = position;
          _currentCenter = LatLng(position.latitude, position.longitude);
          _hotspots = _generateHotspots(); // Regenerate accurate to exact location
          _loadingLocation = false;
        });
        _mapController.move(_currentCenter, 9.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingLocation = false;
          _locationError = 'Unable to get your location.';
        });
      }
    }
  }

  bool _isInMaharashtra(Position position) {
    return position.latitude >= 15.5 &&
        position.latitude <= 22.1 &&
        position.longitude >= 72.5 &&
        position.longitude <= 80.9;
  }

  // ============================================================
  // FILTERING LOGIC
  // ============================================================
  List<_Hotspot> get _visibleHotspots {
    final maxHours = switch (_selectedTimeRange) {
      'Last 24 Hours' => 24,
      'Last 30 Days' => 24 * 30,
      _ => 24 * 7,
    };

    return _hotspots.where((hotspot) {
      final cropMatches = _selectedCropType == 'All Crops' || hotspot.crop == _selectedCropType;
      return cropMatches && hotspot.ageHours <= maxHours;
    }).toList();
  }

  // ============================================================
  // MAP MARKERS & UTILS
  // ============================================================
  List<Marker> _buildMarkers() {
    final List<Marker> markers = [];

    if (_farmerPosition != null) {
      markers.add(
        Marker(
          point: _currentCenter,
          width: 45, height: 45,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 32),
          ),
        ),
      );
    }

    for (final h in _visibleHotspots) {
      markers.add(
        Marker(
          point: h.point,
          width: 40, height: 40,
          child: Icon(Icons.bug_report, color: _severityColor(h.severity), size: 25),
        ),
      );
    }
    return markers;
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'High':
        return const Color(0xFFD83A3A);
      case 'Medium':
        return const Color(0xFFD99A18);
      default:
        return const Color(0xFF2E8B57); // Low
    }
  }

  void _zoomBy(double delta) {
    final camera = _mapController.camera;
    _mapController.move(camera.center, (camera.zoom + delta).clamp(3.0, 18.0));
  }

  // ============================================================
  // GO TO CURRENT LOCATION
  // ============================================================
  void _goToCurrentLocation() {
    if (_farmerPosition != null) {
      _mapController.move(_currentCenter, 12.0);
    } else {
      // No fix yet (denied/failed/still loading) — try fetching again,
      // which will also refresh the status bar with a new error if needed.
      _getFarmerLocation();
    }
  }

  Widget _mapZoomButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF2E8B57), size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _mapCurrentLocationButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: IconButton(
        icon: const Icon(Icons.my_location, color: Colors.white, size: 20),
        onPressed: _goToCurrentLocation,
        tooltip: 'Go to current location',
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // ============================================================
  // FUNCTIONAL REPORT PEST BOTTOM SHEET (Imported logic)
  // ============================================================
  void _onReportPest() {
    final t = AppLocale.of(context).t;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) {
        String? crop;
        final descController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('reportPestDialogTitle'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: crop,
                  decoration: InputDecoration(
                    labelText: 'Crop',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: maharashtraCrops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setSheetState(() => crop = v),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe what you see...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () async {
                      await LocalDb.addHistoryEntry({
                        'type': 'pest_report',
                        'disease': 'Reported: ${crop ?? 'Unknown crop'}',
                        'confidence': null
                      });
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t('reportPestSubmitted'))),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit Report'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNeedHelp() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help & assistance coming soon.')));
  }

  // ============================================================
  // UI COMPONENTS
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
            width: 38, height: 38,
            decoration: BoxDecoration(color: const Color(0xFFE1E5EA), borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.hearing, size: 22, color: Color(0xFF17375E)),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('READ SCREEN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF26303A))),
              SizedBox(height: 2),
              Text('ASSISTANCE TOOLS', style: TextStyle(fontSize: 10, letterSpacing: .4, color: Color(0xFF6C7075))),
            ],
          ),
          const Spacer(),
          const Icon(Icons.volume_up_outlined, size: 20, color: Color(0xFF596069)),
          const SizedBox(width: 6),
          Switch(
            value: _readScreenEnabled,
            onChanged: (value) => setState(() => _readScreenEnabled = value),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF0BA951),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusBar() {
    if (_loadingLocation) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDEBE2)),
        ),
        child: const Row(
          children: [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E8B57))),
            SizedBox(width: 10),
            Text('Getting your location...', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      );
    }

    if (_locationError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4F4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE9A4A4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_off, color: Color(0xFFD83A3A), size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(_locationError!, style: const TextStyle(fontSize: 13, color: Color(0xFFD83A3A)))),
            TextButton(
              onPressed: _getFarmerLocation,
              child: const Text('Retry', style: TextStyle(fontSize: 13, color: Color(0xFF2E8B57))),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDEBE2)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Your location has been used to detect the map',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.5, color: Color(0xFF555555)),
      ),
    );
  }

  Widget _buildFilterRow(List<String> cropTypeOptions) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownFilter('CROP TYPE', _selectedCropType, cropTypeOptions, (value) {
            setState(() => _selectedCropType = value!);
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownFilter('TIME', _selectedTimeRange, _timeRangeOptions, (value) {
            setState(() => _selectedTimeRange = value!);
          }),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6C7075), letterSpacing: 0.4),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDDEBE2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              style: const TextStyle(fontSize: 13, color: Color(0xFF202020), fontWeight: FontWeight.w600),
              items: options.map((option) => DropdownMenuItem(value: option, child: Text(option, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _hotspotCard(_Hotspot item, {double width = 320}) {
    final String severity = item.severity;
    final bool isHigh = severity == 'High';
    final bool isMedium = severity == 'Medium';

    final Color severityColor = _severityColor(severity);
    final Color severityBackground = isHigh ? const Color(0xFFFFF4F4) : isMedium ? const Color(0xFFFFFBEE) : const Color(0xFFF0FAF4);
    final Color severityBorder = severityColor.withOpacity(0.42);

    return Container(
      width: width,
      height: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityBorder, width: isHigh ? 1.6 : 1.2),
        boxShadow: [
          BoxShadow(
            color: severityColor.withOpacity(isHigh ? 0.12 : isMedium ? 0.09 : 0.06),
            blurRadius: isHigh ? 8 : 6,
            spreadRadius: isHigh ? 0.5 : 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: double.infinity,
            child: Container(
              color: severityColor.withOpacity(0.12),
              child: Icon(Icons.bug_report, color: severityColor, size: 42),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: severityBackground,
                          border: Border.all(color: severityBorder, width: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          severity.toUpperCase(),
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: severityColor),
                        ),
                      ),
                      Text(item.timeAgo, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.pest,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF202020)),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF666666)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${item.distance} away',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.eco_outlined, size: 15, color: Color(0xFF2E8B57)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.crop,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E8B57)),
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20, color: Color(0xFF555555)),
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

  void _showAllHotspots() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: const Color(0xFFD0D0D0), borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nearby Hotspots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF202020))),
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 24)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE8E8E8)),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: _visibleHotspots.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _hotspotCard(_visibleHotspots[index], width: double.infinity),
                      ),
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

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF555555), fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> cropTypeOptions = ['All Crops', ...maharashtraCrops];
    final activeHotspots = _visibleHotspots;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pest Alerts',
          style: TextStyle(color: Color(0xFF2E8B57), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Map Icon completely removed
      ),
      body: RefreshIndicator(
        onRefresh: _getFarmerLocation,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReadScreenBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),

                    // REPORT PEST BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _onReportPest,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Report Pest', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildLocationStatusBar(),
                    const SizedBox(height: 16),

                    _buildFilterRow(cropTypeOptions),
                    const SizedBox(height: 16),

                    if (_farmerPosition != null && !_isInMaharashtra(_farmerPosition!))
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEE),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE3BE62)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFFD99A18), size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'You are currently outside Maharashtra. Maharashtra pest alerts are shown on the map.',
                                style: TextStyle(fontSize: 12, color: Color(0xFF806000)),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // MAP WITH ZOOM + CURRENT-LOCATION CONTROLS
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDDEBE2)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(initialCenter: _currentCenter, initialZoom: 7.5),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.krishiunnati.app',
                              ),
                              MarkerLayer(markers: _buildMarkers()),
                            ],
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Column(
                              children: [
                                _mapZoomButton(Icons.add, () => _zoomBy(1)),
                                const SizedBox(height: 8),
                                _mapZoomButton(Icons.remove, () => _zoomBy(-1)),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: _mapCurrentLocationButton(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // MAP LEGEND
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFDDEBE2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _legendItem(const Color(0xFF2563EB), 'You'),
                          _legendItem(const Color(0xFFD83A3A), 'High'),
                          _legendItem(const Color(0xFFD99A18), 'Medium'),
                          _legendItem(const Color(0xFF2E8B57), 'Low'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // NEARBY HOTSPOTS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'NEARBY HOTSPOTS',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF202020), letterSpacing: 0.3),
                        ),
                        TextButton(
                          onPressed: activeHotspots.isNotEmpty ? _showAllHotspots : null,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(60, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: activeHotspots.isNotEmpty ? const Color(0xFF2E8B57) : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (activeHotspots.isEmpty)
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: const Text('No hotspots match your current filters.', style: TextStyle(color: Colors.grey)),
                      )
                    else
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: activeHotspots.length,
                          itemBuilder: (context, index) => _hotspotCard(activeHotspots[index]),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // NEED ANY HELP
                    GestureDetector(
                      onTap: _onNeedHelp,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDDEBE2)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.help_outline, size: 18, color: Color(0xFF555555)),
                            SizedBox(width: 8),
                            Text('Need any help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}