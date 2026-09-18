import 'package:flutter/material.dart';

/// ============================================================
/// KRISHI UNNATI — HELP / IMMEDIATE ASSISTANCE PAGE
/// ============================================================

class HelpAssistancePage extends StatelessWidget {
  const HelpAssistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // ==================================================
                    // PAGE HEADER
                    // ==================================================

                    _buildHeader(),

                    const SizedBox(height: 24),

                    // ==================================================
                    // EMERGENCY ASSISTANCE CARD
                    // ==================================================
                    _buildAssistanceCard(),

                    const SizedBox(height: 16),

                    // ==================================================
                    // HELPLINE DIRECTORY
                    // ==================================================
                    _buildMoreHelplineButton(context),

                    const SizedBox(height: 24),
                    

                    const SizedBox(height: 28),

                    // ==================================================
                    // FOOTER
                    // ==================================================
                    _buildFooter(),
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
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),

      decoration: const BoxDecoration(
        color: AppColors.cardWhite,

        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),

      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textPrimary,
              size: 28,
            ),

            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),

          const Spacer(),

          Container(
            width: 36,
            height: 36,

            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.eco, color: Colors.white, size: 19),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 68,
          height: 68,

          decoration: BoxDecoration(
            color: AppColors.infoBg,
            shape: BoxShape.circle,

            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),

          child: const Icon(
            Icons.support_agent_outlined,
            color: AppColors.primaryGreen,
            size: 34,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Help & Assistance',
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Get support from our agricultural assistance team',
          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 13,
            color: AppColors.mutedText,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ASSISTANCE CARD
  // ============================================================

  Widget _buildAssistanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.cardWhite,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: AppColors.cardBorder),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ========================================================
          // CARD HEADER
          // ========================================================

          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: AppColors.lightAmber,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.support_agent,
                  color: AppColors.amber,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Need Immediate Assistance?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Talk to an agricultural officer',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================================================
          // DESCRIPTION
          // ========================================================
          Container(
            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: AppColors.lightAmber,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.info_outline, color: AppColors.amber, size: 20),

                SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'Speak directly with our regional agricultural officers and get guidance in your preferred language.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ========================================================
          // PHONE NUMBER
          // ========================================================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

            decoration: BoxDecoration(
              color: AppColors.infoBg,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: AppColors.cardBorder),
            ),

            child: const Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: AppColors.primaryGreen,
                  size: 21,
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Toll-Free Helpline',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedText,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      '1800-123-4567',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ========================================================
          // CALL BUTTON
          // ========================================================
          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton(
              onPressed: () {
                // TODO:
                // Add url_launcher later for actual phone call.
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,

                foregroundColor: Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.call, size: 19, color: Colors.white),

                  SizedBox(width: 8),

                  Text(
                    'Call Toll-Free',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
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
  // MORE HELPLINE BUTTON
  // ============================================================

  Widget _buildMoreHelplineButton(context) {
    return SizedBox(
      height: 52,

      child: OutlinedButton(
        onPressed: () {
          _showHelplineDirectory(context);
        },

        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.cardWhite,

          side: const BorderSide(color: AppColors.cardBorder, width: 1.2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.phone_in_talk_outlined,
              color: AppColors.primaryGreen,
              size: 20,
            ),

            SizedBox(width: 9),

            Text(
              'More Helpline Numbers',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 5),

            Icon(Icons.chevron_right, color: AppColors.mutedText, size: 20),
          ],
        ),
      ),
    );
  }

  
  // ============================================================
  // HELPLINE DIRECTORY
  // ============================================================

  void _showHelplineDirectory(BuildContext context) {
    showModalBottomSheet(
      context: context,

      backgroundColor: AppColors.cardWhite,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),

      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: AppColors.infoBg,
                      borderRadius: BorderRadius.circular(11),
                    ),

                    child: const Icon(
                      Icons.phone_in_talk,
                      color: AppColors.primaryGreen,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Helpline Directory',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.close, color: AppColors.mutedText),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _buildHelplineRow(
                'Agriculture Support',
                '1800-123-4567',
                Icons.agriculture_outlined,
              ),

              const SizedBox(height: 10),

              _buildHelplineRow(
                'Pest & Crop Support',
                '1800-123-4568',
                Icons.bug_report_outlined,
              ),

              const SizedBox(height: 10),

              _buildHelplineRow(
                'Technical Support',
                '1800-123-4569',
                Icons.phone_android_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // HELPLINE ROW
  // ============================================================

  Widget _buildHelplineRow(String title, String number, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: AppColors.background,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.cardBorder),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: AppColors.primaryGreen, size: 20),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.call_outlined,
            color: AppColors.primaryGreen,
            size: 19,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          'KRISHI UNNATI V1.0.1',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.mutedText,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: 4),

        Text(
          '© 2026 Krishi Unnati. This is a government-initiative platform.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: AppColors.mutedText),
        ),
      ],
    );
  }
}

// ============================================================
// KRISHI UNNATI COLOR PALETTE
// ============================================================

class AppColors {
  // ==========================================================
  // PRIMARY GREEN
  // ==========================================================

  static const Color primaryGreen = Color(0xFF2E7D32);

  static const Color darkGreen = Color(0xFF1B4D22);

  static const Color background = Color(0xFFF4FBF4);

  // ==========================================================
  // ALERT / STATUS
  // ==========================================================

  static const Color amber = Color(0xFFF4B942);

  static const Color lightAmber = Color(0xFFFFF4D6);

  static const Color redAlert = Color(0xFFD64545);

  static const Color lightRed = Color(0xFFFDECEC);

  static const Color infoBg = Color(0xFFE9F6EA);

  // ==========================================================
  // NEUTRALS
  // ==========================================================

  static const Color textPrimary = Color(0xFF1A1A1A);

  static const Color mutedText = Color(0xFF6B7A6D);

  static const Color cardBorder = Color(0xFFDCEEDD);

  static const Color cardWhite = Color(0xFFFFFFFF);

  // ==========================================================
  // BOTTOM NAV
  // ==========================================================

  static const Color navActive = Color(0xFF2E7D32);

  static const Color navInactive = Color(0xFF9AA79B);

  // ==========================================================
  // AVATAR / DECORATIVE
  // ==========================================================

  static const Color avatarBg = Color(0xFFBDEBF2);
}
