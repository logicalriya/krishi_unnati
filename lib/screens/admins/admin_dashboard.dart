import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  static const Color primaryGreen = Color(0xFF00A84F);
  static const Color darkGreen = Color(0xFF008F45);
  static const Color lightGreen = Color(0xFFE8FFF0);
  static const Color background = Color(0xFFF4FFF7);
  static const Color darkText = Color(0xFF303438);
  static const Color greyText = Color(0xFF777D80);
  static const Color cardColor = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildSearchBar(),
                    _buildSyncStatus(),
                    _buildStats(),
                    _buildSectionTabs(),
                    _buildHotspotSection(),
                    _buildAlertsSection(),
                    _buildValidationSection(),
                    _buildActionCards(),
                    _buildReferrals(),
                    _buildFarmerConnect(),
                    _buildInventory(),
                    _buildGovernance(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 15),
      decoration: const BoxDecoration(
        color: cardColor,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDCEFE2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "KRISHI UNNATI",
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
              ),
              const Icon(
                Icons.notifications_none_rounded,
                color: darkText,
                size: 25,
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Expanded(
                child: Text(
                  "Government Dashboard",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB8E9C9),
                  ),
                ),
                child: const Text(
                  "LOGIN ID: #786",
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            children: [
              const Icon(
                Icons.spa_outlined,
                color: primaryGreen,
                size: 15,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "KRISHI UNNATI",
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FFF0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 10,
                      color: primaryGreen,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "SECURE • ENCRYPTED",
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD8E4DC),
                ),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search farmers, regions, or alerts...",
                  hintStyle: TextStyle(
                    color: Color(0xFF92999B),
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF8C9590),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),

          const SizedBox(width: 9),

          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD8E4DC),
              ),
            ),
            child: const Icon(
              Icons.filter_alt_outlined,
              size: 20,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SYNC
  // ------------------------------------------------------------

  Widget _buildSyncStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 5,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi,
            color: primaryGreen,
            size: 13,
          ),
          const SizedBox(width: 5),
          const Text(
            "Real-time Sync Active",
            style: TextStyle(
              color: greyText,
              fontSize: 9,
            ),
          ),

          const Spacer(),

          Text(
            "Last updated: 14:32:10",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATISTICS
  // ------------------------------------------------------------

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              icon: Icons.people_outline,
              iconColor: primaryGreen,
              title: "ACTIVE FARMERS",
              value: "1,284",
              change: "↗ +12%",
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _statCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.redAccent,
              title: "CRITICAL ALERTS",
              value: "42",
              change: "↘ -5%",
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: _statCard(
              icon: Icons.map_outlined,
              iconColor: Colors.amber,
              title: "PEST HOTSPOTS",
              value: "8",
              change: "↘ +2",
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
  }) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 15,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: greyText,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              Text(
                change,
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TABS
  // ------------------------------------------------------------

  Widget _buildSectionTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFE5F8EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "OPERATIONAL OVERVIEW",
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const Expanded(
              child: Center(
                child: Text(
                  "AI & MODEL METRICS",
                  style: TextStyle(
                    color: greyText,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HOTSPOT MAP
  // ------------------------------------------------------------

  Widget _buildHotspotSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.map_outlined,
                color: Colors.amber,
                size: 19,
              ),
              const SizedBox(width: 9),

              const Expanded(
                child: Text(
                  "Disease Hotspot Map",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "LIVE MAP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            height: 210,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                // Map-like background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF14BCD0),
                        Color(0xFF087DB8),
                        Color(0xFF244FBB),
                        Color(0xFF7350B9),
                      ],
                    ),
                  ),
                ),

                // Heat spots
                Positioned(
                  top: 35,
                  left: 135,
                  child: _heatSpot(
                    width: 120,
                    height: 80,
                    color: Colors.redAccent,
                  ),
                ),

                Positioned(
                  top: 95,
                  left: 65,
                  child: _heatSpot(
                    width: 80,
                    height: 65,
                    color: Colors.deepPurple,
                  ),
                ),

                Positioned(
                  bottom: 5,
                  right: 30,
                  child: _heatSpot(
                    width: 95,
                    height: 70,
                    color: Colors.orange,
                  ),
                ),

                // Map lines
                CustomPaint(
                  size: const Size(double.infinity, 210),
                  painter: MapLinesPainter(),
                ),

                Positioned(
                  right: 10,
                  bottom: 10,
                  child: _riskLegend(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heatSpot({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: RadialGradient(
          colors: [
            color.withOpacity(.85),
            color.withOpacity(.4),
            color.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _riskLegend() {
    return Container(
      width: 95,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Risk Legend",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          SizedBox(height: 6),
          _LegendItem(
            color: Colors.redAccent,
            text: "Critical (≥5)",
          ),
          _LegendItem(
            color: Colors.orange,
            text: "High Risk",
          ),
          _LegendItem(
            color: Color(0xFF6BD29B),
            text: "Stable Area",
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ALERTS
  // ------------------------------------------------------------

  Widget _buildAlertsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_none,
                color: Colors.redAccent,
                size: 19,
              ),

              const SizedBox(width: 9),

              const Expanded(
                child: Text(
                  "Critical Alerts Feed",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Text(
                "View Archive",
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _alertItem(
                  "Fall Armyworm",
                  "North District",
                  "10m ago",
                  "12 reports",
                  "High",
                  Colors.green,
                ),

                _alertItem(
                  "Locust Swarm",
                  "East Valley",
                  "45m ago",
                  "85 reports",
                  "Critical",
                  Colors.redAccent,
                ),

                _alertItem(
                  "Maize Lethal Necrosis",
                  "Southern Plains",
                  "2h ago",
                  "4 reports",
                  "Medium",
                  Colors.green,
                  last: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertItem(
    String title,
    String region,
    String time,
    String reports,
    String severity,
    Color severityColor, {
    bool last = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFE4E8E6),
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: severityColor.withOpacity(.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        severity,
                        style: TextStyle(
                          color: severityColor,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "$region • $time • ↗ $reports",
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 18,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // VALIDATION
  // ------------------------------------------------------------

  Widget _buildValidationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 0, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: primaryGreen,
                  size: 19,
                ),

                const SizedBox(width: 9),

                const Expanded(
                  child: Text(
                    "Validation Queue",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 14,
                  ),
                ),

                const SizedBox(width: 5),

                const Text(
                  "EXPERT POOL",
                  style: TextStyle(
                    color: greyText,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 202,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _validationCard(
                  farmer: "John Mehra",
                  location: "District A • Solan",
                  confidence: "89% AI Match",
                  disease: "Potential Yellow Rust",
                  date: "Oct 14, 14:20",
                  color: Colors.amber,
                ),

                const SizedBox(width: 10),

                _validationCard(
                  farmer: "Sarah Khan",
                  location: "District B • Punjab",
                  confidence: "92% AI Match",
                  disease: "Leaf Spot",
                  date: "Oct 24, 10:20",
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _validationCard({
    required String farmer,
    required String location,
    required String confidence,
    required String disease,
    required String date,
    required Color color,
  }) {
    return Container(
      width: 235,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 91,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade800,
                  Colors.lightGreen.shade300,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: LeafPainter(),
                  ),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      confidence,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      disease,
                      style: const TextStyle(
                        color: darkText,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 7),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "▣ $location",
                        style: const TextStyle(
                          color: greyText,
                          fontSize: 7,
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          color: greyText,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.verified_user_outlined,
                  color: primaryGreen,
                  size: 17,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: _smallButton(
                    "Validate",
                    primaryGreen,
                    Colors.white,
                  ),
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: _smallButton(
                    "Reject",
                    Colors.redAccent,
                    Colors.redAccent.withOpacity(.05),
                    border: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(
    String text,
    Color color,
    Color background, {
    bool border = false,
  }) {
    return Container(
      height: 29,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: border
            ? Border.all(
                color: color,
              )
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: border ? color : Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTION CARDS
  // ------------------------------------------------------------

  Widget _buildActionCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
      child: Row(
        children: [
          Expanded(
            child: _actionCard(
              Icons.medical_services_outlined,
              "Disease Control Rec",
              "Manage protocols & advice",
              primaryGreen,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _actionCard(
              Icons.water_drop_outlined,
              "Soil Health Card",
              "Nutrient reports by region",
              Colors.amber.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 7),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkText,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: greyText,
              fontSize: 7,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // REFERRALS
  // ------------------------------------------------------------

  Widget _buildReferrals() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFE9FFF0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFB9EBC9),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monitor_heart_outlined,
                  color: primaryGreen,
                  size: 19,
                ),

                const SizedBox(width: 9),

                const Text(
                  "Active Referrals",
                  style: TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _referralItem(
              "V-2894: Potato Late Blight",
              "Assigned to Regional Lab B",
              "PENDING",
            ),

            const SizedBox(height: 7),

            _referralItem(
              "V-2882: Soil Acidification",
              "Closed: Oct 23, 10:15",
              "RESOLVED",
            ),
          ],
        ),
      ),
    );
  }

  Widget _referralItem(
    String title,
    String subtitle,
    String status,
  ) {
    final bool pending = status == "PENDING";

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFC7EBD2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: pending
                  ? const Color(0xFFC7F3D5)
                  : const Color(0xFFE5E8E7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: pending ? primaryGreen : greyText,
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FARMER CONNECT
  // ------------------------------------------------------------

  Widget _buildFarmerConnect() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 31,
              width: 31,
              decoration: const BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 16,
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Farmer Connect",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Grievance & Direct Support",
                    style: TextStyle(
                      color: greyText,
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "12 NEW",
                style: TextStyle(
                  color: Color(0xFF806600),
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // INVENTORY
  // ------------------------------------------------------------

  Widget _buildInventory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF202326),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryGreen,
                ),
              ),
              child: const Text(
                "REMEDY MARKETPLACE",
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Inventory Oversight",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Monitor stock levels of approved pesticides & remedies\nin district hubs.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 8,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Manage Supplies   ↗",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // GOVERNANCE
  // ------------------------------------------------------------

  Widget _buildGovernance() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFE1FFE9),
        border: Border(
          top: BorderSide(
            color: Color(0xFFC8EED3),
          ),
          bottom: BorderSide(
            color: Color(0xFFC8EED3),
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFCFF6D9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: primaryGreen,
              size: 21,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Krishi Unnati Governance Shell",
            style: TextStyle(
              color: darkText,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            "Authorized Access Only • User: Admin_786",
            style: TextStyle(
              color: greyText,
              fontSize: 7,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _governanceChip(
                Icons.wifi,
                "SYNCED",
              ),
              const SizedBox(width: 7),
              _governanceChip(
                Icons.lock_outline,
                "AES-256",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _governanceChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 8,
            color: greyText,
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              color: greyText,
              fontSize: 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomItem(
            Icons.grid_view_rounded,
            "Dashboard",
            true,
          ),

          _bottomItem(
            Icons.map_outlined,
            "Hotspots",
            false,
          ),

          _bottomItem(
            Icons.notifications_none,
            "Alerts",
            false,
          ),

          _bottomItem(
            Icons.assignment_outlined,
            "Cases",
            false,
          ),

          _bottomItem(
            Icons.bar_chart_outlined,
            "Impact",
            false,
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String label,
    bool active,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: active ? primaryGreen : greyText,
        ),

        const SizedBox(height: 3),

        Text(
          label,
          style: TextStyle(
            color: active ? primaryGreen : greyText,
            fontSize: 7,
            fontWeight:
                active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// LEGEND ITEM
// ============================================================

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF666B6D),
              fontSize: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAP PAINTER
// ============================================================

class MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 8; i++) {
      final path = Path();

      path.moveTo(
        0,
        i * 30.0,
      );

      path.quadraticBezierTo(
        size.width * .3,
        i * 30.0 + 25,
        size.width * .55,
        i * 30.0 - 5,
      );

      path.quadraticBezierTo(
        size.width * .75,
        i * 30.0 - 25,
        size.width,
        i * 30.0 + 15,
      );

      canvas.drawPath(path, paint);
    }

    for (int i = 0; i < 6; i++) {
      final path = Path();

      path.moveTo(
        i * 65.0,
        0,
      );

      path.quadraticBezierTo(
        i * 65.0 + 20,
        size.height * .4,
        i * 65.0 - 5,
        size.height,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================
// LEAF PAINTER
// ============================================================

class LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final path = Path();

      path.moveTo(
        20 + i * 45,
        size.height,
      );

      path.quadraticBezierTo(
        45 + i * 45,
        size.height * .35,
        35 + i * 45,
        0,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}