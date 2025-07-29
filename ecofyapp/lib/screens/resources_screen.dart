import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'books_screen.dart';
import 'tutorials_screen.dart';
import 'events_screen.dart';
import 'business_plans_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  int selectedTabIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {'title': 'Books', 'icon': Icons.book},
    {'title': 'Tutorials', 'icon': Icons.school},
    {'title': 'Events', 'icon': Icons.event},
    {'title': 'Business Plans', 'icon': Icons.business},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundLight,
      child: Column(
        children: [
          // Tab Navigation - Marketplace Style
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = selectedTabIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab['icon'],
                          size: 16,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tab['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Tab Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return const BooksScreen();
      case 1:
        return const TutorialsScreen();
      case 2:
        return const EventsScreen();
      case 3:
        return const BusinessPlansScreen();
      default:
        return const BooksScreen();
    }
  }

  Widget _buildBooksContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agricultural Books',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildBookCard('Modern Farming Techniques', 'Dr. John Smith', '2024', 'Comprehensive guide to modern agricultural practices'),
          const SizedBox(height: 12),
          _buildBookCard('Sustainable Agriculture', 'Prof. Sarah Johnson', '2023', 'Methods for environmentally friendly farming'),
          const SizedBox(height: 12),
          _buildBookCard('Soil Science Fundamentals', 'Dr. Michael Chen', '2023', 'Guide to understanding soil composition and improvement'),
        ],
      ),
    );
  }

  Widget _buildTutorialsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agricultural Tutorials',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTutorialCard('Crop Management Basics', 'Agricultural Institute', '45 min', 'Learn the fundamentals of crop management'),
          const SizedBox(height: 12),
          _buildTutorialCard('Soil Testing Methods', 'Soil Science Lab', '30 min', 'How to properly test and analyze soil'),
          const SizedBox(height: 12),
          _buildTutorialCard('Livestock Care', 'Veterinary Institute', '60 min', 'Complete guide to livestock health and care'),
        ],
      ),
    );
  }

  Widget _buildEventsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agricultural Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventCard('Agricultural Expo 2024', 'Dar es Salaam', 'March 15-17, 2024', 'Annual farming exhibition and trade show'),
          const SizedBox(height: 12),
          _buildEventCard('Farming Workshop', 'Arusha', 'February 28, 2024', 'Hands-on training for modern farming techniques'),
          const SizedBox(height: 12),
          _buildEventCard('Technology Conference', 'Mwanza', 'April 10, 2024', 'Latest agricultural technology innovations'),
        ],
      ),
    );
  }

  Widget _buildBusinessPlansContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Plans',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildPlanCard('Farm Business Plan Template', 'Business Development', '2024', 'Complete template for agricultural business planning'),
          const SizedBox(height: 12),
          _buildPlanCard('Financial Planning Guide', 'Agricultural Finance', '2023', 'Guide to financial management for farmers'),
          const SizedBox(height: 12),
          _buildPlanCard('Marketing Strategy', 'Marketing Institute', '2024', 'Agricultural marketing and sales strategies'),
        ],
      ),
    );
  }

  Widget _buildBookCard(String title, String author, String year, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.book, color: AppTheme.primaryGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(author, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                    const Spacer(),
                    Text(year, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(String title, String instructor, String duration, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.play_circle, color: AppTheme.secondaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(instructor, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                    const Spacer(),
                    Text(duration, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String location, String date, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event, color: AppTheme.successGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppTheme.textTertiary),
                    const SizedBox(width: 4),
                    Text(location, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                    const Spacer(),
                    Text(date, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String title, String organization, String year, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.business, color: AppTheme.secondaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(organization, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                    const Spacer(),
                    Text(year, style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, String author, String year, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
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


} 