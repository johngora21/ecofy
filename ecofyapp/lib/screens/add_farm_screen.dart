import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/theme/app_theme.dart';
import '../services/api_service.dart';
import '../data/tanzania_crops.dart';
import '../data/tanzania_regions.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({super.key});

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Soil Analysis Data
  Map<String, dynamic> _soilData = {
    'ph': null,
    'salinity': null,
    'soil_temp': null,
    'npk_n': null,
    'npk_p': null,
    'npk_k': null,
    'organic_matter': null,
    'soil_structure': null,
    'soil_type': null,
  };

  // Climate Data
  Map<String, dynamic> _climateData = {
    'climate_zone': null,
    'seasonal_pattern': null,
    'average_temperature': null,
    'annual_rainfall': null,
    'dry_season_months': null,
    'wet_season_months': null,
  };

  // Topography Data
  Map<String, dynamic> _topographyData = {
    'elevation': null,
    'slope': null,
    'landscape_type': null,
    'drainage': null,
    'erosion_risk': null,
  };

  List<String> _selectedCrops = [];
  bool _isLoading = false;
  bool _showMap = false;
  bool _isMappingFarm = false;
  bool _isAnalyzingLocation = false;
  
  // Map variables
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _farmBoundary = [];
  
  // Current location
  LatLng? _currentLocation;
  LatLng? _farmCenter;
  String _exactLocationName = '';

  final List<String> _availableCrops = TanzaniaCrops.getCropNames();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _farmCenter = _currentLocation;
      });
      
      // Get exact location name
      await _getExactLocationName(_currentLocation!);
      
      // Auto-analyze location when GPS is obtained
      if (_currentLocation != null) {
        _analyzeLocation();
      }
    } catch (e) {
      // Handle location error
    }
  }

  Future<void> _getExactLocationName(LatLng coordinates) async {
    try {
      // Using OpenStreetMap Nominatim API for reverse geocoding
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${coordinates.latitude}&lon=${coordinates.longitude}&zoom=18&addressdetails=1'
        ),
        headers: {
          'User-Agent': 'EcofyApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'];
        
        // Build location name from address components
        List<String> locationParts = [];
        
        if (address['suburb'] != null) locationParts.add(address['suburb']);
        if (address['city'] != null) locationParts.add(address['city']);
        if (address['town'] != null) locationParts.add(address['town']);
        if (address['county'] != null) locationParts.add(address['county']);
        if (address['state'] != null) locationParts.add(address['state']);
        if (address['country'] != null) locationParts.add(address['country']);
        
        setState(() {
          _exactLocationName = locationParts.join(', ');
          _locationController.text = _exactLocationName;
        });
      }
    } catch (e) {
      // Handle geocoding error
      setState(() {
        _exactLocationName = 'Location not found';
      });
    }
  }

  Future<void> _analyzeLocation() async {
    if (_farmCenter == null) return;

    setState(() {
      _isAnalyzingLocation = true;
    });

    try {
      // Simulate AI analysis - in real app, this would call Ecofy's AI services
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock soil analysis data
      setState(() {
        _soilData = {
          'ph': 6.8,
          'salinity': 0.5,
          'soil_temp': 24.5,
          'npk_n': 45,
          'npk_p': 12,
          'npk_k': 28,
          'organic_matter': 3.2,
          'soil_structure': 'Loamy',
          'soil_type': 'Loam',
        };

        _climateData = {
          'climate_zone': 'Tropical',
          'seasonal_pattern': 'Bimodal',
          'average_temperature': 26.5,
          'annual_rainfall': 1200,
          'dry_season_months': 'Jan-Mar, Jul-Sep',
          'wet_season_months': 'Apr-Jun, Oct-Dec',
        };

        _topographyData = {
          'elevation': 1650,
          'slope': 2.5,
          'landscape_type': 'Gentle Hills',
          'drainage': 'Good',
          'erosion_risk': 'Low',
        };

        _isAnalyzingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzingLocation = false;
      });
    }
  }

  void _toggleCrop(String crop) {
    setState(() {
      if (_selectedCrops.contains(crop)) {
        _selectedCrops.remove(crop);
      } else {
        _selectedCrops.add(crop);
      }
    });
  }

  void _toggleMap() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  void _startFarmMapping() {
    setState(() {
      _isMappingFarm = true;
      _farmBoundary.clear();
      _polygons.clear();
    });
  }

  void _stopFarmMapping() {
    setState(() {
      _isMappingFarm = false;
    });
    _calculateFarmArea();
  }

  void _calculateFarmArea() {
    if (_farmBoundary.length >= 3) {
      double area = _calculatePolygonArea(_farmBoundary);
      setState(() {
        _sizeController.text = area.toStringAsFixed(2);
      });
    }
  }

  double _calculatePolygonArea(List<LatLng> points) {
    double area = 0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].latitude * points[j].longitude;
      area -= points[j].latitude * points[i].longitude;
    }
    area = area.abs() / 2;
    return area * 247.105; // Convert to acres
  }

  void _onMapTap(LatLng position) {
    if (_isMappingFarm) {
      setState(() {
        _farmBoundary.add(position);
        _updateFarmPolygon();
      });
    } else {
      setState(() {
        _farmCenter = position;
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('farm_center'),
          position: position,
          infoWindow: InfoWindow(title: 'Farm Center'),
        ));
      });
      // Get exact location name for new position
      _getExactLocationName(position);
      // Re-analyze location when farm center changes
      _analyzeLocation();
    }
  }

  void _updateFarmPolygon() {
    if (_farmBoundary.length >= 3) {
      setState(() {
        _polygons.clear();
        _polygons.add(Polygon(
          polygonId: const PolygonId('farm_boundary'),
          points: _farmBoundary,
          strokeWidth: 2,
          strokeColor: AppTheme.primaryGreen,
          fillColor: AppTheme.primaryGreen.withOpacity(0.2),
        ));
      });
    }
  }

  Widget _buildSoilAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.science, color: AppTheme.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              'Soil Analysis',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            if (_isAnalyzingLocation) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAnalysisCard('pH', _soilData['ph']?.toString() ?? '6.8', 'pH Level'),
            _buildAnalysisCard('Salinity', _soilData['salinity']?.toString() ?? '0.5', 'dS/m'),
            _buildAnalysisCard('Soil Temp', _soilData['soil_temp']?.toString() ?? '22', '°C'),
            _buildAnalysisCard('N-P-K', _soilData['npk_n'] != null ? '${_soilData['npk_n']}-${_soilData['npk_p']}-${_soilData['npk_k']}' : '15-10-20', 'N-P-K'),
            _buildAnalysisCard('Organic Matter', _soilData['organic_matter']?.toString() ?? '2.1', '%'),
            _buildAnalysisCard('Soil Type', _soilData['soil_type'] ?? 'Loam', 'Type'),
          ],
        ),
      ],
    );
  }

  Widget _buildClimateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.wb_sunny, color: AppTheme.warningYellow, size: 20),
            const SizedBox(width: 8),
            Text(
              'Climate',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAnalysisCard('Climate Zone', _climateData['climate_zone'] ?? 'Tropical', 'Zone'),
            _buildAnalysisCard('Seasonal Pattern', _climateData['seasonal_pattern'] ?? 'Bimodal', 'Pattern'),
            _buildAnalysisCard('Avg Temperature', _climateData['average_temperature']?.toString() ?? '24', '°C'),
            _buildAnalysisCard('Annual Rainfall', _climateData['annual_rainfall']?.toString() ?? '1200', 'mm/year'),
            _buildAnalysisCard('Dry Season', _climateData['dry_season_months'] ?? 'Jan-Mar', 'Months'),
            _buildAnalysisCard('Wet Season', _climateData['wet_season_months'] ?? 'Apr-Dec', 'Months'),
          ],
        ),
      ],
    );
  }

  Widget _buildTopographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.terrain, color: AppTheme.secondaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Topography & Landscape',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAnalysisCard('Elevation', _topographyData['elevation']?.toString() ?? '1650', 'm'),
            _buildAnalysisCard('Slope', _topographyData['slope']?.toString() ?? '5', '%'),
            _buildAnalysisCard('Landscape', _topographyData['landscape_type'] ?? 'Rolling', 'Type'),
            _buildAnalysisCard('Drainage', _topographyData['drainage'] ?? 'Good', 'Quality'),
            _buildAnalysisCard('Erosion Risk', _topographyData['erosion_risk'] ?? 'Low', 'Risk Level'),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(String title, String value, String unit) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppTheme.textSecondary,
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
      await ApiService.createFarm({
        'name': _nameController.text,
        'location': _locationController.text,
        'size_in_acres': double.tryParse(_sizeController.text) ?? 0.0,
        'description': _descriptionController.text,
        'crops': _selectedCrops,
        'coordinates': {
          'lat': _farmCenter?.latitude.toString() ?? '0.0',
          'lng': _farmCenter?.longitude.toString() ?? '0.0',
        },
        'farm_boundary': _farmBoundary.map((point) => {
          'lat': point.latitude,
          'lng': point.longitude,
        }).toList(),
        'soil_analysis': _soilData,
        'climate_data': _climateData,
        'topography_data': _topographyData,
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Farm "${_nameController.text}" added successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add farm: $e'),
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

  void _showCropSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Crops',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableCrops.length,
            itemBuilder: (context, index) {
              final crop = _availableCrops[index];
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
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        title: Text('Add Farm', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              Text(
                'Farm Details',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
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

              // Location with Map
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  hintText: 'e.g., Nairobi, Kenya',
                  suffixIcon: IconButton(
                    icon: Icon(_showMap ? Icons.map : Icons.location_on),
                    onPressed: _toggleMap,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Exact Location Display
              if (_exactLocationName.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryGreen,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exact Location:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              _exactLocationName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Map Section
              if (_showMap) ...[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _currentLocation != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentLocation!,
                              zoom: 15,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                            markers: _markers,
                            polygons: _polygons,
                            onTap: _onMapTap,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Farm Mapping Controls
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isMappingFarm ? _stopFarmMapping : _startFarmMapping,
                        icon: Icon(_isMappingFarm ? Icons.stop : Icons.edit_location),
                        label: Text(_isMappingFarm ? 'Stop Mapping' : 'Map Farm Boundary'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isMappingFarm ? AppTheme.errorRed : AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text('My Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Size (Manual input when not mapping)
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Size (acres) *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  hintText: _isMappingFarm ? 'Will be calculated automatically' : 'e.g., 25.5',
                  suffixIcon: _showMap && _farmBoundary.isNotEmpty
                      ? Icon(Icons.calculate, color: AppTheme.primaryGreen)
                      : null,
                ),
                keyboardType: TextInputType.number,
                enabled: !_isMappingFarm,
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
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  hintText: 'Optional farm description...',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Soil Analysis Section
              _buildSoilAnalysisSection(),
              const SizedBox(height: 20),

              // Climate Section
              _buildClimateSection(),
              const SizedBox(height: 20),

              // Topography Section
              _buildTopographySection(),
              const SizedBox(height: 20),

              // Crops Selection
              Text(
                'Crops',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select crops you plan to grow',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Multi-select Dropdown for Crops
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.surfaceLight,
                ),
                child: DropdownButtonFormField<String>(
                  value: null,
                  decoration: const InputDecoration(
                    labelText: 'Select Crops',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        _selectedCrops.isEmpty 
                            ? 'Select Crops' 
                            : '${_selectedCrops.length} crop(s) selected',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    // Show crop selection dialog
                    _showCropSelectionDialog();
                  },
                ),
              ),
              const SizedBox(height: 100), // Extra space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
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
                    'Save Farm',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 