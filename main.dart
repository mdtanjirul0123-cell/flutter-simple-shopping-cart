import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingCartApp());
}

// ================= PRODUCT MODEL =================

class Product {
  final String name;
  final double price;
  final String category;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.category,
    this.quantity = 0,
  });
}

// ================= APP =================

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Shopping Cart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3157D5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const ShoppingCartScreen(),
    );
  }
}

// ================= SHOPPING CART SCREEN =================

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() =>
      _ShoppingCartScreenState();
}

class _ShoppingCartScreenState
    extends State<ShoppingCartScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Product> products = [
    Product(
      name: 'T-Shirt',
      price: 500,
      category: 'Clothes',
    ),
    Product(
      name: 'Shoes',
      price: 1500,
      category: 'Fashion',
    ),
    Product(
      name: 'Watch',
      price: 2000,
      category: 'Accessories',
    ),
    Product(
      name: 'Bag',
      price: 1000,
      category: 'Fashion',
    ),
  ];

  // ================= FILTER PRODUCTS =================

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' ||
          product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ================= TOTAL ITEMS =================

  int get totalItems {
    int total = 0;

    for (final product in products) {
      total += product.quantity;
    }

    return total;
  }

  // ================= SUBTOTAL =================

  double get subtotal {
    double total = 0;

    for (final product in products) {
      total += product.price * product.quantity;
    }

    return total;
  }

  // ================= DISCOUNT =================

  double get discount {
    if (subtotal >= 3000) {
      return subtotal * 0.10;
    }

    return 0;
  }

  // ================= GRAND TOTAL =================

  double get grandTotal {
    return subtotal - discount;
  }

  // ================= CURRENCY FORMAT =================

  String formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return '৳${value.toInt()}';
    }

    return '৳${value.toStringAsFixed(2)}';
  }

  // ================= INCREASE QUANTITY =================

  void increaseQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
  }

  // ================= DECREASE QUANTITY =================

  void decreaseQuantity(Product product) {
    setState(() {
      if (product.quantity > 0) {
        product.quantity--;
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(
              Icons.shopping_cart_rounded,
              color: Color(0xFF3157D5),
            ),
            SizedBox(width: 10),
            Text(
              'Shopping Cart',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // ================= SEARCH & FILTER =================

          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            color: Colors.white,
            child: Column(
              children: [
                // Search
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              setState(() {
                                searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF3F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Category Dropdown
                Row(
                  children: [
                    const Icon(
                      Icons.filter_list_rounded,
                      color: Color(0xFF596579),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Category:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F9),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text('All'),
                              ),
                              DropdownMenuItem(
                                value: 'Clothes',
                                child: Text('Clothes'),
                              ),
                              DropdownMenuItem(
                                value: 'Fashion',
                                child: Text('Fashion'),
                              ),
                              DropdownMenuItem(
                                value: 'Accessories',
                                child: Text('Accessories'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;

                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= PRODUCT LIST =================

          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 70,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Try another search or category.',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product =
                          filteredProducts[index];

                      return ProductCard(
                        product: product,
                        formattedPrice:
                            formatPrice(product.price),
                        onIncrease: () {
                          increaseQuantity(product);
                        },
                        onDecrease: () {
                          decreaseQuantity(product);
                        },
                      );
                    },
                  ),
          ),

          // ================= CART SUMMARY =================

          CartSummary(
            totalItems: totalItems,
            subtotal: subtotal,
            discount: discount,
            grandTotal: grandTotal,
            formatPrice: formatPrice,
          ),
        ],
      ),
    );
  }
}

// ================= PRODUCT CARD =================

class ProductCard extends StatelessWidget {
  final Product product;
  final String formattedPrice;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductCard({
    super.key,
    required this.product,
    required this.formattedPrice,
    required this.onIncrease,
    required this.onDecrease,
  });

  Color get categoryColor {
    switch (product.category) {
      case 'Clothes':
        return const Color(0xFF7C3AED);

      case 'Fashion':
        return const Color(0xFFE11D48);

      case 'Accessories':
        return const Color(0xFF0891B2);

      default:
        return const Color(0xFF3157D5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFE7EAF0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            // Product Icon
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _productIcon,
                color: const Color(0xFF3157D5),
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            // Product Information
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172033),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3157D5),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Quantity Controls
            Column(
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: product.quantity > 0
                            ? onDecrease
                            : null,
                        icon: const Icon(
                          Icons.remove_rounded,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        padding: EdgeInsets.zero,
                      ),

                      SizedBox(
                        width: 28,
                        child: Text(
                          '${product.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: onIncrease,
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData get _productIcon {
    switch (product.category) {
      case 'Clothes':
        return Icons.checkroom_rounded;

      case 'Fashion':
        return Icons.shopping_bag_rounded;

      case 'Accessories':
        return Icons.watch_rounded;

      default:
        return Icons.shopping_cart_rounded;
    }
  }
}

// ================= CART SUMMARY =================

class CartSummary extends StatelessWidget {
  final int totalItems;
  final double subtotal;
  final double discount;
  final double grandTotal;
  final String Function(double) formatPrice;

  const CartSummary({
    super.key,
    required this.totalItems,
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary title
          const Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: Color(0xFF3157D5),
              ),
              SizedBox(width: 8),
              Text(
                'Cart Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Total Items
          _SummaryRow(
            title: 'Total Items',
            value: '$totalItems',
          ),

          const SizedBox(height: 7),

          // Subtotal
          _SummaryRow(
            title: 'Subtotal',
            value: formatPrice(subtotal),
          ),

          const SizedBox(height: 7),

          // Discount
          _SummaryRow(
            title: 'Discount',
            value: discount > 0
                ? '-${formatPrice(discount)}'
                : formatPrice(0),
            valueColor: discount > 0
                ? const Color(0xFF16A34A)
                : const Color(0xFF6B7280),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Grand Total
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
              Text(
                formatPrice(grandTotal),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
 