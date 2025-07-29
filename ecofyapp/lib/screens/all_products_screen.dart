import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import 'product_details_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search all products...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Product Cards Grid
            Expanded(
              child: _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildProductGrid() {
    List<Map<String, dynamic>> allProductsData = [
      // Crops
      {
        'id': 'crop_1',
        'name': 'Maize Seeds',
        'category': 'Crops',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 2500,
        'originalPrice': 2800,
        'quantity': '100kg',
        'image': '🌽',
        'description': 'High-quality maize seeds for optimal yield',
        'seller': 'Arusha Seeds Co.',
        'rating': 4.8,
        'reviews': 156,
        'inStock': true,
        'isNew': true,
        'discount': 11,
      },
      {
        'id': 'crop_2',
        'name': 'Rice Seeds',
        'category': 'Crops',
        'grade': 'Premium',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 3200,
        'originalPrice': 3200,
        'quantity': '100kg',
        'image': '🍚',
        'description': 'Premium rice seeds for high yields',
        'seller': 'Morogoro Rice Ltd',
        'rating': 4.7,
        'reviews': 89,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Seeds
      {
        'id': 'seed_1',
        'name': 'Tomato Seeds',
        'category': 'Seeds',
        'grade': 'GMO',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 1500,
        'originalPrice': 1800,
        'quantity': '50g',
        'image': '🍅',
        'description': 'High-yield tomato seeds',
        'seller': 'Dar Seeds Co.',
        'rating': 4.6,
        'reviews': 234,
        'inStock': true,
        'isNew': true,
        'discount': 17,
      },
      {
        'id': 'seed_2',
        'name': 'Beans Seeds',
        'category': 'Seeds',
        'grade': 'Organic',
        'region': 'Kilimanjaro',
        'district': 'Moshi',
        'price': 2200,
        'originalPrice': 2200,
        'quantity': '1kg',
        'image': '🫘',
        'description': 'Organic bean seeds',
        'seller': 'Kilimanjaro Organic',
        'rating': 4.9,
        'reviews': 67,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Fisheries
      {
        'id': 'fish_1',
        'name': 'Tilapia Fish',
        'category': 'Fisheries',
        'grade': 'Grade A',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 8000,
        'originalPrice': 8500,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh tilapia from Lake Victoria',
        'seller': 'Mwanza Fisheries',
        'rating': 4.8,
        'reviews': 123,
        'inStock': true,
        'isNew': true,
        'discount': 6,
      },
      {
        'id': 'fish_2',
        'name': 'Sardines',
        'category': 'Fisheries',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Temeke',
        'price': 12000,
        'originalPrice': 12000,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh sardines from Indian Ocean',
        'seller': 'Dar Ocean Fish',
        'rating': 4.7,
        'reviews': 89,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Fertilizers
      {
        'id': 'fert_1',
        'name': 'NPK Fertilizer',
        'category': 'Fertilizers',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 45000,
        'originalPrice': 50000,
        'quantity': '50kg',
        'image': '🌱',
        'description': 'Balanced NPK fertilizer for all crops',
        'seller': 'Arusha Agro Chem',
        'rating': 4.8,
        'reviews': 67,
        'inStock': true,
        'isNew': true,
        'discount': 10,
      },
      {
        'id': 'fert_2',
        'name': 'Organic Compost',
        'category': 'Fertilizers',
        'grade': 'Organic',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 35000,
        'originalPrice': 35000,
        'quantity': '25kg',
        'image': '🌿',
        'description': 'Natural organic compost',
        'seller': 'Morogoro Organic',
        'rating': 4.9,
        'reviews': 45,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Pesticides
      {
        'id': 'pest_1',
        'name': 'Insecticide Spray',
        'category': 'Pesticides',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 45000,
        'originalPrice': 50000,
        'quantity': '5L',
        'image': '🦗',
        'description': 'Effective insecticide for crop protection',
        'seller': 'Arusha Agro Chem',
        'rating': 4.8,
        'reviews': 67,
        'inStock': true,
        'isNew': true,
        'discount': 10,
      },
      {
        'id': 'pest_2',
        'name': 'Fungicide Powder',
        'category': 'Pesticides',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 35000,
        'originalPrice': 35000,
        'quantity': '1kg',
        'image': '🍄',
        'description': 'Premium fungicide for disease control',
        'seller': 'Dar Pest Control',
        'rating': 4.7,
        'reviews': 45,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Equipment
      {
        'id': 'equip_1',
        'name': 'Mini Tractor',
        'category': 'Equipment',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 8500000,
        'originalPrice': 9000000,
        'quantity': '1 piece',
        'image': '🚜',
        'description': 'Compact tractor perfect for small farms',
        'seller': 'Arusha Machinery Co.',
        'rating': 4.8,
        'reviews': 23,
        'inStock': true,
        'isNew': true,
        'discount': 6,
      },
      {
        'id': 'equip_2',
        'name': 'Irrigation Pump',
        'category': 'Equipment',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 450000,
        'originalPrice': 450000,
        'quantity': '1 piece',
        'image': '💧',
        'description': 'High-capacity irrigation pump system',
        'seller': 'Dar Irrigation Ltd',
        'rating': 4.7,
        'reviews': 18,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      
      // Livestock
      {
        'id': 'live_1',
        'name': 'Dairy Cow',
        'category': 'Livestock',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 2500000,
        'originalPrice': 2800000,
        'quantity': '1 piece',
        'image': '🐄',
        'description': 'High-yield dairy cow',
        'seller': 'Arusha Livestock Co.',
        'rating': 4.8,
        'reviews': 34,
        'inStock': true,
        'isNew': true,
        'discount': 11,
      },
      {
        'id': 'live_2',
        'name': 'Goat',
        'category': 'Livestock',
        'grade': 'Grade B',
        'region': 'Dodoma',
        'district': 'Dodoma City',
        'price': 450000,
        'originalPrice': 500000,
        'quantity': '1 piece',
        'image': '🐐',
        'description': 'Healthy goat for breeding',
        'seller': 'Dodoma Livestock',
        'rating': 4.5,
        'reviews': 28,
        'inStock': true,
        'isNew': false,
        'discount': 10,
      },
      
      // Poultry
      {
        'id': 'poul_1',
        'name': 'Layer Chicken',
        'category': 'Poultry',
        'grade': 'Grade A',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 25000,
        'originalPrice': 28000,
        'quantity': '1 piece',
        'image': '🐔',
        'description': 'High-yield layer chicken',
        'seller': 'Dar Poultry Co.',
        'rating': 4.7,
        'reviews': 56,
        'inStock': true,
        'isNew': true,
        'discount': 11,
      },
      {
        'id': 'poul_2',
        'name': 'Broiler Chicken',
        'category': 'Poultry',
        'grade': 'Grade B',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 18000,
        'originalPrice': 20000,
        'quantity': '1 piece',
        'image': '🐓',
        'description': 'Fast-growing broiler chicken',
        'seller': 'Morogoro Poultry',
        'rating': 4.6,
        'reviews': 42,
        'inStock': true,
        'isNew': false,
        'discount': 10,
      },
    ];

    // Filter the data based on search query only
    List<Map<String, dynamic>> filteredData = allProductsData.where((product) {
      bool matchesSearch = _searchQuery.isEmpty || 
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesSearch;
    }).toList();

    if (filteredData.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return _buildModernProductCard(filteredData[index]);
      },
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
            'Try adjusting your search or filters',
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
      behavior: HitTestBehavior.opaque,
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
                  height: 160,
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
                      style: const TextStyle(fontSize: 70),
                    ),
                  ),
                ),
                
                // Category badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      product['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Grade badge - only show for Seeds and Crops
                if (product['category'] == 'Seeds' || product['category'] == 'Crops')
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
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        
                        // Price
                        Text(
                          '${product['price']} TZS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Unit
                        Text(
                          _extractUnit(product['quantity']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Cart icon positioned at bottom right corner
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 4),
                      child: GestureDetector(
                        onTap: product['inStock'] ? () => _addToCart(product) : null,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryGreen.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractUnit(String quantity) {
    if (quantity.contains('piece')) return 'piece';
    if (quantity.contains('set')) return 'set';
    if (quantity.contains('kg')) return 'kg';
    if (quantity.contains('g')) return 'g';
    if (quantity.contains('L')) return 'L';
    if (quantity.contains('ton')) return 'ton';
    if (quantity.contains('lb')) return 'lb';
    if (quantity.contains('dozen')) return 'dozen';
    return 'unit';
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

  void _navigateToProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }
} 