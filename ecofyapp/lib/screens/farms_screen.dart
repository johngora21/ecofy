import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../core/theme/app_theme.dart';
import 'add_farm_screen.dart';
import 'farm_details_screen.dart';
import 'edit_farm_screen.dart';

class FarmsScreen extends StatefulWidget {
  const FarmsScreen({super.key});

  @override
  State<FarmsScreen> createState() => _FarmsScreenState();
}

class _FarmsScreenState extends State<FarmsScreen> {
  List<Map<String, dynamic>> _farms = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Show sample farms for demonstration
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    
    setState(() {
      _farms = [
        {
          'id': 1,
          'name': 'Green Valley Farm',
          'location': 'Nairobi, Kenya',
          'size_in_acres': 25.5,
          'description': 'Mixed crop farm with modern irrigation',
          'crops': ['Maize', 'Beans', 'Tomatoes'],
          'labor': 4,
          'equipment': 'Tractor, Irrigation System, Storage',
          'budget': 8000.0,
          'time_management': 'Full-time farming',
        },
        {
          'id': 2,
          'name': 'Sunrise Agricultural',
          'location': 'Kisumu, Kenya',
          'size_in_acres': 18.2,
          'description': 'Rice and sugarcane plantation',
          'crops': ['Rice', 'Sugarcane'],
          'labor': 6,
          'equipment': 'Harvester, Water Pump, Processing Unit',
          'budget': 12000.0,
          'time_management': 'Seasonal intensive',
        },
        {
          'id': 3,
          'name': 'Highland Farms',
          'location': 'Eldoret, Kenya',
          'size_in_acres': 32.0,
          'description': 'Large scale grain production',
          'crops': ['Wheat', 'Barley', 'Potatoes'],
          'labor': 8,
          'equipment': 'Combine Harvester, Plow, Seed Drill',
          'budget': 15000.0,
          'time_management': 'Year-round operation',
        },
        {
          'id': 4,
          'name': 'Organic Valley',
          'location': 'Nakuru, Kenya',
          'size_in_acres': 15.8,
          'description': 'Organic vegetable and herb farm',
          'crops': ['Vegetables', 'Herbs'],
          'labor': 3,
          'equipment': 'Greenhouse, Drip Irrigation, Compost',
          'budget': 6000.0,
          'time_management': 'Part-time with family',
        },
        {
          'id': 5,
          'name': 'Mountain View Farm',
          'location': 'Kericho, Kenya',
          'size_in_acres': 28.5,
          'description': 'Tea and coffee estate',
          'crops': ['Tea', 'Coffee', 'Avocado'],
          'labor': 12,
          'equipment': 'Tea Processor, Coffee Mill, Transport',
          'budget': 20000.0,
          'time_management': 'Commercial scale',
        },
      ];
      _isLoading = false;
    });
  }

  Widget _buildFarmCard(Map<String, dynamic> farm) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmDetailsScreen(farm: farm),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.agriculture,
                      color: AppTheme.primaryGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          farm['name'] ?? 'Unknown Farm',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          farm['location'] ?? 'Unknown Location',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${farm['size_in_acres']?.toString() ?? '0'} acres',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditFarmDialog(farm);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(farm);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (farm['crops'] != null && (farm['crops'] as List).isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Crops:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (farm['crops'] as List)
                      .map((crop) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                            ),
                            child: Text(
                              crop.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No farms yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first farm to get started',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddFarmDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFarmScreen(),
      ),
    ).then((result) {
      if (result == true) {
        _loadFarms(); // Reload farms after adding
      }
    });
  }

  void _showEditFarmDialog(Map<String, dynamic> farm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFarmScreen(farm: farm),
      ),
    ).then((result) {
      if (result == true) {
        _loadFarms(); // Reload farms after editing
      }
    });
  }

  void _showDeleteConfirmation(Map<String, dynamic> farm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Farm',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text('Are you sure you want to delete "${farm['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ApiService.deleteFarm(farm['id'].toString());
                Navigator.pop(context);
                _loadFarms();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Farm deleted successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete farm: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load farms',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFarms,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _farms.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: _farms.length,
                      itemBuilder: (context, index) {
                        return _buildFarmCard(_farms[index]);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFarmDialog,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
} 