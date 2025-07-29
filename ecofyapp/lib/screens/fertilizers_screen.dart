import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import 'product_details_screen.dart';

class FertilizersScreen extends StatefulWidget {
  const FertilizersScreen({super.key});

  @override
  State<FertilizersScreen> createState() => _FertilizersScreenState();
}

class _FertilizersScreenState extends State<FertilizersScreen> {
  String? _selectedFertilizerType;
  String? _selectedLocation;
  String? _selectedRegion;
  String _searchQuery = '';
  
  final List<String> _fertilizerTypes = ['NPK', 'Urea', 'DAP', 'CAN', 'Organic', 'Compost', 'Manure', 'Lime'];
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
                        hintText: 'Search fertilizers...',
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

  Widget _buildProductGrid() {
    List<Map<String, dynamic>> fertilizersData = [
      {
        'id': '1',
        'name': 'NPK 20-20-20',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 85000,
        'originalPrice': 90000,
        'quantity': '50kg',
        'image': '🌱',
        'description': 'Balanced NPK fertilizer, suitable for most crops',
        'seller': 'Arusha Fertilizer Co.',
        'rating': 4.8,
        'reviews': 45,
        'inStock': true,
        'isNew': true,
        'discount': 6,
      },
      {
        'id': '2',
        'name': 'Urea 46-0-0',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 65000,
        'originalPrice': 65000,
        'quantity': '50kg',
        'image': '🌱',
        'description': 'High nitrogen urea fertilizer for leafy growth',
        'seller': 'Dar Fertilizer Ltd',
        'rating': 4.7,
        'reviews': 38,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      {
        'id': '3',
        'name': 'DAP 18-46-0',
        'grade': 'Grade B',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 75000,
        'originalPrice': 85000,
        'quantity': '50kg',
        'image': '🌱',
        'description': 'Phosphate-rich fertilizer for root development',
        'seller': 'Morogoro Agro',
        'rating': 4.5,
        'reviews': 29,
        'inStock': true,
        'isNew': false,
        'discount': 12,
      },
      {
        'id': '4',
        'name': 'Organic Compost',
        'grade': 'Grade A',
        'region': 'Kilimanjaro',
        'district': 'Moshi',
        'price': 25000,
        'originalPrice': 25000,
        'quantity': '25kg',
        'image': '🌱',
        'description': 'Natural organic compost, improves soil structure',
        'seller': 'Kilimanjaro Organic',
        'rating': 4.6,
        'reviews': 52,
        'inStock': false,
        'isNew': true,
        'discount': 0,
      },
      {
        'id': '5',
        'name': 'CAN 27-0-0',
        'grade': 'Standard',
        'region': 'Dodoma',
        'district': 'Dodoma City',
        'price': 55000,
        'originalPrice': 65000,
        'quantity': '50kg',
        'image': '🌱',
        'description': 'Calcium ammonium nitrate, good for vegetables',
        'seller': 'Dodoma Fertilizer',
        'rating': 4.3,
        'reviews': 21,
        'inStock': true,
        'isNew': false,
        'discount': 15,
      },
      {
        'id': '6',
        'name': 'Lime Powder',
        'grade': 'Premium',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 35000,
        'originalPrice': 35000,
        'quantity': '25kg',
        'image': '🌱',
        'description': 'Agricultural lime for soil pH correction',
        'seller': 'Mwanza Lime Co.',
        'rating': 4.9,
        'reviews': 34,
        'inStock': true,
        'isNew': true,
        'discount': 0,
      },
    ];

        // Filter the data based on selected filters
    List<Map<String, dynamic>> filteredData = fertilizersData.where((product) {
      bool matchesSearch = _searchQuery.isEmpty || 
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesType = _selectedFertilizerType == null || 
          product['name'].toString().toLowerCase().contains(_selectedFertilizerType!.toLowerCase());
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
            'No fertilizers found',
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
    if (quantity.contains('kg')) return 'kg';
    if (quantity.contains('g')) return 'g';
    if (quantity.contains('piece')) return 'piece';
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
                    'Filter Products',
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
                    children: [
                      _buildSortingDropdown(
                        'Fertilizer Type',
                        _selectedFertilizerType,
                        _fertilizerTypes,
                        (value) {
                          setState(() {
                            _selectedFertilizerType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
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
                          _selectedFertilizerType = null;
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
} 