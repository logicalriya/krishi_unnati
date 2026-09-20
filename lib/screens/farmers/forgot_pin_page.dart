import 'package:flutter/material.dart';

import '../../services/local_db.dart';
import '../../state/app_locale.dart';
import 'farmer_login_page.dart';

class ForgotPinPage extends StatefulWidget {
  const ForgotPinPage({super.key});

  @override
  State<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends State<ForgotPinPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _codeSent = false;
  bool _verified = false;
  bool _busy = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendCode() async {
    final t = AppLocale.of(context).t;
    final phone = _phoneController.text.trim();
    if (phone.length != 10) {
      _message(t('enterValidMobileNumber'));
      return;
    }

    setState(() => _busy = true);
    final exists = await LocalDb.accountExists(phone: phone, role: 'farmer');
    if (!mounted) return;
    if (!exists) {
      setState(() => _busy = false);
      _message(t('accountNotFound'));
      return;
    }

    final code = await LocalDb.generateOtp(phone);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _codeSent = true;
    });
    _message('${t('verificationCodeSent')} $code');
  }

  Future<void> _verifyCode() async {
    final t = AppLocale.of(context).t;
    final error = await LocalDb.verifyOtp(
      _phoneController.text.trim(),
      _otpController.text.trim(),
    );
    if (!mounted) return;
    if (error != null) {
      _message(t('invalidVerificationCode'));
      return;
    }
    setState(() => _verified = true);
    _message(t('mobileVerified'));
  }

  Future<void> _resetPin() async {
    final t = AppLocale.of(context).t;
    final pin = _pinController.text.trim();
    final confirm = _confirmPinController.text.trim();
    if (pin.length < 4 || pin.length > 6) {
      _message(t('pinLengthError'));
      return;
    }
    if (pin != confirm) {
      _message(t('pinsDoNotMatch'));
      return;
    }

    setState(() => _busy = true);
    final error = await LocalDb.resetPassword(
      phone: _phoneController.text.trim(),
      role: 'farmer',
      newPassword: pin,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      _message(error);
      return;
    }

    _message(t('pinUpdated'));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const FarmerLoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t('forgotPin'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F6EC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: Color(0xFF0B8F4D),
                size: 56,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              t('resetPinTitle'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t('resetPinDescription'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF607064), height: 1.4),
            ),
            const SizedBox(height: 22),
            _field(
              label: t('phoneNumber'),
              hint: t('enterYourMobileNumber'),
              controller: _phoneController,
              enabled: !_verified,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            if (!_codeSent)
              _button(
                label: t('sendVerificationCode'),
                onPressed: _busy ? null : _sendCode,
              ),
            if (_codeSent && !_verified) ...[
              _field(
                label: t('verificationCode'),
                hint: t('enterVerificationCode'),
                controller: _otpController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _button(
                label: t('verifyCode'),
                onPressed: _busy ? null : _verifyCode,
              ),
            ],
            if (_verified) ...[
              _field(
                label: t('newPin'),
                hint: t('createFarmerPin'),
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _field(
                label: t('confirmPinRequired'),
                hint: t('confirmPinRequired'),
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              _button(
                label: t('updatePin'),
                onPressed: _busy ? null : _resetPin,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _button({required String label, required VoidCallback? onPressed}) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B8F4D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
