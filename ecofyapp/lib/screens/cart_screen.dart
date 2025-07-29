import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Mock cart data
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Maize Seeds',
      'price': 2500,
      'originalPrice': 3000,
      'quantity': 2,
      'image': 'assets/images/maize.jpg',
      'seller': 'Agro Supplies Ltd',
      'category': 'Seeds',
      'grade': 'Premium',
      'unit': 'kg',
    },
    {
      'id': '2',
      'name': 'Fertilizer NPK',
      'price': 15000,
      'originalPrice': 15000,
      'quantity': 1,
      'image': 'assets/images/fertilizer.jpg',
      'seller': 'Farm Solutions',
      'category': 'Fertilizers',
      'unit': 'bag',
    },
    {
      'id': '3',
      'name': 'Tomato Seeds',
      'price': 800,
      'originalPrice': 1000,
      'quantity': 3,
      'image': 'assets/images/tomato.jpg',
      'seller': 'Seed Co',
      'category': 'Seeds',
      'grade': 'Standard',
      'unit': 'pack',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final totalItems = _cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
    final subtotal = _cartItems.fold<double>(0, (sum, item) => sum + (item['price'] * (item['quantity'] as int)));
    final discount = _cartItems.fold<double>(0, (sum, item) => sum + ((item['originalPrice'] - item['price']) * (item['quantity'] as int)));
    final total = subtotal;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _clearCart(),
          ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(item, index);
                    },
                  ),
                ),
                _buildOrderSummary(subtotal, discount, total, totalItems),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/market');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Browse Products',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
            child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: Image, Details, Remove Button
            Row(
              children: [
                // Product Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(item['category']),
                    color: AppTheme.primaryGreen,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['seller'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${item['price']} TZS',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                          if (item['originalPrice'] > item['price']) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${item['originalPrice']} TZS',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (item['grade'] != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['grade'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Remove Button
                IconButton(
                  onPressed: () => _removeItem(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppTheme.errorRed,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom Row: Quantity Controls and Unit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity Controls
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _updateQuantity(index, -1),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 18,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '${item['quantity']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _updateQuantity(index, 1),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Unit Text
                Text(
                  'Per ${item['unit']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double discount, double total, int totalItems) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($totalItems items)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '${subtotal.toStringAsFixed(0)} TZS',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppTheme.successGreen,
                  ),
                ),
                Text(
                  '-${discount.toStringAsFixed(0)} TZS',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${total.toStringAsFixed(0)} TZS',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _checkout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_checkout, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Proceed to Checkout',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'seeds':
        return Icons.grass;
      case 'fertilizers':
        return Icons.eco;
      case 'pesticides':
        return Icons.bug_report;
      case 'equipment':
        return Icons.build;
      case 'livestock':
        return Icons.pets;
      case 'poultry':
        return Icons.egg;
      case 'fisheries':
        return Icons.water;
      default:
        return Icons.inventory;
    }
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = _cartItems[index]['quantity'] + change;
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  void _checkout() {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Checkout functionality coming soon!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
} 