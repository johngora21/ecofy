import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/theme/app_theme.dart';
import '../data/tanzania_regions.dart';
import '../data/tanzania_crops.dart';
import 'product_details_screen.dart';

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
        childAspectRatio: 0.75,
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
    if (_activeTab == 'crops') {
      return _buildCropsView();
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

  Widget _buildCropsView() {
    // Mock product data for crops
    List<Map<String, dynamic>> cropsData = [
      {
        'id': '1',
        'name': 'Fresh Tomatoes',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 2500,
        'originalPrice': 3000,
        'quantity': '50kg',
        'image': '🍅',
        'description': 'Fresh red tomatoes, perfect for cooking and salads',
        'seller': 'Mama Farm',
        'rating': 4.5,
        'reviews': 23,
        'inStock': true,
        'isNew': true,
        'discount': 17,
      },
      {
        'id': '2',
        'name': 'Premium Maize Grains',
        'grade': 'Premium',
        'region': 'Dodoma',
        'district': 'Dodoma City',
        'price': 1800,
        'originalPrice': 1800,
        'quantity': '100kg',
        'image': '🌽',
        'description': 'High-quality maize grains, suitable for various uses',
        'seller': 'Dodoma Farmers Coop',
        'rating': 4.8,
        'reviews': 45,
        'inStock': true,
        'isNew': false,
        'discount': 0,
      },
      {
        'id': '3',
        'name': 'Irish Potatoes',
        'grade': 'Grade B',
        'region': 'Kilimanjaro',
        'district': 'Moshi',
        'price': 3200,
        'originalPrice': 3800,
        'quantity': '75kg',
        'image': '🥔',
        'description': 'Fresh potatoes from the slopes of Kilimanjaro',
        'seller': 'Kilimanjaro Fresh',
        'rating': 4.2,
        'reviews': 18,
        'inStock': true,
        'isNew': false,
        'discount': 16,
      },
      {
        'id': '4',
        'name': 'Sweet Bananas',
        'grade': 'Grade A',
        'region': 'Kagera',
        'district': 'Bukoba',
        'price': 1500,
        'originalPrice': 1500,
        'quantity': '60kg',
        'image': '🍌',
        'description': 'Sweet bananas from the lake region',
        'seller': 'Lake Region Fruits',
        'rating': 4.6,
        'reviews': 32,
        'inStock': false,
        'isNew': true,
        'discount': 0,
      },
      {
        'id': '5',
        'name': 'Fresh Cassava Roots',
        'grade': 'Standard',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 1200,
        'originalPrice': 1500,
        'quantity': '80kg',
        'image': '🥔',
        'description': 'Fresh cassava roots, perfect for traditional dishes',
        'seller': 'Mwanza Roots',
        'rating': 4.0,
        'reviews': 15,
        'inStock': true,
        'isNew': false,
        'discount': 20,
      },
      {
        'id': '6',
        'name': 'Organic Sweet Potatoes',
        'grade': 'Premium',
        'region': 'Morogoro',
        'district': 'Morogoro Urban',
        'price': 2800,
        'originalPrice': 2800,
        'quantity': '65kg',
        'image': '🍠',
        'description': 'Organic sweet potatoes, rich in nutrients',
        'seller': 'Organic Morogoro',
        'rating': 4.7,
        'reviews': 28,
        'inStock': true,
        'isNew': true,
        'discount': 0,
      },
    ];

    // Filter the data based on selected filters
    List<Map<String, dynamic>> filteredData = cropsData.where((product) {
      bool matchesCrop = _selectedCropName == null || 
          product['name'].toString().toLowerCase().contains(_selectedCropName!.toLowerCase());
      bool matchesGrade = _selectedGrade == null || 
          product['grade'] == _selectedGrade;
      bool matchesRegion = _selectedRegion == null || 
          product['region'] == _selectedRegion;
      bool matchesDistrict = _selectedLocation == null || 
          product['district'] == _selectedLocation;
      
      return matchesCrop && matchesGrade && matchesRegion && matchesDistrict;
    }).toList();

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
        // Sorting Dropdowns
        Row(
          children: [
            Expanded(
              child: _buildSortingDropdown(
                'Crop Name',
                _selectedCropName,
                _cropNames,
                (value) {
                  setState(() {
                    _selectedCropName = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSortingDropdown(
                'Grade',
                _selectedGrade,
                _grades,
                (value) {
                  setState(() {
                    _selectedGrade = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSortingDropdown(
                'Region',
                _selectedRegion,
                _regions,
                (value) {
                  setState(() {
                    _selectedRegion = value;
                    if (value != null) {
                      _districts = TanzaniaRegions.getDistrictNames(value);
                    } else {
                      _districts = [];
                    }
                    _selectedLocation = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSortingDropdown(
                'District',
                _selectedLocation,
                _districts,
                (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Clear Filters Button
        if (_selectedCropName != null || _selectedGrade != null || _selectedLocation != null || _selectedRegion != null)
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCropName = null;
                  _selectedGrade = null;
                  _selectedLocation = null;
                  _selectedRegion = null;
                  _districts = [];
                });
              },
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        
        // Modern Product Cards Grid
        Expanded(
          child: filteredData.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return _buildModernProductCard(filteredData[index]);
                  },
          ),
        ),
      ],
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

  Widget _buildFilteredCropsList() {
    // Mock filtered data based on selections
    List<Map<String, dynamic>> filteredCrops = [
      {
        'name': 'Maize',
        'grade': 'Grade A',
        'region': 'Arusha',
        'district': 'Arusha City',
        'price': 'TZS 2,500',
        'quantity': '100kg',
        'image': 'assets/images/maize.jpg',
      },
      {
        'name': 'Rice',
        'grade': 'Premium',
        'region': 'Dar es Salaam',
        'district': 'Ilala',
        'price': 'TZS 3,200',
        'quantity': '50kg',
        'image': 'assets/images/rice.jpg',
      },
      {
        'name': 'Beans',
        'grade': 'Grade B',
        'region': 'Mwanza',
        'district': 'Mwanza City',
        'price': 'TZS 1,800',
        'quantity': '75kg',
        'image': 'assets/images/beans.jpg',
      },
      {
        'name': 'Tomato',
        'grade': 'Grade A',
        'region': 'Kilimanjaro',
        'district': 'Moshi Municipal',
        'price': 'TZS 2,000',
        'quantity': '25kg',
        'image': 'assets/images/tomato.jpg',
      },
      {
        'name': 'Irish Potato',
        'grade': 'Premium',
        'region': 'Arusha',
        'district': 'Meru',
        'price': 'TZS 3,500',
        'quantity': '80kg',
        'image': 'assets/images/potato.jpg',
      },
    ];

    // Apply filters
    if (_selectedCropName != null) {
      filteredCrops = filteredCrops.where((crop) => crop['name'] == _selectedCropName).toList();
    }
    if (_selectedGrade != null) {
      filteredCrops = filteredCrops.where((crop) => crop['grade'] == _selectedGrade).toList();
    }
    if (_selectedRegion != null) {
      filteredCrops = filteredCrops.where((crop) => crop['region'] == _selectedRegion).toList();
    }
    if (_selectedLocation != null) {
      filteredCrops = filteredCrops.where((crop) => crop['district'] == _selectedLocation).toList();
    }

    if (filteredCrops.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No crops found with selected filters',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCrops.length,
      itemBuilder: (context, index) {
        final crop = filteredCrops[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.agriculture,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            title: Text(
              crop['name'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${crop['grade']} • ${crop['region']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${crop['district']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${crop['quantity']} • ${crop['price']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
        );
      },
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
              child: _activeTab == 'all-products'
                  ? _buildProductGrid()
                  : _buildCategoryView(),
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
                    '${product['price']} TZS/${_extractUnit(product['quantity'])}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const Spacer(),
                  
                  // Cart icon at bottom right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 26,
                      height: 26,
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
                          size: 13,
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