import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import '../data/tanzania_crops.dart';
import 'product_details_screen.dart';
import 'crops_page.dart';
import 'livestock_screen.dart';
import 'poultry_screen.dart';
import 'fisheries_screen.dart';
import 'seeds_screen.dart';
import 'fertilizers_screen.dart';
import 'pesticides_screen.dart';
import 'equipment_screen.dart';
import 'all_products_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _activeTab = 'all-products';
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;
  
  // Sorting variables for crops
  String? _selectedCropName;
  String? _selectedGrade;
  String? _selectedLocation;
  String? _selectedRegion;
  
  final List<String> _cropNames = TanzaniaCrops.getCropNames();
  final List<String> _grades = ['Grade A', 'Grade B', 'Grade C', 'Premium', 'Standard'];
  final List<String> _regions = TanzaniaRegions.getRegionNames();
  List<String> _districts = [];

  final List<Map<String, String>> _mainTabs = [
    {'id': 'all-products', 'label': 'All Products'},
    {'id': 'crops', 'label': 'Crops'},
    {'id': 'livestock', 'label': 'Livestock'},
    {'id': 'poultry', 'label': 'Poultry'},
    {'id': 'fisheries', 'label': 'Fisheries'},
    {'id': 'seeds', 'label': 'Seeds'},
    {'id': 'fertilizers', 'label': 'Fertilizers'},
    {'id': 'pesticides', 'label': 'Pesticides'},
    {'id': 'equipment', 'label': 'Equipment'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiService.getProducts();
      setState(() {
        _products = List<Map<String, dynamic>>.from(data['items'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildMainTabButton(String id, String label) {
    final isSelected = _activeTab == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: product['images'] != null && (product['images'] as List).isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    child: Image.network(
                      product['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 50, color: Colors.grey);
                      },
                    ),
                  )
                : const Icon(Icons.image, size: 50, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Unknown Product',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product['price']?.toString() ?? '0'} TZS/${product['unit'] ?? 'unit'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['location'] ?? 'Unknown Location',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Failed to load products',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Products will be loaded from the backend API',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_products[index]);
      },
    );
  }

  Widget _buildCategoryView() {
    if (_activeTab == 'all-products') {
      return const AllProductsScreen();
    } else if (_activeTab == 'crops') {
      return const CropsPage(selectedCrop: '');
    } else if (_activeTab == 'livestock') {
      return const LivestockScreen();
    } else if (_activeTab == 'poultry') {
      return const PoultryScreen();
    } else if (_activeTab == 'fisheries') {
      return const FisheriesScreen();
    } else if (_activeTab == 'seeds') {
      return const SeedsScreen();
    } else if (_activeTab == 'fertilizers') {
      return const FertilizersScreen();
    } else if (_activeTab == 'pesticides') {
      return const PesticidesScreen();
    } else if (_activeTab == 'equipment') {
      return const EquipmentScreen();
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category, color: AppTheme.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                _mainTabs.firstWhere((tab) => tab['id'] == _activeTab)['label']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Products in this category will be displayed here.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSortingDropdown(String label, String? selectedValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              hint: Text(
                'All',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 18,
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                ...options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundLight,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main tabs
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mainTabs.length,
                    itemBuilder: (context, index) {
                      final tab = _mainTabs[index];
                      return _buildMainTabButton(tab['id']!, tab['label']!);
                    },
                  ),
                ),

              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildCategoryView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => _navigateToProductDetails(product),
      child: Container(
            decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: 220,
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product['image'],
                      style: const TextStyle(fontSize: 100),
                  ),
                ),
                ),
                
                // Grade badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      product['grade'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Crop name
                    Text(
                      product['name'],
                                          style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    
                    // Price
                    Text(
                      '${product['price']} TZS/${_extractUnit(product['quantity'])}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const Spacer(),
                    
                    // Cart icon at bottom right
                    Align(
                      alignment: Alignment.bottomRight,
                                              child: Container(
                          width: 32,
                          height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: product['inStock'] ? () => _addToCart(product) : null,
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 16,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
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

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'Premium':
        return Colors.purple;
      case 'Grade A':
        return Colors.green;
      case 'Grade B':
        return Colors.orange;
      case 'Grade C':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
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

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            product['image'],
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Product name and rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${product['rating']} (${product['reviews']} reviews)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Price
                    Row(
                      children: [
                        Text(
                          '${product['price']} TZS',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        if (product['originalPrice'] > product['price']) ...[
                          const SizedBox(width: 12),
                          Text(
                            '${product['originalPrice']} TZS',
                            style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Product details
                    _buildDetailRow('Quantity', product['quantity']),
                    _buildDetailRow('Grade', product['grade']),
                    _buildDetailRow('Location', '${product['district']}, ${product['region']}'),
                    _buildDetailRow('Seller', product['seller']),
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: product['inStock'] ? () {
                              Navigator.pop(context);
                              _addToCart(product);
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _contactSeller(product),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Contact Seller',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  void _contactSeller(Map<String, dynamic> product) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${product['seller']}...'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  String _extractUnit(String quantity) {
    // Extract unit from quantity like "50kg" -> "kg", "100kg" -> "kg"
    if (quantity.contains('kg')) return 'kg';
    if (quantity.contains('g')) return 'g';
    if (quantity.contains('ton')) return 'ton';
    if (quantity.contains('lb')) return 'lb';
    if (quantity.contains('piece')) return 'piece';
    if (quantity.contains('dozen')) return 'dozen';
    return 'unit';
  }

  void _navigateToProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }
} 