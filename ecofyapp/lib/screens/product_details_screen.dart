import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.product['name'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.primaryGreen.withOpacity(0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.product['image'],
                      style: const TextStyle(fontSize: 120),
                    ),
                  ),
                  
                  // Grade badge
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.product['grade'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Discount badge
                  if ((widget.product['discount'] ?? 0) > 0)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${widget.product['discount']}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Product Details Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Rating
                  Row(
                    children: [
                      Expanded(
                        child:                         Text(
                          widget.product['name'] ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 20),
                          const SizedBox(width: 4),
                                                  Text(
                          '${widget.product['rating'] ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                          const SizedBox(width: 4),
                                                  Text(
                          '(${widget.product['reviews'] ?? 0} reviews)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Price Section
                  Row(
                    children: [
                                              Text(
                          '${widget.product['price'] ?? 0} TZS',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      if ((widget.product['originalPrice'] ?? 0) > (widget.product['price'] ?? 0)) ...[
                        const SizedBox(width: 12),
                        Text(
                          '${widget.product['originalPrice'] ?? 0} TZS',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                                          Text(
                          'Per ${_extractUnit(widget.product['quantity'] ?? 'unit')}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                  const SizedBox(height: 24),
                  
                  // Product Information
                  _buildInfoSection('Description', widget.product['description'] ?? 'No description available'),
                  const SizedBox(height: 20),
                  
                  _buildInfoRow('Seller', widget.product['seller'] ?? 'Unknown Seller'),
                  _buildInfoRow('Location', '${widget.product['district'] ?? 'Unknown'}, ${widget.product['region'] ?? 'Unknown'}'),
                  _buildInfoRow('Quantity Available', widget.product['quantity'] ?? 'Unknown'),
                  _buildInfoRow('Grade', widget.product['grade'] ?? 'Unknown'),
                  const SizedBox(height: 20),
                  
                  // Quantity Selector
                  _buildQuantitySelector(),
                  const SizedBox(height: 30),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (widget.product['inStock'] ?? false) ? () => _addToCart() : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _contactSeller(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppTheme.primaryGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.message, size: 20, color: AppTheme.primaryGreen),
                              const SizedBox(width: 8),
                              Text(
                                'Contact Seller',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ],
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

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _selectedQuantity > 1 ? () {
                  setState(() {
                    _selectedQuantity--;
                  });
                } : null,
                icon: Icon(Icons.remove, size: 18),
                padding: const EdgeInsets.all(8),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '$_selectedQuantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedQuantity++;
                  });
                },
                icon: Icon(Icons.add, size: 18),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _extractUnit(String? quantity) {
    if (quantity == null) return 'unit';
    if (quantity.contains('kg')) return 'kg';
    if (quantity.contains('g')) return 'g';
    if (quantity.contains('ton')) return 'ton';
    if (quantity.contains('lb')) return 'lb';
    if (quantity.contains('piece')) return 'piece';
    if (quantity.contains('dozen')) return 'dozen';
    return 'unit';
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['name'] ?? 'Product'} added to cart'),
        backgroundColor: AppTheme.primaryGreen,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _contactSeller() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${widget.product['seller'] ?? 'Seller'}...'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
} 