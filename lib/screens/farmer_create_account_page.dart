import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'farmer_login_page.dart';

// ============================================================
// APP COLORS
// ============================================================

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color darkGreen = Color(0xFF1B4D22);
  static const Color background = Color(0xFFF4FBF4);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color mutedText = Color(0xFF6B7A6D);
  static const Color cardBorder = Color(0xFFDCEEDD);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color infoBg = Color(0xFFE9F6EA);

  static const Color amber = Color(0xFFF4B942);
  static const Color lightAmber = Color(0xFFFFF4D6);

  static const Color alertRed = Color(0xFFD64545);
  static const Color lightRed = Color(0xFFFDECEC);
}

// ============================================================
// FARMER CREATE ACCOUNT PAGE
// ============================================================

class FarmerCreateAccountPage extends StatefulWidget {
  const FarmerCreateAccountPage({super.key});

  @override
  State<FarmerCreateAccountPage> createState() =>
      _FarmerCreateAccountPageState();
}

class _FarmerCreateAccountPageState
    extends State<FarmerCreateAccountPage> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _mobileController =
      TextEditingController();

  final TextEditingController _otpController =
      TextEditingController();

  final TextEditingController _pinController =
      TextEditingController();

  final TextEditingController _confirmPinController =
      TextEditingController();

  // ==========================================================
  // VARIABLES
  // ==========================================================

  bool _accessibilityMode = false;

  bool _otpVerified = false;

  bool _isLoading = false;

  bool _obscurePin = true;

  bool _obscureConfirmPin = true;

  // Demo OTP
  final String demoOTP = '123456';

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();

    super.dispose();
  }

  // ==========================================================
  // GET VERIFICATION CODE
  // ==========================================================

  void _getVerificationCode() {
    final String name =
        _nameController.text.trim();

    final String mobile =
        _mobileController.text.trim();

    // Name validation
    if (name.isEmpty) {
      _showMessage(
        'Please enter your full name',
      );
      return;
    }

    // Mobile validation
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

    setState(() {
      _isLoading = true;
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        _showOTPDialog();
      },
    );
  }

  // ==========================================================
  // OTP DIALOG
  // ==========================================================

  void _showOTPDialog() {
    _otpController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: AppColors.primaryGreen,
              ),
              SizedBox(width: 10),
              Text(
                'Verify Mobile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the 6-digit OTP sent to',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mutedText,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '+91 ${_mobileController.text.trim()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),

              const SizedBox(height: 18),

              // OTP FIELD
              TextField(
                controller: _otpController,
                keyboardType:
                    TextInputType.number,

                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: AppColors.textPrimary,
                ),

                decoration: InputDecoration(
                  counterText: '',
                  hintText: '------',
                  hintStyle: const TextStyle(
                    color: AppColors.mutedText,
                    letterSpacing: 5,
                  ),

                  filled: true,
                  fillColor:
                      AppColors.background,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.cardBorder,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.cardBorder,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.primaryGreen,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // DEMO OTP INFORMATION
              Container(
                padding:
                    const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color:
                          AppColors.primaryGreen,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo OTP: 123456',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.mutedText,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.darkGreen,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Verify',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // VERIFY OTP
  // ==========================================================

  void _verifyOTP() {
    final String enteredOTP =
        _otpController.text.trim();

    if (enteredOTP.isEmpty) {
      _showMessage(
        'Please enter the OTP',
      );
      return;
    }

    if (enteredOTP.length != 6) {
      _showMessage(
        'Please enter the complete 6-digit OTP',
      );
      return;
    }

    if (enteredOTP != demoOTP) {
      _showMessage(
        'Incorrect OTP. Please try again.',
      );
      return;
    }

    Navigator.pop(context);

    setState(() {
      _otpVerified = true;
    });

    _showMessage(
      'Mobile number verified successfully',
    );
  }

  // ==========================================================
  // CREATE ACCOUNT
  // ==========================================================

  void _createAccount() {
    final String pin =
        _pinController.text.trim();

    final String confirmPin =
        _confirmPinController.text.trim();

    // OTP validation
    if (!_otpVerified) {
      _showMessage(
        'Please verify your mobile number first',
      );
      return;
    }

    // PIN validation
    if (pin.isEmpty) {
      _showMessage(
        'Please create your Farmer PIN',
      );
      return;
    }

    // PIN must be 4 to 6 characters
    if (pin.length < 4 || pin.length > 6) {
      _showMessage(
        'PIN must contain 4 to 6 characters',
      );
      return;
    }

    // Confirm PIN
    if (confirmPin.isEmpty) {
      _showMessage(
        'Please confirm your PIN',
      );
      return;
    }

    // PIN matching
    if (pin != confirmPin) {
      _showMessage(
        'PINs do not match',
      );
      return;
    }

    // SUCCESS DIALOG
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              AppColors.cardWhite,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              // SUCCESS ICON
              Container(
                width: 70,
                height: 70,
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.infoBg,
                  shape:
                      BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .check_circle_outline,
                  color:
                      AppColors.primaryGreen,
                  size: 45,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Registration Successful!',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your farmer account has been created successfully.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.mutedText,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width:
                    double.infinity,
                height: 48,
                child:
                    ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const FarmerLoginPage(),
                      ),
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.darkGreen,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                    ),
                  ),

                  child: const Text(
                    'Go to Farmer Login',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
            Text(message),

        backgroundColor:
            AppColors.darkGreen,

        behavior:
            SnackBarBehavior.floating,

        duration:
            const Duration(seconds: 2),
      ),
    );
  }

  // ==========================================================
  // NAME FIELD
  // ==========================================================

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              AppColors.cardBorder,
        ),
      ),

      child: TextField(
        controller:
            _nameController,

        keyboardType:
            TextInputType.name,

        // ONLY LETTERS AND SPACES
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z ]'),
          ),
        ],

        style: const TextStyle(
          fontSize: 14,
          color:
              AppColors.textPrimary,
        ),

        decoration:
            const InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline,
            color:
                AppColors.primaryGreen,
            size: 21,
          ),

          hintText:
              'Enter your full name',

          hintStyle: TextStyle(
            color:
                AppColors.mutedText,
            fontSize: 14,
          ),

          border:
              InputBorder.none,

          contentPadding:
              EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // MOBILE FIELD
  // ==========================================================

  Widget _buildMobileField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              AppColors.cardBorder,
        ),
      ),

      child: Row(
        children: [
          const Padding(
            padding:
                EdgeInsets.only(
              left: 14,
            ),
            child: Icon(
              Icons.phone_outlined,
              color:
                  AppColors.primaryGreen,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            '+91',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textPrimary,
            ),
          ),

          Container(
            height: 25,
            width: 1,
            margin:
                const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            color:
                AppColors.cardBorder,
          ),

          Expanded(
            child: TextField(
              controller:
                  _mobileController,

              keyboardType:
                  TextInputType.phone,

              // NUMBERS ONLY
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
                LengthLimitingTextInputFormatter(
                  10,
                ),
              ],

              style:
                  const TextStyle(
                fontSize: 14,
                color:
                    AppColors.textPrimary,
              ),

              decoration:
                  const InputDecoration(
                hintText:
                    'Enter mobile number',

                hintStyle:
                    TextStyle(
                  color:
                      AppColors.mutedText,
                  fontSize: 14,
                ),

                border:
                    InputBorder.none,

                contentPadding:
                    EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PIN FIELD
  // ==========================================================

  Widget _buildPinField({
    required TextEditingController
        controller,

    required String hintText,

    required bool obscureText,

    required VoidCallback onToggle,
  }) {
    return Container(
      decoration:
          BoxDecoration(
        color:
            AppColors.cardWhite,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              AppColors.cardBorder,
        ),
      ),

      child: TextField(
        controller:
            controller,

        keyboardType:
            TextInputType.text,

        // LETTERS + NUMBERS + SPECIAL CHARACTERS
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(
              r'[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?`~ ]',
            ),
          ),

          LengthLimitingTextInputFormatter(
            6,
          ),
        ],

        obscureText:
            obscureText,

        style:
            const TextStyle(
          fontSize: 16,
          fontWeight:
              FontWeight.w600,
          letterSpacing: 3,
          color:
              AppColors.textPrimary,
        ),

        decoration:
            InputDecoration(
          prefixIcon:
              const Icon(
            Icons.lock_outline,
            color:
                AppColors.primaryGreen,
            size: 21,
          ),

          suffixIcon:
              IconButton(
            onPressed:
                onToggle,

            icon: Icon(
              obscureText
                  ? Icons
                      .visibility_outlined
                  : Icons
                      .visibility_off_outlined,

              color:
                  AppColors.mutedText,

              size: 21,
            ),
          ),

          hintText:
              hintText,

          hintStyle:
              const TextStyle(
            color:
                AppColors.mutedText,
            fontSize: 14,
            letterSpacing: 0,
            fontWeight:
                FontWeight.normal,
          ),

          border:
              InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PIN CONTAINER
  // ==========================================================

  Widget _buildPinContainer() {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            AppColors.cardWhite,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              AppColors.cardBorder,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(0.03),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------------
          // PIN HEADER
          // ----------------------------------------------------

          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.infoBg,
                  shape:
                      BoxShape.circle,
                ),

                child:
                    const Icon(
                  Icons.lock_outline,
                  color:
                      AppColors.primaryGreen,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      'Create Farmer PIN',
                      style:
                          TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors
                                .textPrimary,
                      ),
                    ),

                    SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Use this PIN to securely login',
                      style:
                          TextStyle(
                        fontSize: 12,
                        color:
                            AppColors
                                .mutedText,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.check_circle,
                color:
                    AppColors.primaryGreen,
                size: 22,
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // ----------------------------------------------------
          // FARMER PIN
          // ----------------------------------------------------

          const Text(
            'FARMER PIN',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight:
                  FontWeight.bold,
              color:
                  AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          _buildPinField(
            controller:
                _pinController,

            hintText:
                'Enter 4 to 6 characters',

            obscureText:
                _obscurePin,

            onToggle: () {
              setState(() {
                _obscurePin =
                    !_obscurePin;
              });
            },
          ),

          const SizedBox(
            height: 15,
          ),

          // ----------------------------------------------------
          // CONFIRM PIN
          // ----------------------------------------------------

          const Text(
            'CONFIRM PIN',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight:
                  FontWeight.bold,
              color:
                  AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          _buildPinField(
            controller:
                _confirmPinController,

            hintText:
                'Re-enter your PIN',

            obscureText:
                _obscureConfirmPin,

            onToggle: () {
              setState(() {
                _obscureConfirmPin =
                    !_obscureConfirmPin;
              });
            },
          ),

          const SizedBox(
            height: 14,
          ),

          // ----------------------------------------------------
          // PIN INFORMATION
          // ----------------------------------------------------

          Container(
            padding:
                const EdgeInsets.all(11),

            decoration:
                BoxDecoration(
              color:
                  AppColors.infoBg,

              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),

            child: const Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Icon(
                  Icons.info_outline,
                  color:
                      AppColors
                          .primaryGreen,
                  size: 18,
                ),

                SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: Text(
                    'Your PIN can contain letters, numbers and special characters. Use 4 to 6 characters.',
                    style:
                        TextStyle(
                      fontSize: 11.5,
                      color:
                          AppColors
                              .mutedText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // ----------------------------------------------------
          // CREATE ACCOUNT BUTTON
          // ----------------------------------------------------

          SizedBox(
            width:
                double.infinity,

            height: 52,

            child:
                ElevatedButton(
              onPressed:
                  _createAccount,

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors
                        .darkGreen,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
              ),

              child:
                  const Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [
                  Text(
                    'Create Farmer Account',
                    style:
                        TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
      ),

      child: Row(
        children: [
          const Icon(
            Icons.eco,
            color:
                AppColors.primaryGreen,
            size: 27,
          ),

          const SizedBox(
            width: 8,
          ),

          const Expanded(
            child: Text(
              'Krishi Unnati',
              style:
                  TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    AppColors.darkGreen,
              ),
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.accessibility_new,
                color:
                    AppColors.mutedText,
                size: 19,
              ),

              const SizedBox(
                width: 4,
              ),

              Switch(
                value:
                    _accessibilityMode,

                activeColor:
                    AppColors
                        .primaryGreen,

                onChanged:
                    (value) {
                  setState(() {
                    _accessibilityMode =
                        value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  20,
                  20,
                  20,
                  35,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,

                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================

                    const Text(
                      'Create your account',
                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        fontSize: 23,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppColors
                                .textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    const Text(
                      'Join Krishi Unnati and access smart farming services',
                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        fontSize: 13,
                        color:
                            AppColors
                                .mutedText,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    // ==================================================
                    // PERSONAL INFORMATION
                    // ==================================================

                    const Row(
                      children: [
                        Icon(
                          Icons
                              .person_outline,
                          size: 17,
                          color:
                              AppColors
                                  .primaryGreen,
                        ),

                        SizedBox(
                          width: 7,
                        ),

                        Text(
                          'PERSONAL INFORMATION',
                          style:
                              TextStyle(
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                AppColors
                                    .textPrimary,
                            letterSpacing:
                                0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    // NAME
                    _buildNameField(),

                    const SizedBox(
                      height: 15,
                    ),

                    // MOBILE
                    _buildMobileField(),

                    const SizedBox(
                      height: 20,
                    ),

                    // ==================================================
                    // GET VERIFICATION CODE
                    // ==================================================

                    if (!_otpVerified)
                      SizedBox(
                        height: 52,

                        child:
                            ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : _getVerificationCode,

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColors
                                    .darkGreen,

                            disabledBackgroundColor:
                                AppColors
                                    .mutedText,

                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,

                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2.5,

                                    valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(
                                      Colors
                                          .white,
                                    ),
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [
                                    Icon(
                                      Icons
                                          .sms_outlined,
                                      color:
                                          Colors
                                              .white,
                                      size: 19,
                                    ),

                                    SizedBox(
                                      width: 8,
                                    ),

                                    Text(
                                      'Get Verification Code',
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,
                                        fontSize:
                                            15,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                    // ==================================================
                    // VERIFIED STATUS + PIN
                    // ==================================================

                    if (_otpVerified) ...[
                      Container(
                        padding:
                            const EdgeInsets
                                .all(
                          13,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              AppColors
                                  .infoBg,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),

                          border:
                              Border.all(
                            color:
                                AppColors
                                    .cardBorder,
                          ),
                        ),

                        child:
                            const Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle,
                              color:
                                  AppColors
                                      .primaryGreen,
                              size: 22,
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child:
                                  Text(
                                'Mobile number verified successfully',
                                style:
                                    TextStyle(
                                  fontSize:
                                      13,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      AppColors
                                          .textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // PIN CONTAINER
                      _buildPinContainer(),
                    ],

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // LOGIN
                    // ==================================================

                    Center(
                      child: Row(
                        mainAxisSize:
                            MainAxisSize
                                .min,

                        children: [
                          const Text(
                            'Already have an account? ',

                            style:
                                TextStyle(
                              fontSize: 13.5,
                              color:
                                  AppColors
                                      .textPrimary,
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const FarmerLoginPage(),
                                ),
                              );
                            },

                            child:
                                const Text(
                              'Farmer Login',

                              style:
                                  TextStyle(
                                fontSize:
                                    13.5,
                                color:
                                    AppColors
                                        .primaryGreen,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                decoration:
                                    TextDecoration
                                        .underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // SECURITY INFORMATION
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets
                              .all(
                        14,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            AppColors
                                .cardWhite,

                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),

                        border:
                            Border.all(
                          color:
                              AppColors
                                  .cardBorder,
                        ),
                      ),

                      child:
                          const Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Icon(
                            Icons
                                .security_outlined,
                            color:
                                AppColors
                                    .primaryGreen,
                            size: 21,
                          ),

                          SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child:
                                Text(
                              'Your personal information and Farmer PIN are kept secure.',
                              style:
                                  TextStyle(
                                fontSize:
                                    12.5,
                                color:
                                    AppColors
                                        .mutedText,
                                height:
                                    1.4,
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