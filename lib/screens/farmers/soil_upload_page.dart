import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/farmer_page_header.dart';
import 'soil_health_page.dart' show DashedBorderPainter;

/// ============================================================
/// SOIL HEALTH — UPLOAD CARD
/// ============================================================
///
/// Matches the "Upload Your Soil Health Card" screen from the Visily
/// mockup. Reuses the same file-picking approach and dashed-border
/// upload box already built in soil_health_page.dart, rather than
/// re-implementing file picking from scratch.
class SoilUploadPage extends StatefulWidget {
  const SoilUploadPage({super.key});

  @override
  State<SoilUploadPage> createState() => _SoilUploadPageState();
}

class _SoilUploadPageState extends State<SoilUploadPage> {
  // ── Agriculture theme ────────────────────────────────────────
  static const _green = Color(0xFF2E7D32);
  static const _greenDark = Color(0xFF1B5E20);
  static const _greenLight = Color(0xFFE8F3E8);
  static const _greenSurface = Color(0xFFF4F8F3);
  static const _greenBorder = Color(0xFFCFE3CF);
  static const _text = Color(0xFF17321C);
  static const _muted = Color(0xFF607064);

  bool accessibilityMode = false;
  String? selectedFileName;

  Future<void> _pickSoilCard() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  void _submit() {
    if (selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: _greenDark,
          content: Text('Please select a file first'),
        ),
      );
      return;
    }

    // Hook this up to the actual soil-analysis backend/API when one
    // exists.
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
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _greenBorder,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _greenDark.withOpacity(0.06),
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.description_outlined,
                                size: 18,
                                color: _greenDark,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Upload Your Soil Health Card',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: _text,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Upload your government-issued soil health '
                            'card for quick automated analysis.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: _muted,
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: _pickSoilCard,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: _greenSurface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomPaint(
                                painter: DashedBorderPainter(),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(
                                          color: _greenLight,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 22,
                                          color: _greenDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        selectedFileName ??
                                            'Drag & drop or select file',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: selectedFileName != null
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: _text,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Supported: JPG, PNG, PDF (Max 5MB)',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: _muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

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
}