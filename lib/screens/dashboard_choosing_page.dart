import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'farmer_dashboard.dart';
import 'admin_dashboard.dart';
// import 'extension_officer_dashboard.dart';

class DashboardChoosingPage extends StatefulWidget {
  const DashboardChoosingPage({super.key});

  @override
  State<DashboardChoosingPage> createState() =>
      _DashboardChoosingPageState();
}

class _DashboardChoosingPageState extends State<DashboardChoosingPage> {
  String selectedLanguage = 'English';

  // =========================================================================
  // THEME COLORS
  // =========================================================================

  static const Color primaryGreen = Color(0xFF3F713F);
  static const Color iconGreen = Color(0xFF00966C);
  static const Color darkNavy = Color(0xFF17233D);
  static const Color lightGreen = Color(0xFFF4F8F2);
  static const Color borderGreen = Color(0xFFD0DCCF);
  static const Color footerGreen = Color(0xFFF5F7F4);

  // =========================================================================
  // CLOSE APP
  // =========================================================================

  void _closeApp() {
    SystemNavigator.pop();
  }

  // =========================================================================
  // OPEN FARMER DASHBOARD
  // =========================================================================

  void _openFarmerDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  // =========================================================================
  // OPEN ADMIN DASHBOARD
  // =========================================================================

  void _openAdminDashboard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdminDashboard(),
      ),
    );
  }

  // =========================================================================
  // OPEN EXTENSION OFFICER DASHBOARD
  // =========================================================================

  // void _openExtensionOfficerDashboard() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => const ExtensionOfficerDashboard(),
  //     ),
  //   );
  // }

  // =========================================================================
  // MAIN BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ==============================================================
              // TOP BAR
              // ==============================================================

              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 20,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    // --------------------------------------------------------
                    // BACK / CLOSE BUTTON
                    // --------------------------------------------------------

                    IconButton(
                      onPressed: _closeApp,
                      tooltip: 'Exit',
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 29,
                        color: darkNavy,
                      ),
                    ),

                    // --------------------------------------------------------
                    // LOGO
                    // --------------------------------------------------------

                    Expanded(
                      child: _buildKrishiUnnatiLogo(),
                    ),

                    // Keeps logo visually centered
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ==============================================================
              // MAIN CONTENT
              // ==============================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --------------------------------------------------------
                    // CHOOSE LANGUAGE
                    // --------------------------------------------------------

                    _buildLanguageSection(),

                    const SizedBox(height: 34),

                    // --------------------------------------------------------
                    // GET STARTED
                    // --------------------------------------------------------

                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: darkNavy,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Select your role :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555B68),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // --------------------------------------------------------
                    // FARMER PORTAL
                    // --------------------------------------------------------

                    _buildRoleCard(
                      title: 'Farmer Portal',
                      type: RoleType.farmer,
                      onTap: _openFarmerDashboard,
                    ),

                    const SizedBox(height: 14),

                    // --------------------------------------------------------
                    // GOVT ADMIN
                    // --------------------------------------------------------

                    _buildRoleCard(
                      title: 'Govt. Admin',
                      type: RoleType.admin,
                      onTap: _openAdminDashboard,
                    ),

                    const SizedBox(height: 14),

                    // --------------------------------------------------------
                    // EXTENSION OFFICER
                    // --------------------------------------------------------

                    // _buildRoleCard(
                    //   title: 'Extension Officer',
                    //   type: RoleType.officer,
                    //   onTap: _openExtensionOfficerDashboard,
                    // ),

                    const SizedBox(height: 30),

                    // --------------------------------------------------------
                    // HELP WITH REGISTRATION
                    // --------------------------------------------------------

                    _buildHelpSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // ==============================================================
              // FOOTER
              // ==============================================================

              _buildFooter(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // KRISHI UNNATI LOGO
  // =========================================================================

  Widget _buildKrishiUnnatiLogo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leaf logo
          Container(
            width: 43,
            height: 43,
            decoration: const BoxDecoration(
              color: primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.eco_rounded,
                  color: Colors.white,
                  size: 27,
                ),
                Positioned(
                  bottom: 7,
                  child: Container(
                    width: 18,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // KRISHI UNNATI
          const Text(
            'KRISHI UNNATI',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
              color: darkNavy,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LANGUAGE SECTION
  // =========================================================================

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 32,
              color: darkNavy,
            ),

            const SizedBox(width: 7),

            const Text(
              'CHOOSE LANGUAGE',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: darkNavy,
                letterSpacing: 0.1,
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              Icons.translate_rounded,
              size: 23,
              color: Colors.grey.shade700,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Dropdown box
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderGreen,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              borderRadius: BorderRadius.circular(14),
              icon: const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primaryGreen,
                  size: 27,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              style: const TextStyle(
                color: darkNavy,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'English',
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: primaryGreen,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Text('English'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Hindi',
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: primaryGreen,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Text('हिन्दी'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Marathi',
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: primaryGreen,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Text('मराठी'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLanguage = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // ROLE CARD
  // =========================================================================

  Widget _buildRoleCard({
    required String title,
    required RoleType type,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: type == RoleType.farmer
                  ? borderGreen
                  : const Color(0xFFD2D9E2),
              width: 1.7,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ICON AREA
              SizedBox(
                width: 124,
                height: double.infinity,
                child: Center(
                  child: _buildRoleIcon(type),
                ),
              ),

              // VERTICAL DIVIDER
              Container(
                width: 1,
                height: 74,
                color: const Color(0xFFE1E5E1),
              ),

              // TEXT AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 17,
                    right: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Small badge
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: type == RoleType.farmer
                              ? const Color(0xFFE7F0E4)
                              : const Color(0xFFE9EDF3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          type == RoleType.farmer
                              ? Icons.spa_rounded
                              : Icons.verified_user_outlined,
                          size: 14,
                          color: type == RoleType.farmer
                              ? primaryGreen
                              : const Color(0xFF244B78),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: darkNavy,
                          height: 1.05,
                        ),
                      ),

                      const SizedBox(height: 7),

                      // Continue
                      Row(
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: type == RoleType.farmer
                                  ? primaryGreen
                                  : const Color(0xFF244B78),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: type == RoleType.farmer
                                ? primaryGreen
                                : const Color(0xFF244B78),
                          ),
                        ],
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

  // =========================================================================
  // ROLE ICONS
  // =========================================================================

  Widget _buildRoleIcon(RoleType type) {
    switch (type) {
      case RoleType.farmer:
        return SizedBox(
          width: 92,
          height: 92,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F7EF),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              // Farmer
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hat
                  Container(
                    width: 34,
                    height: 8,
                    decoration: BoxDecoration(
                      color: iconGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Head
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: iconGreen,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Body
                  Container(
                    width: 42,
                    height: 27,
                    decoration: BoxDecoration(
                      color: iconGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Small plant
              Positioned(
                right: 8,
                top: 19,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: iconGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: iconGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 8,
                          height: 15,
                          decoration: BoxDecoration(
                            color: iconGreen,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 3,
                      height: 25,
                      color: iconGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case RoleType.admin:
        return _buildPersonLockIcon();

      case RoleType.officer:
        return _buildPersonLockIcon();
    }
  }

  // =========================================================================
  // PERSON + LOCK ICON
  // =========================================================================

  Widget _buildPersonLockIcon() {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Person
          Positioned(
            left: 11,
            top: 15,
            child: Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: iconGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Body
          Positioned(
            left: 6,
            bottom: 10,
            child: Container(
              width: 48,
              height: 35,
              decoration: BoxDecoration(
                color: iconGreen,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          // Lock
          Positioned(
            right: 8,
            bottom: 13,
            child: Container(
              width: 30,
              height: 28,
              decoration: BoxDecoration(
                color: iconGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Container(
                  width: 15,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),

          // Lock shackle
          Positioned(
            right: 13,
            bottom: 37,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: iconGreen,
                  width: 6,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // HELP SECTION
  // =========================================================================

  Widget _buildHelpSection() {
    return InkWell(
      onTap: () {
        // TODO: registration help page
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Need help with registration?',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: darkNavy,
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              Icons.arrow_forward_rounded,
              size: 21,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // FOOTER
  // =========================================================================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        color: footerGreen,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE0E5DE),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'KRISHI UNNATI V1.0.1',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: Color(0xFF666B72),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            '© 2026 Krishi Unnati. This is a government-initiative platform.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF777C82),
            ),
          ),
        ],
      ),
    );
  }
}



// =========================================================================
// ROLE TYPE
// =========================================================================

enum RoleType {
  farmer,
  admin,
  officer,
}