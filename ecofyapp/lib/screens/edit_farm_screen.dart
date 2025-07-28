import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../services/api_service.dart';

class EditFarmScreen extends StatefulWidget {
  final Map<String, dynamic> farm;

  const EditFarmScreen({super.key, required this.farm});

  @override
  State<EditFarmScreen> createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends State<EditFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Resource Controllers
  final _laborController = TextEditingController();
  final _equipmentController = TextEditingController();
  final _budgetController = TextEditingController();
  final _timeController = TextEditingController();
  
  List<String> _selectedCrops = [];
  bool _isLoading = false;

  final List<String> _availableCrops = [
    'Maize', 'Rice', 'Beans', 'Tomatoes', 'Potatoes', 'Cabbage', 'Carrots',
    'Onions', 'Peppers', 'Cucumber', 'Lettuce', 'Spinach', 'Kale',
    'Wheat', 'Barley', 'Sorghum', 'Millet', 'Soybeans', 'Peas',
    'Sweet Potatoes', 'Cassava', 'Yams', 'Bananas', 'Pineapples',
    'Coffee', 'Tea', 'Sugarcane', 'Cotton', 'Tobacco', 'Vanilla'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = widget.farm['name'] ?? '';
    _locationController.text = widget.farm['location'] ?? '';
    _sizeController.text = widget.farm['size_in_acres']?.toString() ?? '';
    _descriptionController.text = widget.farm['description'] ?? '';
    
    // Initialize resource data
    _laborController.text = widget.farm['labor']?.toString() ?? '3';
    _equipmentController.text = widget.farm['equipment'] ?? 'Tractor, Irrigation';
    _budgetController.text = widget.farm['budget']?.toString() ?? '5000';
    _timeController.text = widget.farm['time_management'] ?? 'Full-time';
    
    // Initialize crops
    _selectedCrops = List<String>.from(widget.farm['crops'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Farm',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farm Details Section
              _buildSectionHeader('Farm Details', Icons.agriculture),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Farm Name *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Size (acres) *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm size';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  hintText: 'Describe your farm...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Resource Management Section
              _buildSectionHeader('Resource Management', Icons.manage_accounts),
              const SizedBox(height: 16),

              // Labor Management
              _buildResourceCard(
                'Labor',
                Icons.people,
                _laborController,
                'Number of workers',
                'How many workers do you have?',
              ),
              const SizedBox(height: 16),

              // Equipment Management
              _buildResourceCard(
                'Equipment',
                Icons.build,
                _equipmentController,
                'Available equipment',
                'List your farming equipment',
              ),
              const SizedBox(height: 16),

              // Financial Management
              _buildResourceCard(
                'Budget',
                Icons.account_balance_wallet,
                _budgetController,
                'Annual budget (USD)',
                'What is your annual farming budget?',
              ),
              const SizedBox(height: 16),

              // Time Management
              _buildResourceCard(
                'Time Management',
                Icons.schedule,
                _timeController,
                'Farming schedule',
                'How do you manage your time?',
              ),
              const SizedBox(height: 24),

              // Crops Section
              _buildSectionHeader('Crops', Icons.eco),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.surfaceLight,
                ),
                child: ExpansionTile(
                  title: Text(
                    _selectedCrops.isEmpty 
                        ? 'Select Crops' 
                        : '${_selectedCrops.length} crop(s) selected',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  children: _availableCrops.map((crop) {
                    final isSelected = _selectedCrops.contains(crop);
                    return CheckboxListTile(
                      title: Text(crop),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedCrops.add(crop);
                          } else {
                            _selectedCrops.remove(crop);
                          }
                        });
                      },
                      activeColor: AppTheme.primaryGreen,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveFarm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Update Farm',
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, IconData icon, TextEditingController controller, String label, String hint) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppTheme.surfaceLight,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveFarm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.updateFarm(widget.farm['id'].toString(), {
        'name': _nameController.text,
        'location': _locationController.text,
        'size_in_acres': double.tryParse(_sizeController.text) ?? 0.0,
        'description': _descriptionController.text,
        'crops': _selectedCrops,
        'labor': int.tryParse(_laborController.text) ?? 3,
        'equipment': _equipmentController.text,
        'budget': double.tryParse(_budgetController.text) ?? 5000.0,
        'time_management': _timeController.text,
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Farm "${_nameController.text}" updated successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update farm: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _descriptionController.dispose();
    _laborController.dispose();
    _equipmentController.dispose();
    _budgetController.dispose();
    _timeController.dispose();
    super.dispose();
  }
} 