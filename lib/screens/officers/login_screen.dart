import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'create_account_screen.dart';

/// Extension Officer – Login
class ExtensionOfficerLoginScreen extends StatefulWidget {
  const ExtensionOfficerLoginScreen({super.key});

  @override
  State<ExtensionOfficerLoginScreen> createState() =>
      _ExtensionOfficerLoginScreenState();
}

class _ExtensionOfficerLoginScreenState
    extends State<ExtensionOfficerLoginScreen> {
  // ── Design tokens ──────────────────────────────────────────────
  static const _green = Color(0xFF2E7D32);
  static const _greenDark = Color(0xFF1B5E20);
  static const _greenLight = Color(0xFFE8F3E8);
  static const _greenBorder = Color(0xFFCFE3CF);
  static const _text = Color(0xFF17321C);
  static const _muted = Color(0xFF607064);
  static const _border = Color(0xFFD5E0D6);
  static const _surface = Color(0xFFF4F8F3);

  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _remember = false;
  bool _loading = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // Frontend simulation
    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in'),
      ),
    );
  }

  // ── Register navigation ────────────────────────────────────────
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
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const Divider(
              height: 1,
              thickness: 1,
              color: _border,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        28,
                        16,
                        10,
                      ),
                      child: _buildBody(),
                    ),
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

  // ── Header ─────────────────────────────────────────────────────
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
              color: _green,
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
              color: _greenDark,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────
  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _greenLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _greenBorder,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: _greenDark,
                  size: 27,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Officer Login',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: _text,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Sign in to access your officer account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildCredentialsCard(),

        const SizedBox(height: 18),

        // Login button
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _green.withOpacity(0.6),
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

        // Register section
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: _border,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Haven\'t registered yet?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: _muted,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: _border,
                thickness: 1,
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
              foregroundColor: _greenDark,
              backgroundColor: Colors.white,
              side: const BorderSide(
                color: _green,
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

        Center(
          child: GestureDetector(
            onTap: () {
              // TODO: navigate to forgot-password flow
            },
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: _greenDark,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Credentials card ───────────────────────────────────────────
  Widget _buildCredentialsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _greenBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1B5E20),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel(
              icon: Icons.badge_outlined,
              text: 'LOGIN ID',
            ),

            const SizedBox(height: 7),

            TextFormField(
              controller: _idCtrl,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9-]'),
                ),
                UpperCaseTextFormatter(),
              ],
              autofillHints: const [
                AutofillHints.username,
              ],
              style: _inputTextStyle,
              decoration: _decoration(
                'e.g. ADM-7729-KA',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';

                if (value.isEmpty) {
                  return 'Enter your Login ID';
                }

                if (!RegExp(r'^[A-Z0-9-]+$').hasMatch(value)) {
                  return 'Use only letters, numbers and -';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            const _FieldLabel(
              icon: Icons.lock_outline,
              text: 'PASSWORD',
            ),

            const SizedBox(height: 7),

            TextFormField(
              controller: _passCtrl,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _login(),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(r'\s'),
                ),
              ],
              autofillHints: const [
                AutofillHints.password,
              ],
              style: _inputTextStyle,
              decoration: _decoration(
                'Enter your password',
                suffix: IconButton(
                  tooltip:
                      _obscure ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: _greenDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Enter your password';
                }

                if (v.contains(' ')) {
                  return 'Spaces are not allowed';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: _remember,
                    activeColor: _green,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF6B7A6D),
                      width: 1.5,
                    ),
                    onChanged: (v) {
                      setState(() {
                        _remember = v ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _remember = !_remember;
                    });
                  },
                  child: Text(
                    'Remember me',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: _text,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Footer ─────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6EF),
        border: Border(
          top: BorderSide(
            color: _greenBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'KRISHI UNNATI V1.0.1',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: _greenDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '© 2026 Krishi Unnati',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 8.5,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _inputTextStyle =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: _text,
      );

  InputDecoration _decoration(
    String hint, {
    Widget? suffix,
  }) {
    OutlineInputBorder border(
      Color color, [
      double width = 1,
    ]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: const Color(0xFF849287),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FCF9),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      suffixIcon: suffix,
      enabledBorder: border(_border),
      focusedBorder: border(_green, 1.5),
      errorBorder: border(Colors.red.shade400),
      focusedErrorBorder: border(
        Colors.red.shade400,
        1.5,
      ),
      errorStyle: GoogleFonts.plusJakartaSans(
        fontSize: 10.5,
      ),
    );
  }
}

// ── Field label ──────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F3E8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: Color(0xFF17321C),
          ),
        ),
      ],
    );
  }
}

// ── Uppercase formatter ─────────────────────────────────────────

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}