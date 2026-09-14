import 'dart:async';
import 'package:flutter/material.dart';

import 'screens/dashboard_choosing_page.dart';

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

  static const Color primaryGreen = Color(0xFF3F713F);
  static const Color darkNavy = Color(0xFF17233D);

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

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
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
      backgroundColor: const Color(0xFFF5F8F4),

      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF9FBF8),
                    Color(0xFFEFF5ED),
                  ],
                ),
              ),
            ),
          ),

          // Language popup
          if (showLanguagePopup) _buildLanguagePopup(),

          // Intro popup
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 18),

              // TITLE
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
                  color: Color(0xFF6A7078),
                ),
              ),

              const SizedBox(height: 22),

              // English
              _languageOption(
                value: 'English',
                text: 'English',
              ),

              const SizedBox(height: 10),

              // Hindi
              _languageOption(
                value: 'Hindi',
                text: 'हिन्दी',
              ),

              const SizedBox(height: 10),

              // Marathi
              _languageOption(
                value: 'Marathi',
                text: 'मराठी',
              ),

              const SizedBox(height: 24),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continueFromLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 2,
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
              ? const Color(0xFFEAF3E8)
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? primaryGreen
                : const Color(0xFFD8DED7),
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
                  : const Color(0xFF68716A),
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

            // Radio indicator
            Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? primaryGreen
                      : const Color(0xFF9CA49D),
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
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // KRISHI UNNATI
                    FadeTransition(
                      opacity: _fadeAnimation,
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

                    const SizedBox(height: 15),

                    // EMPOWERING RURAL GROWTH
                    FadeTransition(
                      opacity: _fadeAnimation,
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

                    const SizedBox(height: 13),

                    // DESCRIPTION
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Bridging the gap between farmers and '
                        'government schemes for a prosperous future.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555D68),
                        ),
                      ),
                    ),

                    const SizedBox(height: 27),

                    // LOADING INDICATOR
                    SizedBox(
                      width: 45,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          backgroundColor: Color(0xFFE4EAE2),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(
                            primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}