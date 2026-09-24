import 'package:flutter/material.dart';

import '../../widgets/farmer_page_header.dart';
import '../../state/app_locale.dart';
import 'farmer_dashboard.dart';
import 'soil_upload_page.dart';
import 'soil_manual_input_page.dart';

/// ============================================================
/// SOIL HEALTH — HUB
/// ============================================================
///
/// Matches the "Check Your Soil Health" menu screen from the Visily
/// mockup: entry cards into Upload / Manual Input, an expandable
/// expert-advice FAQ, and an "Ask Experts" query box.
///
/// This is the main entry point for the Soil Health feature.
///
/// Navigation:
///
/// Farmer Dashboard
///       ↓
/// SoilHealthHubPage
///       ├── SoilUploadPage
///       └── SoilManualInputPage
///
/// Back arrow → Farmer Dashboard
class SoilHealthHubPage extends StatefulWidget {
  const SoilHealthHubPage({super.key});

  @override
  State<SoilHealthHubPage> createState() => _SoilHealthHubPageState();
}

class _SoilHealthHubPageState extends State<SoilHealthHubPage> {
  bool accessibilityMode = false;
  bool _faqExpanded = false;

  final _askController = TextEditingController();

  @override
  void dispose() {
    _askController.dispose();
    super.dispose();
  }

  void _askExpert() {
    if (_askController.text.trim().isEmpty) return;

    // Stub: no expert-query backend exists yet. Wire this to a real
    // service (or route it into help_assistance_page.dart's contact
    // flow) once one is available.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocale.of(context).t('questionSubmitted'),
        ),
      ),
    );

    _askController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),

      // ==========================================================
      // HEADER
      // ==========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        // Back arrow → Farmer Dashboard
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1B5E20),
          ),
        ),

        title: const Text(
          'Krishi Unnati',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Color(0xFF1B5E20),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: Column(
          children: [
            AccessibilityModeBar(
              value: accessibilityMode,
              onChanged: (v) {
                setState(() {
                  accessibilityMode = v;
                });
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ==================================================
                    // OVERVIEW PANEL
                    // ==================================================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B8F4D),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x220B8F4D),
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.spa_outlined,
                              size: 27,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 13),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t('checkSoilHealthCard'),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  t('soilHealthOverview'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.86),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // CHOOSE SOIL METHOD
                    // ==================================================
                    Text(
                      t('chooseSoilMethod'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF20252B),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // ==================================================
                    // UPLOAD / MANUAL INPUT CARDS
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: _actionCard(
                            icon: Icons.camera_alt_outlined,
                            label: t('uploadSoilCard'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SoilUploadPage(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _actionCard(
                            icon: Icons.edit_outlined,
                            label: t('manualInputDetails'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SoilManualInputPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // EXPERT SOLUTION
                    // ==================================================
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          size: 16,
                          color: Color(0xFF20252B),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          t('expertSolution'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF20252B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    _buildFaqCard(),

                    const SizedBox(height: 18),

                    // ==================================================
                    // FURTHER QUERY
                    // ==================================================
                    Row(
                      children: [
                        const Icon(
                          Icons.forum_outlined,
                          size: 16,
                          color: Color(0xFF20252B),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          t('furtherQuery'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF20252B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    _buildAskExpertsBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _actionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE1E5EA),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: const Color(0xFF00A94F),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF20252B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FAQ CARD
  // ============================================================

  Widget _buildFaqCard() {
    final t = AppLocale.of(context).t;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE1E5EA),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: _faqExpanded,

          onExpansionChanged: (v) {
            setState(() {
              _faqExpanded = v;
            });
          },

          tilePadding: EdgeInsets.zero,

          childrenPadding: const EdgeInsets.only(
            bottom: 12,
          ),

          title: Text(
            t('wheatRustQuestion'),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF20252B),
            ),
          ),

          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                t('wheatRustAnswer'),
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: Color(0xFF5B6570),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ASK EXPERTS BOX
  // ============================================================

  Widget _buildAskExpertsBox() {
    final t = AppLocale.of(context).t;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9E7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF3E7B8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                size: 15,
                color: Color(0xFF17375E),
              ),

              const SizedBox(width: 6),

              Text(
                t('askExperts'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .3,
                  color: Color(0xFFB98900),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFF0DE9E),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _askController,

                    onSubmitted: (_) => _askExpert(),

                    style: const TextStyle(
                      fontSize: 13,
                    ),

                    decoration: InputDecoration(
                      border: InputBorder.none,

                      hintText: t('askExpertsPlaceholder'),

                      hintStyle: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFFB0B6BC),
                      ),

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: _askExpert,
                  icon: const Icon(
                    Icons.mic_none_outlined,
                    color: Color(0xFFB98900),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}