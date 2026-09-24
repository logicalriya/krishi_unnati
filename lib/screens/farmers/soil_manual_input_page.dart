import 'package:flutter/material.dart';

import '../../widgets/farmer_page_header.dart';
import 'soil_health_hub_page.dart';

/// ============================================================
/// SOIL HEALTH — MANUAL INPUT
/// ============================================================
///
/// Matches the "Manual Input Soil Health Details" screen from the
/// Visily mockup: a plain form of the eight soil parameters, each
/// with its unit shown as a suffix, and a Submit Analysis button.
///
/// Back button returns to SoilHealthHubPage.
class SoilManualInputPage extends StatefulWidget {
  const SoilManualInputPage({super.key});

  @override
  State<SoilManualInputPage> createState() => _SoilManualInputPageState();
}

class _SoilManualInputPageState extends State<SoilManualInputPage> {
  // ── Agriculture theme ────────────────────────────────────────
  static const _green = Color(0xFF2E7D32);
  static const _greenDark = Color(0xFF1B5E20);
  static const _greenLight = Color(0xFFE8F3E8);
  static const _greenSurface = Color(0xFFF4F8F3);
  static const _greenBorder = Color(0xFFCFE3CF);
  static const _text = Color(0xFF17321C);
  static const _muted = Color(0xFF607064);

  bool accessibilityMode = false;

  final _nitrogenController = TextEditingController();
  final _phosphorusController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _organicCarbonController = TextEditingController();
  final _soilMoistureController = TextEditingController();
  final _phLevelController = TextEditingController();
  final _electricalConductivityController = TextEditingController();
  final _temperatureController = TextEditingController();

  @override
  void dispose() {
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _organicCarbonController.dispose();
    _soilMoistureController.dispose();
    _phLevelController.dispose();
    _electricalConductivityController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  void _submit() {
    // Hook this up to the actual soil-analysis backend/API when one
    // exists. For now it just confirms the form was filled in, the
    // same way the existing soil_health_page.dart submit button does.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: _greenDark,
        content: Text('Soil analysis submitted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _greenSurface,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        // Back arrow → Soil Health Hub
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const SoilHealthHubPage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: _greenDark,
          ),
        ),

        title: const Text(
          'Krishi Unnati',
          style: TextStyle(
            color: _greenDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            AccessibilityModeBar(
              value: accessibilityMode,
              onChanged: (v) => setState(() => accessibilityMode = v),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.science_outlined,
                          color: _greenDark,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Manual Input Soil Health Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _greenDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Enter your soil test results manually for '
                      'detailed analysis and personalized fertilizer '
                      'recommendations.',
                      style: TextStyle(
                        fontSize: 11,
                        color: _muted,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Row(
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 14,
                          color: _green,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'SOIL PARAMETERS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3,
                            color: _text,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _field(
                      label: 'Nitrogen (N)',
                      hint: 'Enter nitrogen content',
                      unit: 'kg/ha',
                      controller: _nitrogenController,
                    ),

                    _field(
                      label: 'Phosphorus (P)',
                      hint: 'Enter phosphorus content',
                      unit: 'kg/ha',
                      controller: _phosphorusController,
                    ),

                    _field(
                      label: 'Potassium (K)',
                      hint: 'Enter potassium content',
                      unit: 'kg/ha',
                      controller: _potassiumController,
                    ),

                    _field(
                      label: 'Organic Carbon',
                      hint: 'Enter organic carbon percentage',
                      unit: '%',
                      controller: _organicCarbonController,
                    ),

                    _field(
                      label: 'Soil Moisture',
                      hint: 'Enter moisture percentage',
                      unit: '%',
                      controller: _soilMoistureController,
                    ),

                    _field(
                      label: 'pH Level',
                      hint: 'Enter pH value',
                      unit: 'pH',
                      controller: _phLevelController,
                    ),

                    _field(
                      label: 'Electrical Conductivity',
                      hint: 'Enter EC value',
                      unit: 'dS/m',
                      controller: _electricalConductivityController,
                    ),

                    _field(
                      label: 'Temperature',
                      hint: 'Enter soil temperature',
                      unit: '°C',
                      controller: _temperatureController,
                      isLast: true,
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit Analysis',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required String unit,
    required TextEditingController controller,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 18 : 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _text,
            ),
          ),

          const SizedBox(height: 6),

          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            style: const TextStyle(
              fontSize: 13,
              color: _text,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8A968D),
              ),
              suffixText: unit,
              suffixStyle: const TextStyle(
                fontSize: 11,
                color: _greenDark,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _greenBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _greenBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: _green,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}