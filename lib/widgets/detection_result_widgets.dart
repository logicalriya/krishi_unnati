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

  void _showFullReport(BuildContext context, DiseaseInfo info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(diseaseName, style: const TextStyle(fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('AI detection confidence: $probability\n', style: const TextStyle(fontSize: 14)),
              const Text('Preventive Measures:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(info.preventiveMeasures, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 10),
              const Text('Chemical Treatments:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(info.chemicalTreatments, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontSize: 14)),
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