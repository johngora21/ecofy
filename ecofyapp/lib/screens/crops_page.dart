import 'package:flutter/material.dart';
import '../data/tanzania_crops.dart';
import '../data/tanzania_regions.dart';

class CropsPage extends StatefulWidget {
  final String selectedCrop;

  const CropsPage({Key? key, required this.selectedCrop}) : super(key: key);

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  String? _selectedCropName;
  String? _selectedGrade;
  String? _selectedRegion;
  String? _selectedDistrict;
  
  List<String> _cropNames = TanzaniaCrops.getCropNames();
  List<String> _regions = TanzaniaRegions.getRegionNames();
  List<String> _districts = [];
  List<String> _grades = ['Grade A', 'Grade B', 'Grade C', 'Premium', 'Standard'];

  // Mock product data with better structure
  List<Map<String, dynamic>> _products = [
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

  @override
  void initState() {
    super.initState();
    _selectedCropName = widget.selectedCrop.isNotEmpty ? widget.selectedCrop : null;
  }

  void _onRegionChanged(String? region) {
    setState(() {
      _selectedRegion = region;
      _selectedDistrict = null;
      if (region != null) {
        _districts = TanzaniaRegions.getDistrictNames(region);
      } else {
        _districts = [];
      }
    });
  }

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      bool matchesCrop = _selectedCropName == null || 
          product['name'].toString().toLowerCase().contains(_selectedCropName!.toLowerCase());
      bool matchesGrade = _selectedGrade == null || 
          product['grade'] == _selectedGrade;
      bool matchesRegion = _selectedRegion == null || 
          product['region'] == _selectedRegion;
      bool matchesDistrict = _selectedDistrict == null || 
          product['district'] == _selectedDistrict;
      
      return matchesCrop && matchesGrade && matchesRegion && matchesDistrict;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedCropName = null;
      _selectedGrade = null;
      _selectedRegion = null;
      _selectedDistrict = null;
      _districts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Crops Marketplace'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredProducts.length} products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Filter dropdowns
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Crop',
                        _selectedCropName,
                        _cropNames,
                        (value) => setState(() => _selectedCropName = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        'Grade',
                        _selectedGrade,
                        _grades,
                        (value) => setState(() => _selectedGrade = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Region',
                        _selectedRegion,
                        _regions,
                        _onRegionChanged,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterDropdown(
                        'District',
                        _selectedDistrict,
                        _districts,
                        (value) => setState(() => _selectedDistrict = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Products grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String? value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: Text('All $label'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All'),
              ),
              ...options.map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              )),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildModernProductCard(product);
      },
    );
  }

  Widget _buildModernProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: Center(
                    child: Text(
                      product['image'],
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ),
              
              // Badges
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  children: [
                    if (product['isNew'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (product['discount'] > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product['discount']}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Out of stock overlay
              if (!product['inStock'])
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'OUT OF STOCK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Product details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grade badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getGradeColor(product['grade']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _getGradeColor(product['grade']),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    product['grade'],
                    style: TextStyle(
                      color: _getGradeColor(product['grade']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Product name
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Price
                Row(
                  children: [
                    Text(
                      '${product['price']} TZS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    if (product['originalPrice'] > product['price']) ...[
                      const SizedBox(width: 4),
                      Text(
                        '${product['originalPrice']} TZS',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                
                // Quantity
                Text(
                  product['quantity'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Rating and location
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber[600]),
                    const SizedBox(width: 2),
                    Text(
                      '${product['rating']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${product['district']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: product['inStock'] ? () => _addToCart(product) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        onPressed: () => _showProductDetails(product),
                        icon: Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ],
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

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        backgroundColor: Colors.green[600],
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
                              backgroundColor: Colors.green[600],
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
} 