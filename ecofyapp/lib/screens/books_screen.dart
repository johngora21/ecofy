import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLanguage = 'All';

  final List<String> _categories = [
    'All',
    'Crop Management',
    'Soil Science',
    'Livestock',
    'Technology',
    'Business',
    'Sustainability',
  ];

  final List<String> _languages = [
    'All',
    'English',
    'Swahili',
    'French',
  ];

  final List<Map<String, dynamic>> _books = [
    {
      'title': 'Modern Farming Techniques',
      'author': 'Dr. John Smith',
      'category': 'Crop Management',
      'language': 'English',
      'description': 'Comprehensive guide to modern agricultural practices.',
      'pages': 320,
      'year': '2024',
      'rating': 4.5,
      'cover': null,
    },
    {
      'title': 'Sustainable Agriculture',
      'author': 'Prof. Sarah Johnson',
      'category': 'Sustainability',
      'language': 'English',
      'description': 'Methods for environmentally friendly farming.',
      'pages': 280,
      'year': '2023',
      'rating': 4.8,
      'cover': null,
    },
    {
      'title': 'Soil Science Fundamentals',
      'author': 'Dr. Michael Chen',
      'category': 'Soil Science',
      'language': 'English',
      'description': 'Guide to understanding soil composition and improvement.',
      'pages': 450,
      'year': '2023',
      'rating': 4.6,
      'cover': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredBooks {
    return _books.where((book) {
      final matchesSearch = book['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['author'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || book['category'] == _selectedCategory;
      final matchesLanguage = _selectedLanguage == 'All' || book['language'] == _selectedLanguage;
      return matchesSearch && matchesCategory && matchesLanguage;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search books by title, author, or description...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${_filteredBooks.length} books found', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary)),
                const Spacer(),
                if (_selectedCategory != 'All' || _selectedLanguage != 'All')
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text('Clear Filters', style: GoogleFonts.poppins(color: AppTheme.primaryGreen, fontSize: 14)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _filteredBooks.isEmpty
                ? Center(child: Text('No books found', style: GoogleFonts.poppins(fontSize: 18, color: AppTheme.textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks[index];
                      return _buildBookCard(book);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
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
            // Header with book cover and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.book, color: Colors.green, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book['title'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      const SizedBox(height: 4),
                      Text('by ${book['author']}', style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(book['description'], style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            
            // Tags
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(book['category'], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryGreen)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(book['language'], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.secondaryBlue)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Footer with pages and rating
            Row(
              children: [
                Text('${book['pages']} pages', style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textTertiary)),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${book['rating']}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textTertiary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Download button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement download functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Downloading ${book['title']}...'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.download, size: 16),
                label: Text('Download', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
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
                  Text('Filter Books', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Category', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(category, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : AppTheme.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Language', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _languages.map((language) {
                  final isSelected = _selectedLanguage == language;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedLanguage = language),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(language, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : AppTheme.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Apply Filters', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
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
      _selectedLanguage = 'All';
    });
  }
} 