import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'farmer_create_account_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String name;
  final String mobileNumber;

  const OTPVerificationPage({
    super.key,
    required this.name,
    required this.mobileNumber,
  });

  @override
  State<OTPVerificationPage> createState() =>
      _OTPVerificationPageState();
}

class _OTPVerificationPageState
    extends State<OTPVerificationPage> {
  final TextEditingController _otpController =
      TextEditingController();

  bool _isVerifying = false;

  // Demo OTP for testing
  // Later this will come from your real SMS service.
  final String demoOTP = '123456';

  @override
  void initState() {
    super.initState();

    // Start listening for incoming SMS OTP.
    _startListeningForOTP();
  }

  // ============================================================
  // START SMS OTP LISTENER
  // ============================================================

  Future<void> _startListeningForOTP() async {
    try {
      await SmsAutoFill().listenForCode(
        smsCodeRegexPattern: r'\d{6}',
      );
    } catch (e) {
      // Autofill may not work on every device.
      // Manual OTP entry will still work.
    }

    SmsAutoFill().code.listen((code) {
      if (!mounted) return;

      if (code.isEmpty) return;

      // Keep only numbers.
      final String cleanCode =
          code.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanCode.length >= 6) {
        final String otp = cleanCode.substring(0, 6);

        _otpController.text = otp;

        // Automatically verify once OTP is received.
        _verifyOTP();
      }
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();

    _otpController.dispose();

    super.dispose();
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  void _verifyOTP() {
    if (_isVerifying) return;

    final String enteredOTP =
        _otpController.text.trim();

    if (enteredOTP.isEmpty) {
      _showMessage(
        'Please enter the verification code',
      );
      return;
    }

    if (enteredOTP.length != 6) {
      _showMessage(
        'Please enter the complete 6-digit OTP',
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Small delay for a natural verification effect.
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        if (enteredOTP == demoOTP) {
          setState(() {
            _isVerifying = false;
          });

          // IMPORTANT:
          // Return to FarmerCreateAccountPage.
          //
          // The registration page will receive true
          // and then show the PIN container.
          Navigator.pop(context, true);
        } else {
          setState(() {
            _isVerifying = false;
          });

          _showMessage(
            'Incorrect OTP. Please try again.',
          );
        }
      },
    );
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<void> _resendOTP() async {
    _otpController.clear();

    try {
      await SmsAutoFill().unregisterListener();

      await SmsAutoFill().listenForCode(
        smsCodeRegexPattern: r'\d{6}',
      );
    } catch (e) {
      // Manual entry will still work.
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'A new OTP has been sent. Demo OTP: 123456',
        ),
        backgroundColor: AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
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
  // OTP FIELD
  // ============================================================

  Widget _buildOTPField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border.all(
          color: AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _otpController,

        keyboardType: TextInputType.number,

        // Only numbers.
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],

        maxLength: 6,

        textAlign: TextAlign.center,

        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 8,
          color: AppColors.textPrimary,
        ),

        // Helps the platform understand this is an OTP field.
        autofillHints: const [
          AutofillHints.oneTimeCode,
        ],

        onChanged: (value) {
          // Automatically verify when user manually
          // enters all 6 digits.
          if (value.length == 6) {
            _verifyOTP();
          }
        },

        decoration: const InputDecoration(
          counterText: '',
          hintText: '------',
          hintStyle: TextStyle(
            color: AppColors.mutedText,
            fontSize: 20,
            letterSpacing: 5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VERIFY BUTTON
  // ============================================================

  Widget _buildVerifyButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _isVerifying ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          disabledBackgroundColor:
              AppColors.mutedText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isVerifying
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
  // DEMO OTP CARD
  // ============================================================

  Widget _buildDemoOTPCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primaryGreen,
            size: 21,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.mutedText,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Demo mode: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'use OTP ',
                  ),
                  TextSpan(
                    text: '123456',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  TextSpan(
                    text: ' to continue.',
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
              Navigator.of(context).pop();
            },
          ),

          const Spacer(),

          const Icon(
            Icons.eco,
            color: AppColors.primaryGreen,
            size: 26,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            // Top bar
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  30,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [

                    // ==================================================
                    // VERIFICATION ICON
                    // ==================================================

                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color:
                              AppColors.primaryGreen,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==================================================
                    // HEADING
                    // ==================================================

                    const Text(
                      'Verify your mobile number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Enter the 6-digit verification code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            AppColors.mutedText,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // MOBILE NUMBER
                    // ==================================================

                    Text(
                      '+91 ${widget.mobileNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors.primaryGreen,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // OTP LABEL
                    // ==================================================

                    const Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color:
                              AppColors.primaryGreen,
                        ),

                        SizedBox(width: 6),

                        Text(
                          'VERIFICATION CODE',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                AppColors.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ==================================================
                    // OTP FIELD
                    // ==================================================

                    _buildOTPField(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // DEMO INFORMATION
                    // ==================================================

                    _buildDemoOTPCard(),

                    const SizedBox(height: 24),

                    // ==================================================
                    // VERIFY BUTTON
                    // ==================================================

                    _buildVerifyButton(),

                    const SizedBox(height: 18),

                    // ==================================================
                    // RESEND
                    // ==================================================

                    Center(
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              fontSize: 13.5,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),

                          InkWell(
                            onTap: _resendOTP,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 13.5,
                                color:
                                    AppColors.primaryGreen,
                                fontWeight:
                                    FontWeight.bold,
                                decoration:
                                    TextDecoration
                                        .underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // SECURITY INFORMATION
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color:
                            AppColors.cardWhite,
                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              AppColors.cardBorder,
                        ),
                      ),

                      child: const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.security_outlined,
                            color:
                                AppColors.primaryGreen,
                            size: 21,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Your mobile number helps keep your farmer account secure.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color:
                                    AppColors.mutedText,
                                height: 1.4,
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
          ],
        ),
      ),
    );
  }
}