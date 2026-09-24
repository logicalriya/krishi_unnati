import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
                    // PAGE HEADER
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // ==================================================
                    // NEW: EXPERT ADVICE + GOVT SCHEMES BUTTON CARDS
                    // ==================================================
                    _buildQuickCards(context),

                    const SizedBox(height: 20),

                    // EMERGENCY ASSISTANCE CARD
                    _buildAssistanceCard(),

                    const SizedBox(height: 16),

                    // HELPLINE DIRECTORY
                    _buildMoreHelplineButton(context),

                    const SizedBox(height: 24),
                    const SizedBox(height: 28),

                    // FOOTER
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
  // QUICK CARDS
  // ============================================================

  Widget _buildQuickCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickCard(
            title: 'Expert Advice',
            subtitle: 'Crop tips',
            icon: Icons.menu_book_rounded,
            iconColor: AppColors.primaryGreen,
            iconBg: AppColors.infoBg,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExpertAdvicePage()),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _QuickCard(
            title: 'Govt Schemes',
            subtitle: 'Loans & support',
            icon: Icons.account_balance_outlined,
            iconColor: AppColors.darkGreen,
            iconBg: AppColors.lightAmber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GovtSchemesPage()),
              );
            },
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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Add url_launcher later for actual phone call.
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
// REUSABLE QUICK CARD
// ============================================================

class _QuickCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _QuickCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardWhite,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
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
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SIMPLE SUB-PAGE SCAFFOLD
// ============================================================

class _SubPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SubPage({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.cardBorder),
        ),
      ),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: children),
      ),
    );
  }
}

// ============================================================
// LISTEN BUTTON
// ============================================================

class _ListenButton extends StatefulWidget {
  final String text;

  const _ListenButton({required this.text});

  @override
  State<_ListenButton> createState() => _ListenButtonState();
}

class _ListenButtonState extends State<_ListenButton> {
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;

  Future<void> _listen() async {
    if (_isListening) {
      await _flutterTts.stop();

      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }

      return;
    }

    setState(() {
      _isListening = true;
    });

    await _flutterTts.setLanguage('en-IN');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });

    _flutterTts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });

    await _flutterTts.speak(widget.text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _listen,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.cardBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(
        _isListening ? Icons.stop_circle_outlined : Icons.mic_none_outlined,
        size: 18,
      ),
      label: Text(
        _isListening ? 'Stop' : 'Listen',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ============================================================
// EXPERT ADVICE PAGE
// ============================================================

class ExpertAdvicePage extends StatelessWidget {
  const ExpertAdvicePage({super.key});

  // Add more questions here anytime.
  static const List<List<String>> _faqs = [
    [
      'How to treat Wheat Yellow Rust?',
      'Use fungicides like Propiconazole 25 EC. Spray early in the morning. Keep proper field drainage.',
    ],
    [
      'Best organic fertilizers for Paddy?',
      'Use cow dung compost, vermicompost or green manure before planting.',
    ],
    [
      'How to protect crops from aphids?',
      'Monitor the underside of leaves regularly. Remove heavily affected leaves and use recommended pest control measures when infestation increases.',
    ],
    [
      'How often should I irrigate Wheat?',
      'Wheat generally requires irrigation at important growth stages. Maintain adequate soil moisture and avoid excessive standing water.',
    ],
    [
      'How to improve soil fertility naturally?',
      'Use compost, farmyard manure, green manure and suitable crop rotation practices to improve soil structure and nutrient availability.',
    ],
    [
      'What should I do if leaves turn yellow?',
      'Check soil moisture, nutrient availability and possible pest or disease symptoms. Yellowing can have several causes, so inspect the crop before treatment.',
    ],
    [
      'How to prevent fungal diseases in crops?',
      'Maintain proper field spacing, avoid excessive moisture, remove infected plant material and use recommended fungicides when required.',
    ],
    [
      'When should I apply fertilizer?',
      'Apply fertilizers according to the crop growth stage, soil condition and recommended nutrient requirements. Soil testing can help determine suitable application.',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Expert Advice',
      icon: Icons.menu_book_rounded,
      children: [
        for (final faq in _faqs)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                // ==================================================
                // PICTURE SECTION
                // ==================================================
                Container(
                  width: double.infinity,
                  height: 135,
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: AppColors.primaryGreen,
                        size: 42,
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Picture',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        faq[0],
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        faq[1],
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _ListenButton(text: '${faq[0]}. ${faq[1]}'),
                    ],
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        const Center(
          child: Text(
            'Available offline',
            style: TextStyle(fontSize: 12, color: AppColors.mutedText),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GOVT SCHEMES PAGE
// ============================================================

class GovtSchemesPage extends StatelessWidget {
  const GovtSchemesPage({super.key});

  // Add more schemes here anytime.
  static const List<_Scheme> _schemes = [
    _Scheme(
      'Kisan Credit Card',
      'Low interest credit for seasonal farm needs.',
      Icons.credit_card,
      trending: true,
    ),
    _Scheme(
      'PM-KISAN',
      'Income support for eligible farmer families through direct benefit transfer.',
      Icons.account_balance_wallet_outlined,
    ),
    _Scheme(
      'Pradhan Mantri Fasal Bima Yojana',
      'Crop insurance support against specified crop losses and risks.',
      Icons.shield_outlined,
    ),
    _Scheme(
      'PM Krishi Sinchayee Yojana',
      'Support for improving irrigation access and efficient water use in agriculture.',
      Icons.water_drop_outlined,
    ),
    _Scheme(
      'Soil Health Card',
      'Helps farmers understand soil nutrient status and fertilizer requirements.',
      Icons.science_outlined,
    ),
    _Scheme(
      'Agriculture Infrastructure Fund',
      'Financing support for eligible agricultural infrastructure and post-harvest facilities.',
      Icons.warehouse_outlined,
    ),
    _Scheme(
      'National Agriculture Market',
      'Digital agricultural market platform designed to improve market access and price discovery.',
      Icons.storefront_outlined,
    ),
    _Scheme(
      'Paramparagat Krishi Vikas Yojana',
      'Support for farmers adopting organic and sustainable farming practices.',
      Icons.eco_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SubPage(
      title: 'Govt Schemes',
      icon: Icons.account_balance_outlined,
      children: [
        for (final s in _schemes)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                // ==================================================
                // PICTURE SECTION
                // ==================================================
                Container(
                  width: double.infinity,
                  height: 125,
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: AppColors.primaryGreen,
                        size: 40,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Picture',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          s.icon,
                          color: AppColors.primaryGreen,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    s.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (s.trending) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightAmber,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Trending',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 5),

                            Text(
                              s.info,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.mutedText,
                                height: 1.35,
                              ),
                            ),

                            const SizedBox(height: 12),

                            _ListenButton(text: '${s.name}. ${s.info}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Scheme {
  final String name;
  final String info;
  final IconData icon;
  final bool trending;

  const _Scheme(this.name, this.info, this.icon, {this.trending = false});
}

// ============================================================
// KRISHI UNNATI COLOR PALETTE
// ============================================================

class AppColors {
  // PRIMARY GREEN
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B4D22);
  static const Color background = Color(0xFFF4FBF4);

  // ALERT / STATUS
  static const Color amber = Color(0xFFF4B942);
  static const Color lightAmber = Color(0xFFFFF4D6);
  static const Color redAlert = Color(0xFFD64545);
  static const Color lightRed = Color(0xFFFDECEC);
  static const Color infoBg = Color(0xFFE9F6EA);

  // NEUTRALS
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color mutedText = Color(0xFF6B7A6D);
  static const Color cardBorder = Color(0xFFDCEEDD);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // BOTTOM NAV
  static const Color navActive = Color(0xFF2E7D32);
  static const Color navInactive = Color(0xFF9AA79B);

  // AVATAR / DECORATIVE
  static const Color avatarBg = Color(0xFFBDEBF2);
}
