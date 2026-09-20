import 'package:flutter/material.dart';
import 'marketplace_page.dart';

class FertilizersPage extends StatefulWidget {
  const FertilizersPage({
    super.key,
    this.products = const [],
  });

  // Dynamic backend/API data.
  //
  // Expected structure:
  //
  // [
  //   {
  //     'id': 'fert_001',
  //     'name': 'Urea',
  //     'category': 'Chemical Fertilizers',
  //     'description': 'Nitrogen fertilizer',
  //     'image': '',
  //     'icon': Icons.grass,
  //     'warning': false,
  //     'sellers': [
  //       {
  //         'shop': 'Local Agri Store',
  //         'price': 270.0,
  //         'distance': 1.4,
  //         'phone': '+91 9876543001',
  //       },
  //     ],
  //   },
  // ]
  final List<Map<String, dynamic>> products;

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    final result = widget.products.where((product) {
      final categoryMatch =
          selectedCategory == 'All' ||
          product['category'] == selectedCategory;

      final query = searchQuery.toLowerCase();

      final searchMatch =
          query.isEmpty ||
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

  double _cheapestPrice(
    Map<String, dynamic> product,
  ) {
    final sellers =
        List<Map<String, dynamic>>.from(
      product['sellers'] ?? [],
    );

    if (sellers.isEmpty) return double.infinity;

    sellers.sort(
      (a, b) => (a['price'] as num)
          .compareTo(b['price'] as num),
    );

    return (sellers.first['price'] as num)
        .toDouble();
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
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
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
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      sliver: SliverList(
                        delegate:
                            SliverChildBuilderDelegate(
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
      padding:
          const EdgeInsets.fromLTRB(8, 10, 16, 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const MarketplacePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: kTextDark,
              size: 21,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),
          ),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kSoftGreen,
              borderRadius:
                  BorderRadius.circular(12),
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
                hintText:
                    'Search fertilizers...',
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
        physics:
            const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected =
              category == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? kGreen
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
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
                    fontWeight:
                        FontWeight.w600,
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
    final cheapest =
        _cheapestSeller(product);

    return Container(
      margin:
          const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: product['warning'] == true
              ? const Color(0xFFFFE082)
              : kSoftGreen,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.035),
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
                            product['name']
                                ?.toString() ??
                                '',
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                        ),

                        if (product['warning'] ==
                            true)
                          Container(
                            margin:
                                const EdgeInsets
                                    .only(
                              left: 6,
                            ),
                            padding:
                                const EdgeInsets
                                    .all(5),
                            decoration:
                                BoxDecoration(
                              color: kSoftAmber,
                              borderRadius:
                                  BorderRadius
                                      .circular(8),
                            ),
                            child:
                                const Icon(
                              Icons
                                  .warning_amber_rounded,
                              color: kAmber,
                              size: 17,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product['description']
                              ?.toString() ??
                          '',
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      product['category']
                              ?.toString() ??
                          '',
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color: kGreen,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding:
                const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPaleGreen,
              borderRadius:
                  BorderRadius.circular(12),
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
                    cheapest?['shop']
                            ?.toString() ??
                        'No nearby seller',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                ),
                if (cheapest != null)
                  Text(
                    '₹${_formatPrice(cheapest['price'])}',
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
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
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color: kGreen,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Lowest nearby price',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        kGreen.withOpacity(
                      0.8,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
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
                  label:
                      const Text('Contact'),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        kGreen,
                    side:
                        const BorderSide(
                      color: kGreen,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(11),
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
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        kGreen,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(11),
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
    final image =
        product['image']?.toString() ?? '';

    if (image.isNotEmpty) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(15),
        child: Image.network(
          image,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) {
            return _fallbackProductIcon(
              product,
            );
          },
        ),
      );
    }

    return _fallbackProductIcon(
      product,
    );
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
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Icon(
        product['icon'] ??
            Icons.eco_outlined,
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
        title:
            const Text('Contact Seller'),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              seller['shop']?.toString() ??
                  '',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              seller['phone']?.toString() ??
                  '',
            ),
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
  }

  String _formatPrice(dynamic value) {
    final price =
        (value as num).toDouble();

    if (price ==
        price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }
}

// =========================================================
// ALL NEARBY SELLERS FOR A SPECIFIC FERTILIZER
// =========================================================

class FertilizerSellersPage
    extends StatelessWidget {
  final Map<String, dynamic> product;

  const FertilizerSellersPage({
    super.key,
    required this.product,
  });

  static const Color kGreen =
      Color(0xFF2E7D32);
  static const Color kPrimaryGreen =
      Color(0xFF1B5E20);
  static const Color kSoftGreen =
      Color(0xFFE8F5E9);
  static const Color kPaleGreen =
      Color(0xFFF4FAF4);
  static const Color kTextDark =
      Color(0xFF263238);
  static const Color kTextGrey =
      Color(0xFF607D8B);
  static const Color kAmber =
      Color(0xFFF9A825);
  static const Color kSoftAmber =
      Color(0xFFFFF8E1);

  List<Map<String, dynamic>>
      get sortedSellers {
    final sellers =
        List<Map<String, dynamic>>.from(
      product['sellers'] ?? [],
    );

    sellers.sort(
      (a, b) => (a['price'] as num)
          .compareTo(
        b['price'] as num,
      ),
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
        iconTheme:
            const IconThemeData(
          color: kTextDark,
        ),
        title: Text(
          product['name']?.toString() ?? '',
          style:
              const TextStyle(
            color: kPrimaryGreen,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding:
                const EdgeInsets.all(16),
            sliver:
                SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildProductSummary(),

                  const SizedBox(height: 20),

                  Text(
                    '${sortedSellers.length} Nearby Sellers',
                    style:
                        const TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Sorted from lowest to highest price',
                    style:
                        TextStyle(
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
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  return _buildSellerCard(
                    context,
                    sortedSellers[index],
                    index == 0,
                  );
                },
                childCount:
                    sortedSellers.length,
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
    final warning =
        product['warning'] == true;

    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
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
              color: warning
                  ? kSoftAmber
                  : kSoftGreen,
              borderRadius:
                  BorderRadius.circular(15),
            ),
            child: Icon(
              product['icon'] ??
                  Icons.eco_outlined,
              color: warning
                  ? kAmber
                  : kGreen,
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
                  product['name']
                          ?.toString() ??
                      '',
                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                    color: kTextDark,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  product['description']
                          ?.toString() ??
                      '',
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color: kTextGrey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  product['category']
                          ?.toString() ??
                      '',
                  style:
                      const TextStyle(
                    fontSize: 11,
                    color: kGreen,
                    fontWeight:
                        FontWeight.w600,
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
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
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
                decoration:
                    BoxDecoration(
                  color: kSoftGreen,
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .storefront_outlined,
                  color: kGreen,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            seller['shop']
                                    ?.toString() ??
                                '',
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color:
                                  kTextDark,
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
                            decoration:
                                BoxDecoration(
                              color:
                                  kSoftGreen,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                8,
                              ),
                            ),
                            child:
                                const Text(
                              'LOWEST',
                              style:
                                  TextStyle(
                                fontSize: 9,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color:
                                    kGreen,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          size: 15,
                          color: kGreen,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${seller['distance']} km away',
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                kTextGrey,
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
                  style:
                      const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        kPrimaryGreen,
                  ),
                ),
              ),

              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                      title:
                          const Text(
                        'Contact Seller',
                      ),
                      content: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            seller['shop']
                                    ?.toString() ??
                                '',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            seller['phone']
                                    ?.toString() ??
                                '',
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(
                            context,
                          ),
                          child:
                              const Text(
                            'Close',
                            style:
                                TextStyle(
                              color:
                                  kGreen,
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
                label:
                    const Text('Contact'),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      kGreen,
                  side:
                      const BorderSide(
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
    final price =
        (value as num).toDouble();

    if (price ==
        price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }
}