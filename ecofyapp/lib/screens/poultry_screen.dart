import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import 'product_details_screen.dart';

class PoultryScreen extends StatefulWidget {
  const PoultryScreen({Key? key}) : super(key: key);

  @override
  State<PoultryScreen> createState() => _PoultryScreenState();
}

class _PoultryScreenState extends State<PoultryScreen> {
  String? _selectedPoultryType;
  String? _selectedLocation;
  String? _selectedRegion;
  String _searchQuery = '';
  
  final List<String> _poultryTypes = ['Chickens', 'Ducks', 'Turkeys', 'Geese', 'Quails', 'Guinea Fowls', 'Pigeons'];
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
                        hintText: 'Search poultry...',
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
            
            // Products Grid
            Expanded(
              child: _getFilteredProducts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('All'),
        ),
        ...items.map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        )),
      ],
      onChanged: onChanged,
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
                        'Poultry Type',
                        _selectedPoultryType,
                        _poultryTypes,
                        (value) {
                          setState(() {
                            _selectedPoultryType = value;
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
                          _selectedPoultryType = null;
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

  Widget _getFilteredProducts() {
    final List<Map<String, dynamic>> poultryData = [
      {
        'name': 'Broiler Chickens',
        'price': 15000,
        'quantity': '3kg',
        'grade': 'Grade A',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'image': '🐔',
      },
      {
        'name': 'Layer Chickens',
        'price': 12000,
        'quantity': '2.5kg',
        'grade': 'Grade B',
        'region': 'Arusha',
        'district': 'Arusha City',
        'image': '🐓',
      },
      {
        'name': 'Ducks',
        'price': 18000,
        'quantity': '4kg',
        'grade': 'Premium',
        'region': 'Mwanza',
        'district': 'Ilemela',
        'image': '🦆',
      },
      {
        'name': 'Turkeys',
        'price': 25000,
        'quantity': '8kg',
        'grade': 'Grade A',
        'region': 'Dodoma',
        'district': 'Dodoma City',
        'image': '🦃',
      },
      {
        'name': 'Geese',
        'price': 22000,
        'quantity': '6kg',
        'grade': 'Standard',
        'region': 'Tanga',
        'district': 'Tanga City',
        'image': '🦢',
      },
      {
        'name': 'Quails',
        'price': 30000,
        'quantity': '0.5kg',
        'grade': 'Premium',
        'region': 'Mbeya',
        'district': 'Mbeya City',
        'image': '🐦',
      },
      {
        'name': 'Guinea Fowls',
        'price': 20000,
        'quantity': '2kg',
        'grade': 'Grade B',
        'region': 'Morogoro',
        'district': 'Morogoro City',
        'image': '🦃',
      },
      {
        'name': 'Pigeons',
        'price': 15000,
        'quantity': '1kg',
        'grade': 'Standard',
        'region': 'Kilimanjaro',
        'district': 'Moshi',
        'image': '🕊️',
      },
    ];

    // Filter the data based on selected filters and search query
    List<Map<String, dynamic>> filteredData = poultryData.where((product) {
      bool matchesSearch = _searchQuery.isEmpty || 
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesType = _selectedPoultryType == null || 
          product['name'].toString().toLowerCase().contains(_selectedPoultryType!.toLowerCase());
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
            'No poultry found',
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
                        onTap: () => _addToCart(product),
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
    if (quantity == null) return 'unit';
    if (quantity.contains('per')) {
      return quantity.split('per')[1].trim();
    }
    return quantity;
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name'] ?? 'Product'} added to cart'),
        backgroundColor: AppTheme.primaryGreen,
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