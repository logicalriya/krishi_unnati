import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const KrishiUnnatiApp());
}

// ============================================================
// APP
// ============================================================

class KrishiUnnatiApp extends StatelessWidget {
  const KrishiUnnatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi Unnati',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F8F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home: const ExtensionOfficerLoginScreen(),
    );
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================

class ExtensionOfficerLoginScreen extends StatefulWidget {
  const ExtensionOfficerLoginScreen({super.key});

  @override
  State<ExtensionOfficerLoginScreen> createState() =>
      _ExtensionOfficerLoginScreenState();
}

class _ExtensionOfficerLoginScreenState
    extends State<ExtensionOfficerLoginScreen> {
  static const Color green = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenSoft = Color(0xFFE8F3E8);
  static const Color greenBorder = Color(0xFFCFE3CF);
  static const Color text = Color(0xFF17321C);
  static const Color muted = Color(0xFF607064);
  static const Color border = Color(0xFFD5E0D6);

  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _remember = false;
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in'),
      ),
    );
  }

  void _openCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ExtensionOfficerCreateAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F3),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const Divider(
              height: 1,
              thickness: 1,
              color: border,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    28,
                    16,
                    24,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: greenSoft,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: greenBorder,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: greenDark,
                          size: 27,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Officer Login',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Sign in to access your officer account.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLoginCard(),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'LOGIN',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: border,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              'Haven\'t registered yet?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: muted,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: border,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _openCreateAccount,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: greenDark,
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: green,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'REGISTER',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: greenDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Krishi Unnati',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: greenBorder,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fieldLabel(
              Icons.badge_outlined,
              'LOGIN ID',
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: _idController,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9-]'),
                ),
                UpperCaseTextFormatter(),
              ],
              decoration: _inputDecoration(
                'e.g. ADM-7729-KA',
              ),
              validator: (value) {
                final v = value?.trim() ?? '';

                if (v.isEmpty) {
                  return 'Enter your Login ID';
                }

                if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(v)) {
                  return 'Use only letters, numbers and -';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            _fieldLabel(
              Icons.lock_outline,
              'PASSWORD',
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscure,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(r'\s'),
                ),
              ],
              decoration: _inputDecoration(
                'Enter your password',
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: greenDark,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }

                if (value.contains(' ')) {
                  return 'Spaces are not allowed';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  activeColor: green,
                  onChanged: (value) {
                    setState(() {
                      _remember = value ?? false;
                    });
                  },
                ),
                Text(
                  'Remember me',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(
    IconData icon,
    String label,
  ) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: greenSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: greenDark,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: text,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: const Color(0xFF849287),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FCF9),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: green,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.red.shade400,
        ),
      ),
    );
  }
}

// ============================================================
// CREATE ACCOUNT SCREEN
// ============================================================

class ExtensionOfficerCreateAccountScreen
    extends StatefulWidget {
  const ExtensionOfficerCreateAccountScreen({
    super.key,
  });

  @override
  State<ExtensionOfficerCreateAccountScreen> createState() =>
      _ExtensionOfficerCreateAccountScreenState();
}

class _ExtensionOfficerCreateAccountScreenState
    extends State<ExtensionOfficerCreateAccountScreen> {
  static const Color green = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenSoft = Color(0xFFE8F3E8);
  static const Color greenBorder = Color(0xFFCFE3CF);
  static const Color text = Color(0xFF17321C);
  static const Color muted = Color(0xFF607064);
  static const Color border = Color(0xFFD5E0D6);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OTPVerificationScreen(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          departmentId: _departmentController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 28),
                      _buildField(
                        label: 'FULL NAME',
                        icon: Icons.person_outline,
                        controller: _nameController,
                        hint: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        textCapitalization:
                            TextCapitalization.words,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z ]'),
                          ),
                        ],
                        validator: (value) {
                          final v = value?.trim() ?? '';

                          if (v.isEmpty) {
                            return 'Enter your full name';
                          }

                          if (v.length < 3) {
                            return 'Enter a valid name';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        label: 'DEPARTMENT ID',
                        icon: Icons.badge_outlined,
                        controller: _departmentController,
                        hint: 'Enter 12-digit ID',
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        validator: (value) {
                          final v = value?.trim() ?? '';

                          if (v.isEmpty) {
                            return 'Enter your department ID';
                          }

                          if (v.length != 12) {
                            return 'Department ID must contain 12 digits';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildField(
                        label: 'PHONE NUMBER',
                        icon: Icons.phone_outlined,
                        controller: _phoneController,
                        hint: 'Enter 10-digit mobile number',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          final v = value?.trim() ?? '';

                          if (v.isEmpty) {
                            return 'Enter your phone number';
                          }

                          if (v.length != 10) {
                            return 'Enter a valid 10-digit number';
                          }

                          if (!RegExp(r'^[6-9]').hasMatch(v)) {
                            return 'Enter a valid Indian mobile number';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _continue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CONTINUE',
                                      style:
                                          GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Already have an account? Log In',
                            style:
                                GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: greenDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: greenSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: greenBorder,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: greenDark,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Your phone number will be verified using a one-time password.',
                                style:
                                    GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  height: 1.45,
                                  color: const Color(0xFF466052),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          const _BrandLogo(),
          const SizedBox(width: 10),
          Text(
            'Krishi Unnati',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: greenBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Official Account',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: text,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Enter your official details to continue.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: muted,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: greenSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 19,
                  color: green,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'Extension Officer',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: greenDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required String? Function(String?) validator,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    int? maxLength,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        13,
        14,
        5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: greenSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: greenDark,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            validator: validator,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: text,
            ),
            decoration: InputDecoration(
              hintText: hint,
              counterText: '',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFF98A79B),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FCF9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: green,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 1.5,
                ),
              ),
              errorStyle: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// OTP VERIFICATION SCREEN
// ============================================================

class OTPVerificationScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String departmentId;

  const OTPVerificationScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.departmentId,
  });

  @override
  State<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState
    extends State<OTPVerificationScreen> {
  static const Color green = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenSoft = Color(0xFFE8F3E8);
  static const Color greenBorder = Color(0xFFCFE3CF);
  static const Color text = Color(0xFF17321C);
  static const Color muted = Color(0xFF607064);
  static const Color border = Color(0xFFD5E0D6);

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SecurePasswordScreen(
          name: widget.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maskedPhone =
        '******${widget.phone.substring(widget.phone.length - 4)}';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  35,
                  20,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: greenSoft,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: greenBorder,
                          ),
                        ),
                        child: const Icon(
                          Icons.phone_android_outlined,
                          size: 29,
                          color: green,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Verify Phone Number',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the 6-digit OTP sent to',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        maskedPhone,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: greenDark,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _otpController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 8,
                          color: text,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••',
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF9FCF9),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: green,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length != 6) {
                            return 'Enter the 6-digit OTP';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'VERIFY OTP',
                                  style:
                                      GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'OTP resent successfully',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Resend OTP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: greenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          const _BrandLogo(),
          const SizedBox(width: 10),
          Text(
            'Krishi Unnati',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ============================================================
// SECURE PASSWORD SCREEN
// ============================================================

class SecurePasswordScreen extends StatefulWidget {
  final String name;

  const SecurePasswordScreen({
    super.key,
    required this.name,
  });

  @override
  State<SecurePasswordScreen> createState() =>
      _SecurePasswordScreenState();
}

class _SecurePasswordScreenState
    extends State<SecurePasswordScreen> {
  static const Color green = Color(0xFF2E7D32);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color greenSoft = Color(0xFFE8F3E8);
  static const Color greenBorder = Color(0xFFCFE3CF);
  static const Color text = Color(0xFF17321C);
  static const Color muted = Color(0xFF607064);

  late String _password;
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
    _password = _generatePassword();
  }

  String _generatePassword() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789@#';

    final random = Random();

    return List.generate(
      12,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  void _copyPassword() {
    Clipboard.setData(
      ClipboardData(
        text: _password,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Secure password copied',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  35,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: greenSoft,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: greenBorder,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 34,
                        color: green,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Verification Successful',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your official account has been verified.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'YOUR SECURE PASSWORD',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: greenBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _showPassword
                                  ? _password
                                  : '••••••••••••',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: text,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _copyPassword,
                            icon: const Icon(
                              Icons.copy_outlined,
                              size: 19,
                              color: greenDark,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: greenDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF0DFAB),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_outlined,
                            size: 18,
                            color: Color(0xFF9A7200),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Save this password securely. Do not share it with anyone.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                height: 1.45,
                                color: const Color(0xFF705A20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'CONTINUE TO LOGIN',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome, ${widget.name}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: muted,
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

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD5E0D6),
          ),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          const _BrandLogo(),
          const SizedBox(width: 10),
          Text(
            'Krishi Unnati',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ============================================================
// BRAND LOGO
// ============================================================

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      decoration: const BoxDecoration(
        color: Color(0xFF2E7D32),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.eco,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

// ============================================================
// UPPERCASE TEXT FORMATTER
// ============================================================

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}