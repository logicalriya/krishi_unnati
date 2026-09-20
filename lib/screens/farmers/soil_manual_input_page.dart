import 'package:flutter/material.dart';

import '../../widgets/farmer_page_header.dart';

/// ============================================================
/// SOIL HEALTH — MANUAL INPUT
/// ============================================================
///
/// Matches the "Manual Input Soil Health Details" screen from the
/// Visily mockup: a plain form of the eight soil parameters, each
/// with its unit shown as a suffix, and a Submit Analysis button.
class SoilManualInputPage extends StatefulWidget {
  const SoilManualInputPage({super.key});

  @override
  State<SoilManualInputPage> createState() => _SoilManualInputPageState();
}

class _SoilManualInputPageState extends State<SoilManualInputPage> {
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
        content: Text('Soil analysis submitted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      appBar: const FarmerPageHeader(title: 'Krishi Unnati'),
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
                        Icon(Icons.science_outlined,
                            color: Color(0xFFDB6E1F), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Manual Input Soil Health Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDB6E1F),
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
                        color: Color(0xFF707780),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Row(
                      children: [
                        Icon(Icons.eco_outlined,
                            size: 14, color: Color(0xFF00A94F)),
                        SizedBox(width: 5),
                        Text(
                          'SOIL PARAMETERS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .3,
                            color: Color(0xFF30343B),
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
                          backgroundColor: const Color(0xFF00A94F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
      padding: EdgeInsets.only(bottom: isLast ? 18 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF30343B),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFFB0B6BC),
              ),
              suffixText: unit,
              suffixStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9BA2A9),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD9DDE1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD9DDE1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF00A94F)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
