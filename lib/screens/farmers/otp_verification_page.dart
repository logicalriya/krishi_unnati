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

  final FocusNode _otpFocusNode = FocusNode();

  bool _isVerifying = false;

  // Demo OTP for testing
  final String demoOTP = '123456';

  @override
  void initState() {
    super.initState();

    _startListeningForOTP();

    // Open numeric keyboard automatically.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _otpFocusNode.requestFocus();

      SystemChannels.textInput.invokeMethod(
        'TextInput.show',
      );
    });
  }

  // ============================================================
  // SMS OTP LISTENER
  // ============================================================

  Future<void> _startListeningForOTP() async {
    try {
      await SmsAutoFill().listenForCode(
        smsCodeRegexPattern: r'\d{6}',
      );
    } catch (e) {
      // Manual entry still works.
    }

    SmsAutoFill().code.listen((code) {
      if (!mounted) return;

      if (code.isEmpty) return;

      final String cleanCode =
          code.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanCode.length >= 6) {
        final String otp =
            cleanCode.substring(0, 6);

        _otpController.text = otp;

        // Keep focus after autofill.
        _otpFocusNode.requestFocus();

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

    _otpFocusNode.dispose();
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

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        if (enteredOTP == demoOTP) {
          setState(() {
            _isVerifying = false;
          });

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
      // Manual entry still works.
    }

    if (!mounted) return;

    _otpFocusNode.requestFocus();

    SystemChannels.textInput.invokeMethod(
      'TextInput.show',
    );

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
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          const Spacer(),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: AppColors.primaryGreen,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VERIFICATION ICON
  // ============================================================

  Widget _buildVerificationIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            shape: BoxShape.circle,
          ),
        ),

        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    AppColors.primaryGreen.withOpacity(0.20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.phone_android_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),

        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.infoBg,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.primaryGreen,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OTP INPUT
  // ============================================================

  Widget _buildOTPField() {
    return GestureDetector(
      onTap: () {
        _otpFocusNode.requestFocus();

        SystemChannels.textInput.invokeMethod(
          'TextInput.show',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Invisible actual TextField.
            //
            // This preserves SMS autofill and keyboard
            // functionality while the visible UI uses
            // individual OTP boxes.
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: 1,
                height: 1,
                child: TextField(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  autofocus: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  textInputAction: TextInputAction.done,
                  autofillHints: const [
                    AutofillHints.oneTimeCode,
                  ],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  maxLength: 6,
                  onChanged: (value) {
                    setState(() {});

                    if (value.length == 6) {
                      _verifyOTP();
                    }
                  },
                  onSubmitted: (_) {
                    _verifyOTP();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
            ),

            // Visible OTP boxes.
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) {
                  final String value =
                      _otpController.text;

                  final bool hasValue =
                      index < value.length;

                  final bool isActive =
                      index == value.length &&
                      value.length < 6;

                  return AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 180),
                    width: 43,
                    height: 53,
                    decoration: BoxDecoration(
                      color: hasValue
                          ? AppColors.infoBg
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primaryGreen
                            : hasValue
                                ? AppColors.primaryGreen
                                : AppColors.cardBorder,
                        width: isActive || hasValue
                            ? 1.5
                            : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hasValue
                          ? value[index]
                          : '',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryGreen,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Demo mode • OTP: 123456',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VERIFY BUTTON
  // ============================================================

  Widget _buildVerifyButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _isVerifying ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          disabledBackgroundColor: AppColors.mutedText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
                    'Verify & Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 9),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ],
              ),
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
            // ======================================================
            // TOP BAR
            // ======================================================

            _buildTopBar(context),

            // ======================================================
            // CONTENT
            // ======================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // ==================================================
                    // ICON
                    // ==================================================

                    Center(
                      child: _buildVerificationIcon(),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // HEADING
                    // ==================================================

                    const Text(
                      'Verify your mobile number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'We sent a 6-digit verification code\nto your mobile number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: AppColors.mutedText,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // MOBILE NUMBER
                    // ==================================================

                    Center(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone_rounded,
                              size: 15,
                              color:
                                  AppColors.primaryGreen,
                            ),

                            const SizedBox(width: 6),

                            Text(
                              '+91 ${widget.mobileNumber}',
                              style:
                                  const TextStyle(
                                fontSize: 13.5,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // ==================================================
                    // OTP LABEL
                    // ==================================================

                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.infoBg,
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            size: 16,
                            color:
                                AppColors.primaryGreen,
                          ),
                        ),

                        const SizedBox(width: 9),

                        const Text(
                          'VERIFICATION CODE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // OTP INPUT
                    // ==================================================

                    _buildOTPField(),

                    const SizedBox(height: 12),

                    const Text(
                      'The code will be verified automatically when all 6 digits are entered.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.mutedText,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // DEMO CARD
                    // ==================================================

                    _buildDemoOTPCard(),

                    const SizedBox(height: 22),

                    // ==================================================
                    // VERIFY BUTTON
                    // ==================================================

                    _buildVerifyButton(),

                    const SizedBox(height: 19),

                    // ==================================================
                    // RESEND
                    // ==================================================

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  AppColors.mutedText,
                            ),
                          ),

                          const SizedBox(width: 5),

                          InkWell(
                            borderRadius:
                                BorderRadius.circular(5),
                            onTap: _resendOTP,
                            child: const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 3,
                                vertical: 2,
                              ),
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.primaryGreen,
                                  decoration:
                                      TextDecoration
                                          .underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // CHANGE NUMBER
                    // ==================================================

                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 15,
                          color:
                              AppColors.mutedText,
                        ),
                        label: const Text(
                          'Change mobile number',
                          style: TextStyle(
                            fontSize: 12.5,
                            color:
                                AppColors.mutedText,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
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