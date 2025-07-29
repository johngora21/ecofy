import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';

  final List<String> _categories = [
    'All',
    'Crop Management',
    'Soil Science',
    'Livestock',
    'Technology',
    'Business',
    'Equipment',
  ];

  final List<String> _levels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<Map<String, dynamic>> _tutorials = [
    {
      'id': '1',
      'title': 'Crop Management Basics',
      'instructor': 'Agricultural Institute',
      'duration': '45 min',
      'category': 'Crop Management',
      'level': 'Beginner',
      'description': 'Learn the fundamentals of crop management including planting, watering, and harvesting techniques.',
      'thumbnail': 'assets/images/tutorial1.jpg',
      'views': 1247,
      'rating': 4.6,
      'videoUrl': 'https://example.com/tutorial1.mp4',
      'isFree': true,
    },
    {
      'id': '2',
      'title': 'Soil Testing Methods',
      'instructor': 'Soil Science Lab',
      'duration': '30 min',
      'category': 'Soil Science',
      'level': 'Intermediate',
      'description': 'How to properly test and analyze soil composition for optimal crop growth.',
      'thumbnail': 'assets/images/tutorial2.jpg',
      'views': 892,
      'rating': 4.8,
      'videoUrl': 'https://example.com/tutorial2.mp4',
      'isFree': true,
    },
    {
      'id': '3',
      'title': 'Precision Farming Technology',
      'instructor': 'Tech Farm Solutions',
      'duration': '60 min',
      'category': 'Technology',
      'level': 'Advanced',
      'description': 'Advanced techniques using GPS, drones, and IoT devices for precision agriculture.',
      'thumbnail': 'assets/images/tutorial3.jpg',
      'views': 567,
      'rating': 4.7,
      'videoUrl': 'https://example.com/tutorial3.mp4',
      'isFree': false,
    },
    {
      'id': '4',
      'title': 'Livestock Health Management',
      'instructor': 'Veterinary Institute',
      'duration': '40 min',
      'category': 'Livestock',
      'level': 'Intermediate',
      'description': 'Comprehensive guide to maintaining livestock health and preventing diseases.',
      'thumbnail': 'assets/images/tutorial4.jpg',
      'views': 1034,
      'rating': 4.5,
      'videoUrl': 'https://example.com/tutorial4.mp4',
      'isFree': true,
    },
    {
      'id': '5',
      'title': 'Farm Equipment Maintenance',
      'instructor': 'Equipment Experts',
      'duration': '35 min',
      'category': 'Equipment',
      'level': 'Beginner',
      'description': 'Essential maintenance tips for tractors, harvesters, and other farm equipment.',
      'thumbnail': 'assets/images/tutorial5.jpg',
      'views': 756,
      'rating': 4.4,
      'videoUrl': 'https://example.com/tutorial5.mp4',
      'isFree': true,
    },
    {
      'id': '6',
      'title': 'Agricultural Business Planning',
      'instructor': 'Business Development',
      'duration': '50 min',
      'category': 'Business',
      'level': 'Advanced',
      'description': 'Strategic planning and financial management for agricultural businesses.',
      'thumbnail': 'assets/images/tutorial6.jpg',
      'views': 423,
      'rating': 4.6,
      'videoUrl': 'https://example.com/tutorial6.mp4',
      'isFree': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredTutorials {
    return _tutorials.where((tutorial) {
      final matchesSearch = tutorial['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          tutorial['instructor'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          tutorial['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || tutorial['category'] == _selectedCategory;
      final matchesLevel = _selectedLevel == 'All' || tutorial['level'] == _selectedLevel;
      
      return matchesSearch && matchesCategory && matchesLevel;
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
                  hintText: 'Search tutorials by title, instructor, or description...',
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
                  '${_filteredTutorials.length} tutorials found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                if (_selectedCategory != 'All' || _selectedLevel != 'All')
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
          
          // Tutorials List
          Expanded(
            child: _filteredTutorials.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTutorials.length,
                    itemBuilder: (context, index) {
                      final tutorial = _filteredTutorials[index];
                      return _buildTutorialCard(tutorial);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(Map<String, dynamic> tutorial) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Thumbnail Section
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                // Placeholder for video thumbnail
                Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                // Play button overlay
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tutorial['duration'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Free/Premium badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tutorial['isFree'] ? AppTheme.successGreen : Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tutorial['isFree'] ? 'FREE' : 'PREMIUM',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tutorial['title'],
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
                  'by ${tutorial['instructor']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tutorial['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Tags and Stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tutorial['category'],
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
                        tutorial['level'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.secondaryBlue,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tutorial['views']}',
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
                
                // Action Row
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tutorial['rating']}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _watchTutorial(tutorial),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Watch',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
              Icons.play_circle_outline,
              size: 60,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tutorials found',
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
                    'Filter Tutorials',
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
              
              // Level Filter
              Text(
                'Level',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _levels.map((level) {
                  final isSelected = _selectedLevel == level;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        level,
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
      _selectedLevel = 'All';
    });
  }

  void _watchTutorial(Map<String, dynamic> tutorial) {
    // TODO: Implement video player functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing ${tutorial['title']}...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
} 