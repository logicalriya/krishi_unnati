import 'package:flutter/material.dart';

import '../state/app_locale.dart';
import '../screens/farmers/farmer_create_account_page.dart';

class RegistrationHelpPage extends StatefulWidget {
  const RegistrationHelpPage({super.key});

  @override
  State<RegistrationHelpPage> createState() => _RegistrationHelpPageState();
}

class _RegistrationHelpPageState extends State<RegistrationHelpPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  static const _green = Color(0xFF3F713F);
  static const _darkNavy = Color(0xFF17233D);
  static const _softGreen = Color(0xFFF4F8F2);
  static const _border = Color(0xFFD0DCCF);

  final List<_RegistrationStep> _steps = const [
    _RegistrationStep(
      icon: Icons.person_add_alt_1_rounded,
      color: Color(0xFF3F713F),
      titleKey: 'registrationStepOneTitle',
      descriptionKey: 'registrationStepOneDescription',
    ),
    _RegistrationStep(
      icon: Icons.phone_android_rounded,
      color: Color(0xFF167A48),
      titleKey: 'registrationStepTwoTitle',
      descriptionKey: 'registrationStepTwoDescription',
    ),
    _RegistrationStep(
      icon: Icons.verified_user_rounded,
      color: Color(0xFF244B78),
      titleKey: 'registrationStepThreeTitle',
      descriptionKey: 'registrationStepThreeDescription',
    ),
    _RegistrationStep(
      icon: Icons.login_rounded,
      color: Color(0xFF9A6318),
      titleKey: 'registrationStepFourTitle',
      descriptionKey: 'registrationStepFourDescription',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocale.of(context).t;
    final step = _steps[_currentStep];

    return Scaffold(
      backgroundColor: _softGreen,
      appBar: AppBar(
        backgroundColor: _softGreen,
        foregroundColor: _darkNavy,
        elevation: 0,
        title: Text(
          t('registrationHelpTitle'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                itemBuilder: (context, index) {
                  final item = _steps[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                    child: Column(
                      children: [
                        _StepIllustration(step: index + 1, item: item),
                        const SizedBox(height: 28),
                        Text(
                          t(item.titleKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _darkNavy,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t(item.descriptionKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF596271),
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _currentStep ? 25 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentStep
                              ? step.color
                              : _border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      IconButton(
                        tooltip: t('previousStep'),
                        onPressed: _currentStep == 0
                            ? null
                            : () => _goToStep(_currentStep - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _currentStep == _steps.length - 1
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FarmerCreateAccountPage(),
                                    ),
                                  );
                                }
                              : () => _goToStep(_currentStep + 1),
                          icon: Icon(
                            _currentStep == _steps.length - 1
                                ? Icons.person_add_alt_1_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          label: Text(
                            t(_currentStep == _steps.length - 1
                                ? 'startRegistration'
                                : 'nextStep'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: step.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrationStep {
  final IconData icon;
  final Color color;
  final String titleKey;
  final String descriptionKey;

  const _RegistrationStep({
    required this.icon,
    required this.color,
    required this.titleKey,
    required this.descriptionKey,
  });
}

class _StepIllustration extends StatelessWidget {
  final int step;
  final _RegistrationStep item;

  const _StepIllustration({required this.step, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD0DCCF)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 24,
            right: 25,
            child: Text(
              '0$step',
              style: TextStyle(
                color: item.color.withOpacity(0.12),
                fontSize: 72,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            width: 142,
            height: 142,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 76, color: item.color),
          ),
          Positioned(
            bottom: 24,
            child: Row(
              children: [
                Icon(Icons.arrow_forward_rounded, color: item.color, size: 19),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, color: item.color.withOpacity(0.45), size: 19),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, color: item.color.withOpacity(0.2), size: 19),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
