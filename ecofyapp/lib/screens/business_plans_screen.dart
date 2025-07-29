import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class BusinessPlansScreen extends StatefulWidget {
  const BusinessPlansScreen({super.key});

  @override
  State<BusinessPlansScreen> createState() => _BusinessPlansScreenState();
}

class _BusinessPlansScreenState extends State<BusinessPlansScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedType = 'All';

  final List<String> _categories = [
    'All',
    'Crop Farming',
    'Livestock',
    'Poultry',
    'Fisheries',
    'Mixed Farming',
    'Agribusiness',
  ];

  final List<String> _types = [
    'All',
    'Template',
    'Sample',
    'Guide',
    'Toolkit',
  ];

  final List<Map<String, dynamic>> _businessPlans = [
    {
      'id': '1',
      'title': 'Farm Business Plan Template',
      'description': 'Complete template for agricultural business planning with financial projections and market analysis.',
      'category': 'Crop Farming',
      'type': 'Template',
      'author': 'Business Development',
      'year': '2024',
      'pages': 45,
      'rating': 4.7,
      'reviews': 89,
      'cover': 'assets/images/plan1.jpg',
      'isFree': false,
      'price': '25,000 TZS',
      'downloads': 234,
    },
    {
      'id': '2',
      'title': 'Financial Planning Guide',
      'description': 'Comprehensive guide to financial management for farmers including budgeting and investment strategies.',
      'category': 'Agribusiness',
      'type': 'Guide',
      'author': 'Agricultural Finance',
      'year': '2023',
      'pages': 38,
      'rating': 4.5,
      'reviews': 156,
      'cover': 'assets/images/plan2.jpg',
      'isFree': true,
      'price': 'Free',
      'downloads': 567,
    },
    {
      'id': '3',
      'title': 'Livestock Business Plan',
      'description': 'Detailed business plan template specifically designed for livestock farming operations.',
      'category': 'Livestock',
      'type': 'Template',
      'author': 'Livestock Development',
      'year': '2024',
      'pages': 52,
      'rating': 4.6,
      'reviews': 78,
      'cover': 'assets/images/plan3.jpg',
      'isFree': false,
      'price': '30,000 TZS',
      'downloads': 189,
    },
    {
      'id': '4',
      'title': 'Poultry Farming Toolkit',
      'description': 'Complete toolkit for starting and managing a successful poultry farming business.',
      'category': 'Poultry',
      'type': 'Toolkit',
      'author': 'Poultry Institute',
      'year': '2024',
      'pages': 65,
      'rating': 4.8,
      'reviews': 203,
      'cover': 'assets/images/plan4.jpg',
      'isFree': false,
      'price': '40,000 TZS',
      'downloads': 145,
    },
    {
      'id': '5',
      'title': 'Fisheries Business Sample',
      'description': 'Sample business plan for fish farming operations with market analysis and cost projections.',
      'category': 'Fisheries',
      'type': 'Sample',
      'author': 'Fisheries Department',
      'year': '2023',
      'pages': 41,
      'rating': 4.4,
      'reviews': 92,
      'cover': 'assets/images/plan5.jpg',
      'isFree': true,
      'price': 'Free',
      'downloads': 312,
    },
    {
      'id': '6',
      'title': 'Mixed Farming Business Plan',
      'description': 'Comprehensive business plan for mixed farming operations combining crops and livestock.',
      'category': 'Mixed Farming',
      'type': 'Template',
      'author': 'Agricultural Extension',
      'year': '2024',
      'pages': 58,
      'rating': 4.6,
      'reviews': 134,
      'cover': 'assets/images/plan6.jpg',
      'isFree': false,
      'price': '35,000 TZS',
      'downloads': 167,
    },
  ];

  List<Map<String, dynamic>> get _filteredPlans {
    return _businessPlans.where((plan) {
      final matchesSearch = plan['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          plan['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          plan['author'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || plan['category'] == _selectedCategory;
      final matchesType = _selectedType == 'All' || plan['type'] == _selectedType;
      
      return matchesSearch && matchesCategory && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search business plans by title, description, or author...',
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
          
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredPlans.length} business plans found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                if (_selectedCategory != 'All' || _selectedType != 'All')
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Clear Filters',
                      style: GoogleFonts.poppins(
                        color: AppTheme.primaryGreen,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Business Plans List
          Expanded(
            child: _filteredPlans.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPlans.length,
                    itemBuilder: (context, index) {
                      final plan = _filteredPlans[index];
                      return _buildPlanCard(plan);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with plan cover and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.description,
                    color: AppTheme.primaryGreen,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan['title'],
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
                        'by ${plan['author']}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              plan['description'],
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Plan Info Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    plan['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    plan['type'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Footer with stats and action
            Row(
              children: [
                Text(
                  '${plan['pages']} pages • ${plan['year']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${plan['rating']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: 16,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${plan['downloads']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Download button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _downloadPlan(plan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      plan['isFree'] ? 'Download' : plan['price'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  Widget _buildEmptyState() {
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
              Icons.description_outlined,
              size: 60,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No business plans found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                  Text(
                    'Filter Business Plans',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Category Filter
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Type Filter
              Text(
                'Type',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _types.map((type) {
                  final isSelected = _selectedType == type;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const Spacer(),
              
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedType = 'All';
    });
  }

  void _downloadPlan(Map<String, dynamic> plan) {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading ${plan['title']}...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
} 