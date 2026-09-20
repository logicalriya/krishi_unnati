import 'package:flutter/material.dart';

class FertilizersPage extends StatefulWidget {
  const FertilizersPage({super.key});

  @override
  State<FertilizersPage> createState() =>
      _FertilizersPageState();
}

class _FertilizersPageState extends State<FertilizersPage> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kPrimaryGreen = Color(0xFF1B5E20);
  static const Color kSoftGreen = Color(0xFFE8F5E9);
  static const Color kPaleGreen = Color(0xFFF4FAF4);
  static const Color kTextDark = Color(0xFF263238);
  static const Color kTextGrey = Color(0xFF607D8B);
  static const Color kAmber = Color(0xFFF9A825);
  static const Color kSoftAmber = Color(0xFFFFF8E1);

  String selectedCategory = 'All';
  String searchQuery = '';
  bool lowToHigh = true;

  final TextEditingController searchController =
      TextEditingController();

  final List<String> categories = [
    'All',
    'Chemical Fertilizers',
    'Organic & Bio',
    'Micronutrients',
    'Crop Protection',
  ];

  // Frontend demo data.
  // Replace this list with API/database data later.
  final List<Map<String, dynamic>> products = [
    // -----------------------------------------------------
    // CHEMICAL FERTILIZERS
    // -----------------------------------------------------
    {
      'id': 'fert_001',
      'name': 'Urea',
      'category': 'Chemical Fertilizers',
      'description': 'Nitrogen fertilizer',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Agri Store',
          'price': 270.0,
          'distance': 1.4,
          'phone': '+91 9876543001',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 285.0,
          'distance': 2.7,
          'phone': '+91 9876543002',
        },
      ],
    },
    {
      'id': 'fert_002',
      'name': 'DAP',
      'category': 'Chemical Fertilizers',
      'description': 'Diammonium Phosphate',
      'image': '',
      'icon': Icons.eco,
      'warning': false,
      'sellers': [
        {
          'shop': 'Green Farm Centre',
          'price': 1350.0,
          'distance': 1.8,
          'phone': '+91 9876543003',
        },
        {
          'shop': 'Village Agriculture Store',
          'price': 1390.0,
          'distance': 3.2,
          'phone': '+91 9876543004',
        },
      ],
    },
    {
      'id': 'fert_003',
      'name': 'NPK 10:26:26',
      'category': 'Chemical Fertilizers',
      'description': 'NPK complex fertilizer',
      'image': '',
      'icon': Icons.local_florist,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 1450.0,
          'distance': 2.2,
          'phone': '+91 9876543005',
        },
        {
          'shop': 'Local Agri Store',
          'price': 1490.0,
          'distance': 3.8,
          'phone': '+91 9876543006',
        },
      ],
    },
    {
      'id': 'fert_004',
      'name': 'NPK 12:32:16',
      'category': 'Chemical Fertilizers',
      'description': 'NPK complex fertilizer',
      'image': '',
      'icon': Icons.local_florist,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 1500.0,
          'distance': 1.9,
          'phone': '+91 9876543007',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 1540.0,
          'distance': 4.1,
          'phone': '+91 9876543008',
        },
      ],
    },
    {
      'id': 'fert_005',
      'name': 'NPK 19:19:19',
      'category': 'Chemical Fertilizers',
      'description': 'Balanced NPK fertilizer',
      'image': '',
      'icon': Icons.spa,
      'warning': false,
      'sellers': [
        {
          'shop': 'Village Agriculture Store',
          'price': 1700.0,
          'distance': 2.0,
          'phone': '+91 9876543009',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 1750.0,
          'distance': 3.5,
          'phone': '+91 9876543010',
        },
      ],
    },
    {
      'id': 'fert_006',
      'name': 'MOP',
      'category': 'Chemical Fertilizers',
      'description': 'Muriate of Potash / Potassium Chloride',
      'image': '',
      'icon': Icons.agriculture,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Agri Store',
          'price': 850.0,
          'distance': 1.5,
          'phone': '+91 9876543011',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 890.0,
          'distance': 2.9,
          'phone': '+91 9876543012',
        },
      ],
    },
    {
      'id': 'fert_007',
      'name': 'SSP',
      'category': 'Chemical Fertilizers',
      'description': 'Single Super Phosphate',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 500.0,
          'distance': 1.7,
          'phone': '+91 9876543013',
        },
        {
          'shop': 'Village Agriculture Store',
          'price': 530.0,
          'distance': 3.0,
          'phone': '+91 9876543014',
        },
      ],
    },
    {
      'id': 'fert_008',
      'name': 'Ammonium Sulphate',
      'category': 'Chemical Fertilizers',
      'description': 'Nitrogen and sulphur fertilizer',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Green Farm Centre',
          'price': 650.0,
          'distance': 2.1,
          'phone': '+91 9876543015',
        },
        {
          'shop': 'Local Agri Store',
          'price': 690.0,
          'distance': 3.7,
          'phone': '+91 9876543016',
        },
      ],
    },
    {
      'id': 'fert_009',
      'name': 'Calcium Ammonium Nitrate',
      'category': 'Chemical Fertilizers',
      'description': 'CAN fertilizer',
      'image': '',
      'icon': Icons.science,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 900.0,
          'distance': 2.3,
          'phone': '+91 9876543017',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 930.0,
          'distance': 4.0,
          'phone': '+91 9876543018',
        },
      ],
    },
    {
      'id': 'fert_010',
      'name': 'Potassium Nitrate 13:0:45',
      'category': 'Chemical Fertilizers',
      'description': 'Potassium nitrate',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Green Farm Centre',
          'price': 2200.0,
          'distance': 2.5,
          'phone': '+91 9876543019',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 2280.0,
          'distance': 4.2,
          'phone': '+91 9876543020',
        },
      ],
    },
    {
      'id': 'fert_011',
      'name': 'Monopotassium Phosphate 0:52:34',
      'category': 'Chemical Fertilizers',
      'description': 'MKP fertilizer',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Agri Store',
          'price': 2400.0,
          'distance': 1.9,
          'phone': '+91 9876543021',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 2480.0,
          'distance': 3.9,
          'phone': '+91 9876543022',
        },
      ],
    },

    // -----------------------------------------------------
    // ORGANIC & BIO
    // -----------------------------------------------------
    {
      'id': 'fert_012',
      'name': 'Vermicompost',
      'category': 'Organic & Bio',
      'description': 'Organic soil amendment',
      'image': '',
      'icon': Icons.compost,
      'warning': false,
      'sellers': [
        {
          'shop': 'Organic Farm Store',
          'price': 300.0,
          'distance': 1.3,
          'phone': '+91 9876543023',
        },
        {
          'shop': 'Village Agriculture Store',
          'price': 350.0,
          'distance': 2.8,
          'phone': '+91 9876543024',
        },
      ],
    },
    {
      'id': 'fert_013',
      'name': 'Farmyard Manure',
      'category': 'Organic & Bio',
      'description': 'FYM / Cow dung manure',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Organic Farm',
          'price': 200.0,
          'distance': 1.1,
          'phone': '+91 9876543025',
        },
        {
          'shop': 'Organic Farm Store',
          'price': 250.0,
          'distance': 3.0,
          'phone': '+91 9876543026',
        },
      ],
    },
    {
      'id': 'fert_014',
      'name': 'Neem Cake',
      'category': 'Organic & Bio',
      'description': 'Organic soil amendment',
      'image': '',
      'icon': Icons.eco,
      'warning': false,
      'sellers': [
        {
          'shop': 'Organic Farm Store',
          'price': 450.0,
          'distance': 1.6,
          'phone': '+91 9876543027',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 490.0,
          'distance': 3.3,
          'phone': '+91 9876543028',
        },
      ],
    },
    {
      'id': 'fert_015',
      'name': 'Mustard Cake',
      'category': 'Organic & Bio',
      'description': 'Organic manure',
      'image': '',
      'icon': Icons.eco,
      'warning': false,
      'sellers': [
        {
          'shop': 'Organic Farm Store',
          'price': 500.0,
          'distance': 1.8,
          'phone': '+91 9876543029',
        },
        {
          'shop': 'Local Organic Farm',
          'price': 540.0,
          'distance': 3.5,
          'phone': '+91 9876543030',
        },
      ],
    },
    {
      'id': 'fert_016',
      'name': 'Bone Meal',
      'category': 'Organic & Bio',
      'description': 'Organic phosphorus source',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Organic Farm Store',
          'price': 600.0,
          'distance': 2.0,
          'phone': '+91 9876543031',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 650.0,
          'distance': 3.8,
          'phone': '+91 9876543032',
        },
      ],
    },
    {
      'id': 'fert_017',
      'name': 'Rhizobium Culture',
      'category': 'Organic & Bio',
      'description': 'Biofertilizer culture',
      'image': '',
      'icon': Icons.biotech_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Bio Agri Centre',
          'price': 180.0,
          'distance': 2.2,
          'phone': '+91 9876543033',
        },
        {
          'shop': 'Organic Farm Store',
          'price': 210.0,
          'distance': 4.0,
          'phone': '+91 9876543034',
        },
      ],
    },
    {
      'id': 'fert_018',
      'name': 'Azotobacter',
      'category': 'Organic & Bio',
      'description': 'Nitrogen-fixing biofertilizer',
      'image': '',
      'icon': Icons.biotech_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Bio Agri Centre',
          'price': 190.0,
          'distance': 1.9,
          'phone': '+91 9876543035',
        },
        {
          'shop': 'Organic Farm Store',
          'price': 230.0,
          'distance': 3.4,
          'phone': '+91 9876543036',
        },
      ],
    },
    {
      'id': 'fert_019',
      'name': 'Phosphate Solubilizing Bacteria',
      'category': 'Organic & Bio',
      'description': 'PSB biofertilizer',
      'image': '',
      'icon': Icons.biotech_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Bio Agri Centre',
          'price': 200.0,
          'distance': 2.1,
          'phone': '+91 9876543037',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 240.0,
          'distance': 3.7,
          'phone': '+91 9876543038',
        },
      ],
    },
    {
      'id': 'fert_020',
      'name': 'Green Manure',
      'category': 'Organic & Bio',
      'description': 'Organic soil improvement',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Organic Farm',
          'price': 250.0,
          'distance': 1.5,
          'phone': '+91 9876543039',
        },
        {
          'shop': 'Organic Farm Store',
          'price': 290.0,
          'distance': 3.1,
          'phone': '+91 9876543040',
        },
      ],
    },

    // -----------------------------------------------------
    // MICRONUTRIENTS
    // -----------------------------------------------------
    {
      'id': 'fert_021',
      'name': 'Bentonite Sulphur',
      'category': 'Micronutrients',
      'description': 'Sulphur soil conditioner',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 700.0,
          'distance': 2.0,
          'phone': '+91 9876543041',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 750.0,
          'distance': 3.8,
          'phone': '+91 9876543042',
        },
      ],
    },
    {
      'id': 'fert_022',
      'name': 'Zinc Sulphate',
      'category': 'Micronutrients',
      'description': 'Zinc micronutrient',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Agri Store',
          'price': 900.0,
          'distance': 1.7,
          'phone': '+91 9876543043',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 950.0,
          'distance': 3.2,
          'phone': '+91 9876543044',
        },
      ],
    },
    {
      'id': 'fert_023',
      'name': 'Ferrous Sulphate',
      'category': 'Micronutrients',
      'description': 'Iron micronutrient',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 450.0,
          'distance': 2.2,
          'phone': '+91 9876543045',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 500.0,
          'distance': 4.0,
          'phone': '+91 9876543046',
        },
      ],
    },
    {
      'id': 'fert_024',
      'name': 'Borax',
      'category': 'Micronutrients',
      'description': 'Boron source',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Local Agri Store',
          'price': 300.0,
          'distance': 1.9,
          'phone': '+91 9876543047',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 340.0,
          'distance': 3.5,
          'phone': '+91 9876543048',
        },
      ],
    },
    {
      'id': 'fert_025',
      'name': 'Magnesium Sulphate',
      'category': 'Micronutrients',
      'description': 'Magnesium and sulphur source',
      'image': '',
      'icon': Icons.science_outlined,
      'warning': false,
      'sellers': [
        {
          'shop': 'Green Farm Centre',
          'price': 550.0,
          'distance': 2.3,
          'phone': '+91 9876543049',
        },
        {
          'shop': 'Local Agri Store',
          'price': 600.0,
          'distance': 3.7,
          'phone': '+91 9876543050',
        },
      ],
    },
    {
      'id': 'fert_026',
      'name': 'Gypsum',
      'category': 'Micronutrients',
      'description': 'Calcium and sulphur source',
      'image': '',
      'icon': Icons.grass,
      'warning': false,
      'sellers': [
        {
          'shop': 'Farm Input Centre',
          'price': 400.0,
          'distance': 1.8,
          'phone': '+91 9876543051',
        },
        {
          'shop': 'Green Farm Centre',
          'price': 440.0,
          'distance': 3.1,
          'phone': '+91 9876543052',
        },
      ],
    },

    // -----------------------------------------------------
    // CROP PROTECTION
    // -----------------------------------------------------
    {
      'id': 'fert_027',
      'name': 'Glyphosate',
      'category': 'Crop Protection',
      'description': 'Non-selective herbicide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Crop Protection Centre',
          'price': 650.0,
          'distance': 2.0,
          'phone': '+91 9876543053',
        },
        {
          'shop': 'Farm Input Centre',
          'price': 700.0,
          'distance': 3.8,
          'phone': '+91 9876543054',
        },
      ],
    },
    {
      'id': 'fert_028',
      'name': 'Paraquat',
      'category': 'Crop Protection',
      'description': 'Contact herbicide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Crop Protection Centre',
          'price': 700.0,
          'distance': 2.4,
          'phone': '+91 9876543055',
        },
        {
          'shop': 'Agri Care Store',
          'price': 750.0,
          'distance': 4.0,
          'phone': '+91 9876543056',
        },
      ],
    },
    {
      'id': 'fert_029',
      'name': 'Thiamethoxam',
      'category': 'Crop Protection',
      'description': 'Systemic insecticide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Agri Care Store',
          'price': 550.0,
          'distance': 1.9,
          'phone': '+91 9876543057',
        },
        {
          'shop': 'Crop Protection Centre',
          'price': 590.0,
          'distance': 3.3,
          'phone': '+91 9876543058',
        },
      ],
    },
    {
      'id': 'fert_030',
      'name': 'Chlorpyrifos',
      'category': 'Crop Protection',
      'description': 'Insecticide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Crop Protection Centre',
          'price': 600.0,
          'distance': 2.1,
          'phone': '+91 9876543059',
        },
        {
          'shop': 'Agri Care Store',
          'price': 650.0,
          'distance': 3.7,
          'phone': '+91 9876543060',
        },
      ],
    },
    {
      'id': 'fert_031',
      'name': 'Dimethoate',
      'category': 'Crop Protection',
      'description': 'Insecticide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Agri Care Store',
          'price': 500.0,
          'distance': 1.8,
          'phone': '+91 9876543061',
        },
        {
          'shop': 'Crop Protection Centre',
          'price': 540.0,
          'distance': 3.5,
          'phone': '+91 9876543062',
        },
      ],
    },
    {
      'id': 'fert_032',
      'name': 'Mancozeb',
      'category': 'Crop Protection',
      'description': 'Fungicide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Crop Protection Centre',
          'price': 650.0,
          'distance': 2.2,
          'phone': '+91 9876543063',
        },
        {
          'shop': 'Agri Care Store',
          'price': 700.0,
          'distance': 4.0,
          'phone': '+91 9876543064',
        },
      ],
    },
    {
      'id': 'fert_033',
      'name': 'Carbendazim',
      'category': 'Crop Protection',
      'description': 'Fungicide',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Agri Care Store',
          'price': 500.0,
          'distance': 1.7,
          'phone': '+91 9876543065',
        },
        {
          'shop': 'Crop Protection Centre',
          'price': 550.0,
          'distance': 3.2,
          'phone': '+91 9876543066',
        },
      ],
    },
    {
      'id': 'fert_034',
      'name': 'Copper Sulphate',
      'category': 'Crop Protection',
      'description': 'Crop protection chemical',
      'image': '',
      'icon': Icons.warning_amber_outlined,
      'warning': true,
      'sellers': [
        {
          'shop': 'Crop Protection Centre',
          'price': 750.0,
          'distance': 2.3,
          'phone': '+91 9876543067',
        },
        {
          'shop': 'Agri Care Store',
          'price': 800.0,
          'distance': 4.1,
          'phone': '+91 9876543068',
        },
      ],
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    final result = products.where((product) {
      final categoryMatch =
          selectedCategory == 'All' ||
              product['category'] == selectedCategory;

      final query = searchQuery.toLowerCase();

      final searchMatch = query.isEmpty ||
          product['name']
              .toString()
              .toLowerCase()
              .contains(query) ||
          product['category']
              .toString()
              .toLowerCase()
              .contains(query) ||
          product['description']
              .toString()
              .toLowerCase()
              .contains(query);

      final sellers =
          List<Map<String, dynamic>>.from(
        product['sellers'] ?? [],
      );

      return categoryMatch &&
          searchMatch &&
          sellers.isNotEmpty;
    }).toList();

    result.sort((a, b) {
      final priceA = _cheapestPrice(a);
      final priceB = _cheapestPrice(b);

      return lowToHigh
          ? priceA.compareTo(priceB)
          : priceB.compareTo(priceA);
    });

    return result;
  }

  double _cheapestPrice(Map<String, dynamic> product) {
    final sellers =
        List<Map<String, dynamic>>.from(
      product['sellers'] ?? [],
    );

    if (sellers.isEmpty) return double.infinity;

    sellers.sort(
      (a, b) => (a['price'] as num)
          .compareTo(b['price'] as num),
    );

    return (sellers.first['price'] as num).toDouble();
  }

  Map<String, dynamic>? _cheapestSeller(
    Map<String, dynamic> product,
  ) {
    final sellers =
        List<Map<String, dynamic>>.from(
      product['sellers'] ?? [],
    );

    if (sellers.isEmpty) return null;

    sellers.sort(
      (a, b) => (a['price'] as num)
          .compareTo(b['price'] as num),
    );

    return sellers.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaleGreen,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildSearch(),

                          const SizedBox(height: 16),

                          _buildLocationBanner(),

                          const SizedBox(height: 20),

                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),

                          const SizedBox(height: 11),

                          _buildCategories(),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Fertilizers & Crop Protection',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: kTextDark,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    lowToHigh =
                                        !lowToHigh;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius
                                            .circular(10),
                                    border: Border.all(
                                      color: kSoftGreen,
                                    ),
                                  ),
                                  child: Icon(
                                    lowToHigh
                                        ? Icons
                                            .arrow_upward
                                        : Icons
                                            .arrow_downward,
                                    color: kGreen,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '${filteredProducts.length} products • ${lowToHigh ? 'Lowest' : 'Highest'} price first',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kTextGrey,
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  if (filteredProducts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 15,
                            color: kTextGrey,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildProductCard(
                              filteredProducts[index],
                            );
                          },
                          childCount:
                              filteredProducts.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: kGreen,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Fertilizers & Chemicals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kPrimaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC8E6C9),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: kGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search fertilizers...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.mic_none,
              color: kGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSoftGreen,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFC8E6C9),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: kGreen,
            size: 23,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Showing nearby agricultural sellers',
              style: TextStyle(
                color: kPrimaryGreen,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? kGreen
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected
                      ? kGreen
                      : const Color(0xFFC8E6C9),
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  maxLines: 1,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : kPrimaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
  ) {
    final cheapest = _cheapestSeller(product);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: product['warning'] == true
              ? const Color(0xFFFFE082)
              : kSoftGreen,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildProductImage(product),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                        ),
                        if (product['warning'] == true)
                          Container(
                            margin:
                                const EdgeInsets.only(
                              left: 6,
                            ),
                            padding:
                                const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kSoftAmber,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.warning_amber_rounded,
                              color: kAmber,
                              size: 17,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      product['category'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: kGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPaleGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  color: kGreen,
                  size: 19,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    cheapest?['shop'] ??
                        'No nearby seller',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                ),
                if (cheapest != null)
                  Text(
                    '₹${_formatPrice(cheapest['price'])}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryGreen,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          if (cheapest != null)
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: kGreen,
                  size: 15,
                ),
                const SizedBox(width: 3),
                Text(
                  '${cheapest['distance']} km away',
                  style: const TextStyle(
                    fontSize: 12,
                    color: kGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Lowest nearby price',
                  style: TextStyle(
                    fontSize: 11,
                    color: kGreen.withOpacity(0.8),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showContactDialog(
                      context,
                      cheapest,
                    );
                  },
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 17,
                  ),
                  label: const Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kGreen,
                    side: const BorderSide(
                      color: kGreen,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FertilizerSellersPage(
                          product: product,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'View Sellers',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(
    Map<String, dynamic> product,
  ) {
    final image = product['image']?.toString() ?? '';

    if (image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          image,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _fallbackProductIcon(product);
          },
        ),
      );
    }

    return _fallbackProductIcon(product);
  }

  Widget _fallbackProductIcon(
    Map<String, dynamic> product,
  ) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: product['warning'] == true
            ? kSoftAmber
            : kSoftGreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        product['icon'] ?? Icons.eco_outlined,
        color: product['warning'] == true
            ? kAmber
            : kGreen,
        size: 31,
      ),
    );
  }

  void _showContactDialog(
    BuildContext context,
    Map<String, dynamic>? seller,
  ) {
    if (seller == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contact Seller'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              seller['shop'],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(seller['phone']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: kGreen),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic value) {
    final price = (value as num).toDouble();

    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }
}

// =========================================================
// ALL NEARBY SELLERS FOR A SPECIFIC FERTILIZER
// =========================================================

class FertilizerSellersPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const FertilizerSellersPage({
    super.key,
    required this.product,
  });

  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kPrimaryGreen = Color(0xFF1B5E20);
  static const Color kSoftGreen = Color(0xFFE8F5E9);
  static const Color kPaleGreen = Color(0xFFF4FAF4);
  static const Color kTextDark = Color(0xFF263238);
  static const Color kTextGrey = Color(0xFF607D8B);
  static const Color kAmber = Color(0xFFF9A825);
  static const Color kSoftAmber = Color(0xFFFFF8E1);

  List<Map<String, dynamic>> get sortedSellers {
    final sellers =
        List<Map<String, dynamic>>.from(
      product['sellers'] ?? [],
    );

    sellers.sort(
      (a, b) => (a['price'] as num)
          .compareTo(b['price'] as num),
    );

    return sellers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPaleGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: kTextDark,
        ),
        title: Text(
          product['name'],
          style: const TextStyle(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildProductSummary(),

                  const SizedBox(height: 20),

                  Text(
                    '${sortedSellers.length} Nearby Sellers',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Sorted from lowest to highest price',
                    style: TextStyle(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildSellerCard(
                    context,
                    sortedSellers[index],
                    index == 0,
                  );
                },
                childCount: sortedSellers.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSummary() {
    final warning = product['warning'] == true;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: warning
              ? const Color(0xFFFFE082)
              : kSoftGreen,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color:
                  warning ? kSoftAmber : kSoftGreen,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Icon(
              product['icon'] ?? Icons.eco_outlined,
              color: warning ? kAmber : kGreen,
              size: 32,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product['description'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: kTextGrey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product['category'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: kGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(
    BuildContext context,
    Map<String, dynamic> seller,
    bool cheapest,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: cheapest
              ? const Color(0xFFA5D6A7)
              : kSoftGreen,
          width: cheapest ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kSoftGreen,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  color: kGreen,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            seller['shop'],
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                        ),

                        if (cheapest)
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: kSoftGreen,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LOWEST',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    FontWeight.w800,
                                color: kGreen,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: kGreen,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${seller['distance']} km away',
                          style: const TextStyle(
                            fontSize: 12,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  '₹${_formatPrice(seller['price'])}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryGreen,
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        'Contact Seller',
                      ),
                      content: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            seller['shop'],
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(seller['phone']),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: kGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.phone_outlined,
                  size: 17,
                ),
                label: const Text('Contact'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kGreen,
                  side: const BorderSide(
                    color: kGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic value) {
    final price = (value as num).toDouble();

    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }
}