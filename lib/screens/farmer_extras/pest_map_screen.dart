import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../data/maharashtra.dart';
import '../../data/pest_dataset.dart';
import '../../services/local_db.dart';
import '../../state/app_locale.dart';

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

/// Farmer "Pest Map" tab: report a pest, filter by crop/time, view a real
/// map (flutter_map + OpenStreetMap) with hotspot markers, and browse
/// nearby hotspots — matching the mockup's High/Moderate/Safe legend.
class PestMapScreen extends StatefulWidget {
  const PestMapScreen({super.key});

  @override
  State<PestMapScreen> createState() => _PestMapScreenState();
}

class _PestMapScreenState extends State<PestMapScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(19.7515, 75.7139); // Maharashtra centroid
  bool _locating = true;
  String _cropFilter = 'All Crops';
  String _timeFilter = 'Last 7 Days';
  late List<_Hotspot> _hotspots;

  @override
  void initState() {
    super.initState();
    _locate();
    _hotspots = _generateHotspots();
  }

  List<_Hotspot> _generateHotspots() {
    final random = Random(42);
    final severities = ['High', 'Moderate', 'Safe'];
    return List.generate(6, (i) {
      final pest = fieldPestDataset[random.nextInt(fieldPestDataset.length)];
      final ageHours = random.nextInt(30) + 1;
      final lat = _center.latitude + (random.nextDouble() - 0.5) * 0.6;
      final lon = _center.longitude + (random.nextDouble() - 0.5) * 0.6;
      return _Hotspot(
        pest.name,
        pest.crop,
        severities[random.nextInt(severities.length)],
        '${(random.nextDouble() * 8 + 0.5).toStringAsFixed(1)} km away',
        '${ageHours}h ago',
        ageHours,
        LatLng(lat, lon),
      );
    });
  }

  Future<void> _locate() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final granted = await Geolocator.checkPermission();
      if (granted == LocationPermission.always || granted == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 5));
        if (mounted) {
          setState(() {
            _center = LatLng(pos.latitude, pos.longitude);
            _hotspots = _generateHotspots();
          });
          _mapController.move(_center, 9);
        }
      }
    } catch (_) {
      // Keep Maharashtra fallback center.
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _reportPest() {
    final t = AppLocale.of(context).t;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) {
        String? crop;
        final descController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: StatefulBuilder(
            builder: (context, setSheetState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('reportPestDialogTitle'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: crop,
                  decoration: InputDecoration(labelText: 'Crop', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  items: maharashtraCrops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setSheetState(() => crop = v),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: 'Describe what you see...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () async {
                      await LocalDb.addHistoryEntry({'type': 'pest_report', 'disease': 'Reported: ${crop ?? 'Unknown crop'}', 'confidence': null});
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('reportPestSubmitted'))));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F9D55), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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

  Color _severityColor(String s) {
    switch (s) {
      case 'High':
        return Colors.redAccent;
      case 'Moderate':
        return Colors.blueAccent;
      default:
        return const Color(0xFF1F9D55);
    }
  }

  List<_Hotspot> get _visibleHotspots {
    final maxHours = switch (_timeFilter) {
      'Last 24 Hours' => 24,
      'Last 30 Days' => 24 * 30,
      _ => 24 * 7,
    };

    return _hotspots.where((hotspot) {
      final cropMatches = _cropFilter == 'All Crops' ||
          hotspot.crop == _cropFilter;
      return cropMatches && hotspot.ageHours <= maxHours;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _reportPest,
              icon: const Icon(Icons.add, size: 16),
              label: Text(t('reportPestBtn')),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F9D55), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE4E9E5))),
            child: Text(
              _locating ? 'Detecting your location...' : t('locationDetected'),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _dropdown(t('cropTypeLabel'), _cropFilter, ['All Crops', ...maharashtraCrops], (v) => setState(() => _cropFilter = v!))),
              const SizedBox(width: 10),
              Expanded(child: _dropdown(t('timeLabel'), _timeFilter, ['Last 24 Hours', 'Last 7 Days', 'Last 30 Days'], (v) => setState(() => _timeFilter = v!))),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 260,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(initialCenter: _center, initialZoom: 9),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.krishiunnati.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _center,
                        width: 26, height: 26,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                      for (final h in _visibleHotspots)
                        Marker(
                          point: h.point,
                          width: 26, height: 26,
                          child: Icon(Icons.circle, color: _severityColor(h.severity).withOpacity(.85), size: 18),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legend(t('high'), Colors.redAccent),
              _legend(t('moderate'), Colors.blueAccent),
              _legend(t('safe'), const Color(0xFF1F9D55)),
            ],
          ),
          const SizedBox(height: 16),
          Text(t('nearbyHotspots'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (_visibleHotspots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  t('noHotspotsMatch'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            for (final h in _visibleHotspots) _hotspotCard(h),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE4E9E5))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 10, color: color),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]);
  }

  Widget _hotspotCard(_Hotspot h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE4E9E5))),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: _severityColor(h.severity).withOpacity(.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.bug_report_outlined, color: _severityColor(h.severity)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: _severityColor(h.severity).withOpacity(.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(h.severity.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _severityColor(h.severity))),
                  ),
                  const SizedBox(width: 6),
                  Text(h.timeAgo, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                ]),
                const SizedBox(height: 3),
                Text(h.pest, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('${h.distance} · ${h.crop}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
