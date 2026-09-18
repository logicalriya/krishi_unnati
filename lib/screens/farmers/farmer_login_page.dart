import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'farmer_create_account_page.dart';
import 'farmer_dashboard.dart';

/// ============================================================
/// KRISHI UNNATI — FARMER LOGIN PAGE
/// ============================================================

class FarmerLoginPage extends StatefulWidget {
  const FarmerLoginPage({super.key});

  @override
  State<FarmerLoginPage> createState() =>
      _FarmerLoginPageState();
}

class _FarmerLoginPageState extends State<FarmerLoginPage> {
  bool _accessibilityMode = false;
  bool _pinVisible = false;
  bool _isLoggingIn = false;

  final TextEditingController _mobileController =
      TextEditingController();

  final TextEditingController _pinController =
      TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _loginFarmer() async {
    final String mobile =
        _mobileController.text.trim();

    final String pin =
        _pinController.text.trim();

    // Check mobile number
    if (mobile.isEmpty) {
      _showMessage(
        'Please enter your mobile number',
      );
      return;
    }

    if (mobile.length != 10) {
      _showMessage(
        'Please enter a valid 10-digit mobile number',
      );
      return;
    }

    // Check PIN
    if (pin.isEmpty) {
      _showMessage(
        'Please enter your login PIN',
      );
      return;
    }

    if (pin.length < 4 || pin.length > 6) {
      _showMessage(
        'PIN must contain 4 to 6 characters',
      );
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    // Small delay for login effect.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      _isLoggingIn = false;
    });

    // ==========================================================
    // DEMO LOGIN
    //
    // For now, any valid 10-digit mobile number
    // and valid 4-6 character PIN will open the dashboard.
    //
    // Later you can replace this with Firebase/API/database
    // authentication.
    // ==========================================================

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const HomePage(),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // FORGOT PIN
  // ============================================================

  void _forgotPin() {
    _showMessage(
      'PIN recovery will be available soon',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),

            _buildAccessibilityBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  28,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    _buildAvatar(),

                    const SizedBox(height: 16),

                    _buildHeader(),

                    const SizedBox(height: 24),

                    _buildLoginCard(),

                    const SizedBox(height: 16),

                    _buildHelpCard(),

                    const SizedBox(height: 20),

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        16,
        8,
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
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCESSIBILITY BAR
  // ============================================================

  Widget _buildAccessibilityBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.accessibility_new,
            color: AppColors.primaryGreen,
            size: 22,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Accessibility Mode',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          Switch(
            value: _accessibilityMode,
            activeColor: AppColors.primaryGreen,
            onChanged: (value) {
              setState(() {
                _accessibilityMode = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar() {
    return Center(
      child: Container(
        width: 86,
        height: 86,
        decoration: BoxDecoration(
          color: AppColors.avatarBg,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.cardWhite,
            width: 4,
          ),
        ),
        child: const Icon(
          Icons.person,
          color: AppColors.darkGreen,
          size: 48,
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 6),

        Text(
          'Enter your details to continue',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.mutedText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGIN CARD
  // ============================================================

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel(
            Icons.call_outlined,
            'MOBILE NUMBER',
          ),

          const SizedBox(height: 8),

          _buildMobileField(),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _buildFieldLabel(
                Icons.lock_outline,
                'LOGIN PIN',
              ),

              GestureDetector(
                onTap: _forgotPin,
                child: const Text(
                  'FORGOT PIN?',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _buildPinField(),

          const SizedBox(height: 22),

          _buildLoginButton(),

          const SizedBox(height: 16),

          _buildOrDivider(),

          const SizedBox(height: 16),

          _buildRegisterButton(),
        ],
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _buildFieldLabel(
    IconData icon,
    String label,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primaryGreen,
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE FIELD
  // ============================================================

  Widget _buildMobileField() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardWhite,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.cardBorder,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              '+91',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: _mobileController,

              keyboardType:
                  TextInputType.phone,

              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
                LengthLimitingTextInputFormatter(
                  10,
                ),
              ],

              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),

              decoration:
                  const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter mobile number',
                hintStyle: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 14,
                ),
                contentPadding:
                    EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PIN FIELD
  // ============================================================

  Widget _buildPinField() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardWhite,
      ),
      child: TextField(
        controller: _pinController,

        obscureText: !_pinVisible,

        keyboardType:
            TextInputType.visiblePassword,

        inputFormatters: [
          LengthLimitingTextInputFormatter(
            6,
          ),
        ],

        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          letterSpacing: 2,
        ),

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: 'Enter 4–6 character PIN',

          hintStyle: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 13,
            letterSpacing: 0,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),

          suffixIcon: IconButton(
            icon: Icon(
              _pinVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.mutedText,
            ),
            onPressed: () {
              setState(() {
                _pinVisible = !_pinVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGIN BUTTON
  // ============================================================

  Widget _buildLoginButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed:
            _isLoggingIn ? null : _loginFarmer,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          disabledBackgroundColor:
              AppColors.mutedText,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),

        child: _isLoggingIn
            ? const SizedBox(
                width: 22,
                height: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Login Securely',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(width: 8),

                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // OR DIVIDER
  // ============================================================

  Widget _buildOrDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.cardBorder,
            thickness: 1,
          ),
        ),

        Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mutedText,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),

        Expanded(
          child: Divider(
            color: AppColors.cardBorder,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REGISTER BUTTON
  // ============================================================

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const FarmerCreateAccountPage(),
            ),
          );
        },

        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),

        child: const Text(
          'New Farmer? Register Now',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HELP CARD
  // ============================================================

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(
              color: AppColors.cardWhite,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_outline,
              color:
                  AppColors.primaryGreen,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help logging in?',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 13.5,
                    color:
                        AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Visit your nearest Gram Panchayat office or call our toll-free helpline at 1800-123-4567.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        AppColors.mutedText,
                    height: 1.35,
                  ),
                ),
              ],
            ),
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
          style: TextStyle(
            fontSize: 10,
            color: AppColors.mutedText,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SHARED DESIGN COLORS
// ============================================================

class AppColors {
  // Primary / Brand
  static const Color primaryGreen =
      Color(0xFF2E7D32);

  static const Color darkGreen =
      Color(0xFF1B4D22);

  static const Color background =
      Color(0xFFF4FBF4);

  // Accent / Status
  static const Color amberAlert =
      Color(0xFFF5A623);

  static const Color amberAlertBg =
      Color(0xFFFFF4DE);

  static const Color redAlert =
      Color(0xFFE53935);

  static const Color redAlertBg =
      Color(0xFFFDEAEA);

  static const Color infoBg =
      Color(0xFFE9F6EA);

  // Neutrals
  static const Color textPrimary =
      Color(0xFF1A1A1A);

  static const Color mutedText =
      Color(0xFF6B7A6D);

  static const Color cardBorder =
      Color(0xFFDCEEDD);

  static const Color cardWhite =
      Color(0xFFFFFFFF);

  // Bottom nav
  static const Color navActive =
      Color(0xFF2E7D32);

  static const Color navInactive =
      Color(0xFF9AA79B);

  // Avatar
  static const Color avatarBg =
      Color(0xFFBDEBF2);
}