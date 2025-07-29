import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import 'product_details_screen.dart';

class LivestockScreen extends StatefulWidget {
  const LivestockScreen({super.key});

  @override
  State<LivestockScreen> createState() => _LivestockScreenState();
}

class _LivestockScreenState extends State<LivestockScreen> {
  String? _selectedLivestockType;
  String? _selectedLocation;
  String? _selectedRegion;
  String _searchQuery = '';
  
  final List<String> _livestockTypes = ['Cattle', 'Goats', 'Sheep', 'Pigs', 'Rabbits', 'Horses', 'Donkeys'];
  final List<String> _regions = TanzaniaRegions.getRegionNames();
  List<String> _districts = [];

  @override
  void initState() {
    super.initState();
    _districts = TanzaniaRegions.getAllDistrictNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Filter Icon
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search livestock...',
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
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showFilterModal(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
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

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSortingDropdown(
                        'Livestock Type',
                        _selectedLivestockType,
                        _livestockTypes,
                        (value) {
                          setState(() {
                            _selectedLivestockType = value;
                          });
                        },
                      ),

                      _buildSortingDropdown(
                        'Region',
                        _selectedRegion,
                        _regions,
                        (value) {
                          setState(() {
                            _selectedRegion = value;
                            if (value != null) {
                              _districts = TanzaniaRegions.getDistrictNames(value);
                            } else {
                              _districts = TanzaniaRegions.getAllDistrictNames();
                            }
                            _selectedLocation = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSortingDropdown(
                        'District',
                        _selectedLocation,
                        _districts,
                        (value) {
                          setState(() {
                            _selectedLocation = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedLivestockType = null;
                          _selectedLocation = null;
                          _selectedRegion = null;
                          _districts = TanzaniaRegions.getAllDistrictNames();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    List<Map<String, dynamic>> livestockData = [
      {
        'id': '1',
        'name': 'Young Bull',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 850000,
        'originalPrice': 900000,
        'quantity': '450kg',
        'image': '🐂',
        'description': 'Healthy young bull, perfect for breeding or meat production',
        'seller': 'Arusha Livestock Co.',
        'rating': 4.8,
        'reviews': 15,
        'inStock': true,
        'isNew': true,
        'discount': 6,
      },
      {
        'id': '2',
        'name': 'Dairy Cow',
        'grade': 'Premium',
        'region': 'Kilimanjaro',
        'district': 'Moshi',
        'price': 1200000,
        'originalPrice': 1200000,
        'quantity': '500kg',
        'image': '🐄',
        'description': 'High-yield dairy cow, excellent milk production',
        'seller': 'Kilimanjaro Dairy',
        'rating': 4.9,
        'reviews': 23,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      {
        'id': '3',
        'name': 'Goat Herd',
        'grade': 'Grade B',
        'region': 'Dodoma',
        'district': 'Dodoma City',
        'price': 450000,
        'originalPrice': 500000,
        'quantity': '25kg',
        'image': '🐐',
        'description': 'Healthy goat herd, suitable for meat and milk',
        'seller': 'Dodoma Goat Farm',
        'rating': 4.5,
        'reviews': 12,
        'inStock': true,
        'isNew': false,
        'discount': 10,
      },
      {
        'id': '4',
        'name': 'Sheep Flock',
        'grade': 'Grade A',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 380000,
        'originalPrice': 380000,
        'quantity': '40kg',
        'image': '🐑',
        'description': 'Quality sheep flock, excellent for wool and meat',
        'seller': 'Mwanza Sheep Co.',
        'rating': 4.6,
        'reviews': 18,
        'inStock': false,
        'isNew': true,
        'discount': 0,
      },
      {
        'id': '5',
        'name': 'Pig Breeding Pair',
        'grade': 'Standard',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 280000,
        'originalPrice': 320000,
        'quantity': '120kg',
        'image': '🐷',
        'description': 'Healthy breeding pair, ready for pig farming',
        'seller': 'Morogoro Pigs',
        'rating': 4.3,
        'reviews': 9,
        'inStock': true,
        'isNew': false,
        'discount': 13,
      },
      {
        'id': '6',
        'name': 'Chicken Layers',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 150000,
        'originalPrice': 150000,
        'quantity': '75kg',
        'image': '🐔',
        'description': 'High-yield laying hens, excellent egg production',
        'seller': 'Dar Poultry Farm',
        'rating': 4.7,
        'reviews': 31,
        'inStock': true,
        'isNew': true,
        'discount': 0,
      },
    ];

    // Filter the data based on selected filters and search query
    List<Map<String, dynamic>> filteredData = livestockData.where((product) {
      bool matchesSearch = _searchQuery.isEmpty || 
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesType = _selectedLivestockType == null || 
          product['name'].toString().toLowerCase().contains(_selectedLivestockType!.toLowerCase());
      bool matchesRegion = _selectedRegion == null || 
          product['region'] == _selectedRegion;
      bool matchesDistrict = _selectedLocation == null || 
          product['district'] == _selectedLocation;
      
      return matchesSearch && matchesType && matchesRegion && matchesDistrict;
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
            'No livestock found',
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
                          product['name'] ?? 'Unknown Product',
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
                          '${product['price'] ?? 0} TZS',
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
                        onTap: (product['inStock'] ?? false) ? () => _addToCart(product) : null,
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

  String _extractUnit(String? quantity) {
    return quantity ?? 'unit';
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name'] ?? 'Product'} added to cart'),
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