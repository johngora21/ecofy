import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import 'product_details_screen.dart';

class FisheriesScreen extends StatefulWidget {
  const FisheriesScreen({super.key});

  @override
  State<FisheriesScreen> createState() => _FisheriesScreenState();
}

class _FisheriesScreenState extends State<FisheriesScreen> {
  String? _selectedFishType;
  String? _selectedLocation;
  String? _selectedRegion;
  String _searchQuery = '';
  
  final List<String> _fishTypes = [
    'Tilapia',
    'Nile Perch', 
    'Catfish',
    'Mackerel',
    'Sardines',
    'Tuna',
    'Prawns',
    'Crayfish',
    'Carp',
    'Bream',
    'Kingfish',
    'Red Snapper',
    'Grouper',
    'Barracuda',
    'Mullet',
    'Pomfret',
    'Threadfin',
    'Croaker',
    'Grunter',
    'Emperor',
    'Trevally',
    'Bonito',
    'Skipjack',
    'Yellowfin Tuna',
    'Albacore',
    'Bigeye Tuna',
    'Mahi Mahi',
    'Wahoo',
    'Sailfish',
    'Marlin',
    'Dorado',
    'Amberjack',
    'Lobster',
    'Crab',
    'Oysters',
    'Mussels',
    'Clams',
    'Sea Urchin',
    'Octopus',
    'Squid',
    'Cuttlefish'
  ];
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
                        hintText: 'Search fisheries...',
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
    List<Map<String, dynamic>> fisheriesData = [
      {
        'id': '1',
        'name': 'Fresh Tilapia',
        'grade': 'Grade A',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 8500,
        'originalPrice': 9000,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh tilapia from Lake Victoria, perfect for cooking',
        'seller': 'Lake Victoria Fisheries',
        'rating': 4.8,
        'reviews': 56,
        'inStock': true,
        'isNew': true,
        'discount': 6,
      },
      {
        'id': '2',
        'name': 'Nile Perch Fillets',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 12000,
        'originalPrice': 12000,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Premium Nile perch fillets, excellent quality',
        'seller': 'Dar Seafood Co.',
        'rating': 4.9,
        'reviews': 42,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      {
        'id': '3',
        'name': 'Catfish',
        'grade': 'Grade B',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 6500,
        'originalPrice': 7500,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh catfish, suitable for various dishes',
        'seller': 'Arusha Fish Farm',
        'rating': 4.5,
        'reviews': 28,
        'inStock': true,
        'isNew': false,
        'discount': 13,
      },
      {
        'id': '4',
        'name': 'Mackerel',
        'grade': 'Grade A',
        'region': 'Tanga',
        'district': 'Tanga City',
        'price': 9500,
        'originalPrice': 9500,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh mackerel from the Indian Ocean',
        'seller': 'Tanga Coastal Fish',
        'rating': 4.6,
        'reviews': 35,
        'inStock': false,
        'isNew': true,
        'discount': 0,
      },
      {
        'id': '5',
        'name': 'Sardines',
        'grade': 'Standard',
        'region': 'Zanzibar',
        'district': 'Stone Town',
        'price': 4500,
        'originalPrice': 5500,
        'quantity': '1kg',
        'image': '🐟',
        'description': 'Fresh sardines, perfect for grilling',
        'seller': 'Zanzibar Seafood',
        'rating': 4.3,
        'reviews': 19,
        'inStock': true,
        'isNew': false,
        'discount': 18,
      },
      {
        'id': '6',
        'name': 'Fresh Prawns',
        'grade': 'Premium',
        'region': 'Pwani',
        'district': 'Bagamoyo',
        'price': 18000,
        'originalPrice': 18000,
        'quantity': '1kg',
        'image': '🦐',
        'description': 'Large fresh prawns, excellent for seafood dishes',
        'seller': 'Pwani Prawns',
        'rating': 4.7,
        'reviews': 31,
        'inStock': true,
        'isNew': true,
        'discount': 0,
      },
    ];

        // Filter the data based on selected filters
    List<Map<String, dynamic>> filteredData = fisheriesData.where((product) {
      bool matchesSearch = _searchQuery.isEmpty || 
          product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesType = _selectedFishType == null || 
          product['name'].toString().toLowerCase().contains(_selectedFishType!.toLowerCase());
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
            'No fish found',
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
                        'Fish Type',
                        _selectedFishType,
                        _fishTypes,
                        (value) {
                          setState(() {
                            _selectedFishType = value;
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
                          _selectedFishType = null;
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