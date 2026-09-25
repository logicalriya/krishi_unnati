import 'package:flutter/material.dart';
import '../data/disease_info.dart';

// ------------------------------------------------------------
// DETECTION RESULTS HEADER
// ------------------------------------------------------------

class DetectionResultsHeader extends StatelessWidget {
  final int matchCount;

  const DetectionResultsHeader({super.key, required this.matchCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'DETECTION RESULTS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF297A4A),
              letterSpacing: 0.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '$matchCount MATCHES FOUND',
              style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// DISEASE RESULT CARD
// ------------------------------------------------------------

class DiseaseResultCard extends StatelessWidget {
  final String diseaseName;
  final String rawLabel;
  final String probability;
  final bool highRisk;

  const DiseaseResultCard({
    super.key,
    required this.diseaseName,
    required this.rawLabel,
    required this.probability,
    required this.highRisk,
  });

  @override
  Widget build(BuildContext context) {
    final info = getDiseaseInfo(rawLabel);

    return GestureDetector(
      onTap: () => _showFullReport(context, info),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E5E5)),
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
                    color: const Color(0xFFEFF7EF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.eco_outlined, size: 28, color: Color(0xFF20A963)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diseaseName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline, size: 13, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'SYSTEM CONFIRMED',
                            style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 0.3, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Possibility: $probability',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF18894F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFEFEFEF)),
            const SizedBox(height: 14),

            // Short summary — same as before. Detailed step-by-step
            // guidance lives in the full report sheet, not here.
            const Text(
              'Preventive Measures:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              info.preventiveMeasures,
              style: const TextStyle(fontSize: 12.5, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 12),

            const Text(
              'Chemical Treatments:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              info.chemicalTreatments,
              style: const TextStyle(fontSize: 12.5, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tap to see full diagnosis report',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FULL DIAGNOSIS REPORT — detailed, step-by-step version of the
  // card's summary, shown as a scrollable bottom sheet.
  // ============================================================

  void _showFullReport(BuildContext context, DiseaseInfo info) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF7EF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.eco_outlined, size: 24, color: Color(0xFF20A963)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diseaseName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'AI confidence: $probability',
                                style: const TextStyle(fontSize: 12.5, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 24),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0xFFE8E8E8)),

                  // Scrollable detailed content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                      children: [
                        _sectionTitle('Preventive Measures', Icons.shield_outlined, const Color(0xFF20A963)),
                        const SizedBox(height: 10),
                        ...info.detailedPreventiveMeasures.asMap().entries.map(
                              (entry) => _numberedStep(entry.key + 1, entry.value, const Color(0xFF20A963)),
                        ),

                        const SizedBox(height: 24),

                        _sectionTitle('Chemical Treatments', Icons.science_outlined, const Color(0xFF2563EB)),
                        const SizedBox(height: 10),
                        ...info.detailedChemicalTreatments.asMap().entries.map(
                              (entry) => _numberedStep(entry.key + 1, entry.value, const Color(0xFF2563EB)),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEE),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE3BE62)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Color(0xFF806000)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'This guidance is general — always confirm chemical dosage and safety instructions on the product label or with a local agricultural expert before applying.',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF806000), height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _sectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _numberedStep(int number, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF333333), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// FAQ BUTTON
// ------------------------------------------------------------

class FaqButton extends StatelessWidget {
  final VoidCallback onTap;

  const FaqButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Common farming solutions & FAQs\n(Available Offline)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.4),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// ASK EXPERTS SECTION
// ------------------------------------------------------------

class AskExpertsSection extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const AskExpertsSection({super.key, required this.onSubmit});

  @override
  State<AskExpertsSection> createState() => _AskExpertsSectionState();
}

class _AskExpertsSectionState extends State<AskExpertsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.chat_bubble_outline, size: 20, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                'Further Query',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'ASK EXPERTS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFA16207), letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF0),
              border: Border.all(color: const Color(0xFFFBBF24)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'What you want to know...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic_none, size: 22, color: Color(0xFFA16207)),
                  onPressed: () {
                    // TODO: hook up voice input (speech_to_text package) if needed
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.onSubmit(value.trim());
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}