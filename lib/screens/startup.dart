import 'dart:async';
import 'package:flutter/material.dart';

import 'dashboard_choosing_page.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage>
    with TickerProviderStateMixin {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF20A963);
  static const Color darkGreen = Color(0xFF167A48);
  static const Color lightGreen = Color(0xFFEAF7F0);
  static const Color softGreen = Color(0xFFF4FAF6);

  static const Color darkNavy = Color(0xFF1F2937);
  static const Color secondaryText = Color(0xFF667085);

  static const Color borderColor = Color(0xFFDDE8E1);

  // ============================================================
  // LANGUAGE
  // ============================================================

  String selectedLanguage = 'English';

  // ============================================================
  // STARTUP STATES
  // ============================================================

  bool showLanguagePopup = true;
  bool showIntroPopup = false;

  // ============================================================
  // ANIMATION
  // ============================================================

  late AnimationController _introController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoPulseAnimation;

  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;

  late Animation<double> _taglineFadeAnimation;
  late Animation<Offset> _taglineSlideAnimation;

  late Animation<double> _descriptionFadeAnimation;
  late Animation<Offset> _descriptionSlideAnimation;

  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // MAIN INTRO CONTROLLER
    // ==========================================================

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );

    // ==========================================================
    // LOGO
    // 0.0 - 0.28
    // ==========================================================

    _logoScaleAnimation = Tween<double>(
      begin: 0.70,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.28,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.18,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Very subtle pulse after the logo arrives.
    _logoPulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.035,
        ).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.035,
          end: 1.0,
        ).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.25,
          0.48,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // ==========================================================
    // TITLE
    // 0.20 - 0.48
    // ==========================================================

    _titleFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.20,
        0.42,
        curve: Curves.easeOut,
      ),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.20,
          0.48,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ==========================================================
    // TAGLINE
    // 0.36 - 0.64
    // ==========================================================

    _taglineFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.36,
        0.58,
        curve: Curves.easeOut,
      ),
    );

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.36,
          0.64,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ==========================================================
    // DESCRIPTION
    // 0.50 - 0.76
    // ==========================================================

    _descriptionFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.50,
        0.72,
        curve: Curves.easeOut,
      ),
    );

    _descriptionSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.50,
          0.76,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ==========================================================
    // PROGRESS BAR
    // 0.70 - 1.0
    // ==========================================================

    _progressAnimation = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.70,
        1.0,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  // ============================================================
  // CONTINUE AFTER LANGUAGE
  // ============================================================

  void _continueFromLanguage() {
    setState(() {
      showLanguagePopup = false;
      showIntroPopup = true;
    });

    _introController.forward();

    // Show introduction for 2.8 seconds
    Timer(
      const Duration(milliseconds: 2800),
      () {
        if (!mounted) return;

        _openDashboardChoosingPage();
      },
    );
  }

  // ============================================================
  // OPEN DASHBOARD CHOOSING PAGE
  // ============================================================

  void _openDashboardChoosingPage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const DashboardChoosingPage();
        },
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGreen,
      body: Stack(
        children: [
          // ======================================================
          // BACKGROUND
          // ======================================================

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF9FCFA),
                    Color(0xFFEAF6EF),
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // LANGUAGE POPUP
          // ======================================================

          if (showLanguagePopup) _buildLanguagePopup(),

          // ======================================================
          // INTRO POPUP
          // ======================================================

          if (showIntroPopup) _buildIntroPopup(),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE POPUP
  // ============================================================

  Widget _buildLanguagePopup() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            24,
            28,
            24,
            24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFFE1EEE7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF167A48).withOpacity(0.10),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // LOGO
              // ==================================================

              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TITLE
              // ==================================================

              const Text(
                'Choose Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: darkNavy,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Select your preferred language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // ENGLISH
              // ==================================================

              _languageOption(
                value: 'English',
                text: 'English',
              ),

              const SizedBox(height: 10),

              // ==================================================
              // HINDI
              // ==================================================

              _languageOption(
                value: 'Hindi',
                text: 'हिन्दी',
              ),

              const SizedBox(height: 10),

              // ==================================================
              // MARATHI
              // ==================================================

              _languageOption(
                value: 'Marathi',
                text: 'मराठी',
              ),

              const SizedBox(height: 24),

              // ==================================================
              // CONTINUE BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continueFromLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LANGUAGE OPTION
  // ============================================================

  Widget _languageOption({
    required String value,
    required String text,
  }) {
    final bool selected = selectedLanguage == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: selected
              ? lightGreen
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? primaryGreen
                : borderColor,
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language_rounded,
              size: 21,
              color: selected
                  ? primaryGreen
                  : const Color(0xFF7A857E),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: darkNavy,
                ),
              ),
            ),

            // ==================================================
            // RADIO INDICATOR
            // ==================================================

            Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? primaryGreen
                      : const Color(0xFFAAB5AE),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INTRO POPUP
  // ============================================================

  Widget _buildIntroPopup() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            28,
            38,
            28,
            38,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFE1EEE7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF167A48).withOpacity(0.11),
                blurRadius: 35,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // LOGO
              // ==================================================

              FadeTransition(
                opacity: _logoFadeAnimation,
                child: AnimatedBuilder(
                  animation: _introController,
                  builder: (context, child) {
                    final double scale =
                        _logoScaleAnimation.value *
                        _logoPulseAnimation.value;

                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.20),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // KRISHI UNNATI
              // ==================================================

              FadeTransition(
                opacity: _titleFadeAnimation,
                child: SlideTransition(
                  position: _titleSlideAnimation,
                  child: const Text(
                    'KRISHI UNNATI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      color: darkNavy,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // EMPOWERING RURAL GROWTH
              // ==================================================

              FadeTransition(
                opacity: _taglineFadeAnimation,
                child: SlideTransition(
                  position: _taglineSlideAnimation,
                  child: const Text(
                    'Empowering Rural Growth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: primaryGreen,
                      height: 1.15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 13),

              // ==================================================
              // DESCRIPTION
              // ==================================================

              FadeTransition(
                opacity: _descriptionFadeAnimation,
                child: SlideTransition(
                  position: _descriptionSlideAnimation,
                  child: const Text(
                    'Bridging the gap between farmers and '
                    'government schemes for a prosperous future.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      color: secondaryText,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 27),

              // ==================================================
              // ANIMATED LOADING INDICATOR
              // ==================================================

              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 45,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: const Color(0xFFE4EFE8),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          primaryGreen,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}