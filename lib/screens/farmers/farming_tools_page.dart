import 'package:flutter/material.dart';

import 'marketplace_page.dart';

class FarmingToolsPage extends StatefulWidget {
  const FarmingToolsPage({
    super.key,
    this.tools = const [],
  });

  /// Dynamic data supplied by the backend/API.
  ///
  /// Expected structure:
  ///
  /// {
  ///   'id': 'tool_001',
  ///   'name': 'Agricultural Plough',
  ///   'category': 'Plough',
  ///   'image': 'image_url',
  ///   'icon': Icons.agriculture,
  ///   'sellers': [
  ///     {
  ///       'shop': 'Shop Name',
  ///       'price': 4500,
  ///       'distance': 2.1,
  ///       'phone': '+91 XXXXX XXXXX',
  ///     }
  ///   ]
  /// }
  final List<Map<String, dynamic>> tools;

  @override
  State<FarmingToolsPage> createState() => _FarmingToolsPageState();
}

class _FarmingToolsPageState extends State<FarmingToolsPage> {
  static const Color kGreen = Color(0xFF2E7D32);
  static const Color kPrimaryGreen = Color(0xFF1B5E20);
  static const Color kSoftGreen = Color(0xFFE8F5E9);
  static const Color kPaleGreen = Color(0xFFF4FAF4);
  static const Color kTextDark = Color(0xFF263238);
  static const Color kTextGrey = Color(0xFF607D8B);

  String selectedCategory = 'All';
  String searchQuery = '';

  final TextEditingController searchController =
      TextEditingController();

  final List<String> categories = [
    'All',
    'Plough',
    'Blade Harrow',
    'Clod Crusher',
    'Leveling Plank',
    'Sickle',
    'Weeding Hoe',
    'Spade',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTools {
    final result = widget.tools.where((tool) {
      final categoryMatch =
          selectedCategory == 'All' ||
              tool['category'] == selectedCategory;

      final query = searchQuery.toLowerCase();

      final searchMatch =
          query.isEmpty ||
          tool['name']
              .toString()
              .toLowerCase()
              .contains(query) ||
          tool['category']
              .toString()
              .toLowerCase()
              .contains(query);

      final sellers =
          List<Map<String, dynamic>>.from(
        tool['sellers'] ?? [],
      );

      return categoryMatch &&
          searchMatch &&
          sellers.isNotEmpty;
    }).toList();

    // Sort tools according to their cheapest nearby seller.
    result.sort(
      (a, b) => _cheapestPrice(a).compareTo(
        _cheapestPrice(b),
      ),
    );

    return result;
  }

  double _cheapestPrice(
    Map<String, dynamic> tool,
  ) {
    final sellers =
        List<Map<String, dynamic>>.from(
      tool['sellers'] ?? [],
    );

    if (sellers.isEmpty) {
      return double.infinity;
    }

    sellers.sort(
      (a, b) => (a['price'] as num).compareTo(
        b['price'] as num,
      ),
    );

    return (sellers.first['price'] as num).toDouble();
  }

  Map<String, dynamic>? _cheapestSeller(
    Map<String, dynamic> tool,
  ) {
    final sellers =
        List<Map<String, dynamic>>.from(
      tool['sellers'] ?? [],
    );

    if (sellers.isEmpty) {
      return null;
    }

    sellers.sort(
      (a, b) => (a['price'] as num).compareTo(
        b['price'] as num,
      ),
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

                          const SizedBox(height: 20),

                          const Text(
                            'Tool Categories',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),

                          const SizedBox(height: 11),

                          _buildCategories(),

                          const SizedBox(height: 22),

                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Farming Tools Near You',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w700,
                                    color: kTextDark,
                                  ),
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: kSoftGreen,
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: kGreen,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Lowest nearby price shown',
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

                  if (filteredTools.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No farming tools found',
                          style: TextStyle(
                            color: kTextGrey,
                            fontSize: 15,
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
                        delegate:
                            SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildToolCard(
                              filteredTools[index],
                            );
                          },
                          childCount:
                              filteredTools.length,
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
      padding: const EdgeInsets.fromLTRB(
        4,
        8,
        16,
        10,
      ),
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
              Icons.arrow_back,
              color: kTextDark,
              size: 24,
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
              Icons.handyman_outlined,
              color: kGreen,
              size: 25,
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'Farming Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kPrimaryGreen,
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
                    'Search farming tools...',
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
          final category =
              categories[index];

          final selected =
              category == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    category;
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
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
                      : const Color(
                          0xFFC8E6C9,
                        ),
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

  Widget _buildToolCard(
    Map<String, dynamic> tool,
  ) {
    final cheapest =
        _cheapestSeller(tool);

    return Container(
      margin:
          const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: kSoftGreen,
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
              _buildToolImage(tool),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool['name']?.toString() ??
                          'Farming Tool',
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

                    const SizedBox(height: 5),

                    Text(
                      tool['category']
                              ?.toString() ??
                          '',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                      ),
                    ),

                    if (cheapest != null) ...[
                      const SizedBox(height: 8),

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
                            '${cheapest['distance']} km away',
                            style:
                                const TextStyle(
                              fontSize: 12,
                              color: kGreen,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                  Icons
                      .storefront_outlined,
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
                      color:
                          kPrimaryGreen,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed: () {
                    _showContactDialog(
                      cheapest,
                    );
                  },
                  icon: const Icon(
                    Icons.phone_outlined,
                    size: 18,
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
                          BorderRadius.circular(
                        11,
                      ),
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
                            ToolSellersPage(
                          tool: tool,
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
                          BorderRadius.circular(
                        11,
                      ),
                    ),
                  ),
                  child:
                      const Text(
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

  Widget _buildToolImage(
    Map<String, dynamic> tool,
  ) {
    final image =
        tool['image']?.toString() ?? '';

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
            return _fallbackToolIcon(
              tool,
            );
          },
        ),
      );
    }

    return _fallbackToolIcon(tool);
  }

  Widget _fallbackToolIcon(
    Map<String, dynamic> tool,
  ) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: kSoftGreen,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Icon(
        tool['icon'] ??
            Icons.agriculture,
        color: kGreen,
        size: 32,
      ),
    );
  }

  String _formatPrice(dynamic value) {
    if (value == null) {
      return '--';
    }

    final price =
        (value as num).toDouble();

    if (price ==
        price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }

  void _showContactDialog(
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
              seller['shop']
                      ?.toString() ??
                  'Seller',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              seller['phone']
                      ?.toString() ??
                  'Contact information unavailable',
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
}

// ---------------------------------------------------------
// ALL NEARBY SELLERS FOR A SPECIFIC TOOL
// ---------------------------------------------------------

class ToolSellersPage extends StatelessWidget {
  final Map<String, dynamic> tool;

  const ToolSellersPage({
    super.key,
    required this.tool,
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

  List<Map<String, dynamic>>
      get sortedSellers {
    final sellers =
        List<Map<String, dynamic>>.from(
      tool['sellers'] ?? [],
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
          tool['name']?.toString() ??
              'Farming Tool',
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
                  Container(
                    padding:
                        const EdgeInsets.all(
                      15,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration:
                              BoxDecoration(
                            color:
                                kSoftGreen,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),
                          child: Icon(
                            tool['icon'] ??
                                Icons
                                    .agriculture,
                            color: kGreen,
                            size: 32,
                          ),
                        ),

                        const SizedBox(
                            width: 13),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                tool['name']
                                        ?.toString() ??
                                    'Farming Tool',
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color:
                                      kTextDark,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                tool['category']
                                        ?.toString() ??
                                    '',
                                style:
                                    const TextStyle(
                                  color:
                                      kTextGrey,
                                  fontSize:
                                      13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 20),

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

                  const SizedBox(
                      height: 5),

                  const Text(
                    'Sorted from lowest to highest price',
                    style:
                        TextStyle(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),

                  const SizedBox(
                      height: 12),
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
              ? const Color(
                  0xFFA5D6A7,
                )
              : kSoftGreen,
          width: cheapest
              ? 1.5
              : 1,
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
                child: const Icon(
                  Icons
                      .storefront_outlined,
                  color: kGreen,
                ),
              ),

              const SizedBox(
                  width: 11),

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
                                'Seller',
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

                    const SizedBox(
                        height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          size: 15,
                          color: kGreen,
                        ),

                        const SizedBox(
                            width: 3),

                        Text(
                          '${seller['distance'] ?? '--'} km away',
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

          const SizedBox(
              height: 12),

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
                      content: Text(
                        seller['phone']
                                ?.toString() ??
                            'Contact information unavailable',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator
                                  .pop(
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

  String _formatPrice(
    dynamic value,
  ) {
    if (value == null) {
      return '--';
    }

    final price =
        (value as num).toDouble();

    if (price ==
        price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }
}