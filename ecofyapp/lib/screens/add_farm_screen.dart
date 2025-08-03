import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
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
  LatLng? _currentMapPosition; // Track current map position for real-time coordinates
  String _exactLocationName = '';
  
  // GPS tracking for farm boundary
  StreamSubscription<Position>? _positionStream;
  bool _isTrackingBoundary = false;
  Timer? _boundaryTrackingTimer;
  LatLng? _currentGpsPosition; // Track current GPS position during boundary mapping

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable GPS.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied. Cannot get current location.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission permanently denied. Please enable in settings.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _farmCenter = _currentLocation;
        _currentMapPosition = _currentLocation; // Initialize map position
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: 'Current Location'),
        ));
      });
      
      // Get exact location name
      await _getExactLocationName(_currentLocation!);
      
      // Auto-analyze location when GPS is obtained
      if (_currentLocation != null) {
        _analyzeLocation();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
        
        // Build detailed location name from address components
        List<String> locationParts = [];
        
        // Start with the most specific details first
        if (address['road'] != null) locationParts.add(address['road']);
        if (address['street'] != null) locationParts.add(address['street']);
        if (address['neighbourhood'] != null) locationParts.add(address['neighbourhood']);
        if (address['suburb'] != null) locationParts.add(address['suburb']);
        if (address['quarter'] != null) locationParts.add(address['quarter']);
        if (address['district'] != null) locationParts.add(address['district']);
        if (address['city'] != null) locationParts.add(address['city']);
        if (address['town'] != null) locationParts.add(address['town']);
        if (address['village'] != null) locationParts.add(address['village']);
        if (address['hamlet'] != null) locationParts.add(address['hamlet']);
        if (address['county'] != null) locationParts.add(address['county']);
        if (address['state'] != null) locationParts.add(address['state']);
        if (address['country'] != null) locationParts.add(address['country']);
        
        // Create detailed location name
        String locationName;
        if (locationParts.isNotEmpty) {
          // Remove duplicates while preserving order
          List<String> uniqueParts = [];
          for (String part in locationParts) {
            if (!uniqueParts.contains(part)) {
              uniqueParts.add(part);
            }
          }
          locationName = uniqueParts.join(', ');
        } else {
          locationName = '${coordinates.latitude.toStringAsFixed(4)}, ${coordinates.longitude.toStringAsFixed(4)}';
        }
        
        setState(() {
          _exactLocationName = locationName;
          _locationController.text = locationName;
        });
      } else {
        // Handle API error - use coordinates
        setState(() {
          _exactLocationName = '${coordinates.latitude.toStringAsFixed(4)}, ${coordinates.longitude.toStringAsFixed(4)}';
          _locationController.text = _exactLocationName;
        });
      }
    } catch (e) {
      // Handle network error - use coordinates as fallback
      setState(() {
        _exactLocationName = '${coordinates.latitude.toStringAsFixed(4)}, ${coordinates.longitude.toStringAsFixed(4)}';
        _locationController.text = _exactLocationName;
      });
    }
  }

  Future<void> _analyzeLocation() async {
    if (_farmCenter == null) return;

    setState(() {
      _isAnalyzingLocation = true;
    });

    try {
      // Get real soil and weather data from APIs
      final soilData = await ApiService.getSoilDataForFarm(
        _farmCenter!.latitude,
        _farmCenter!.longitude,
      );
      
      final weatherData = await ApiService.getWeatherData(
        _farmCenter!.latitude,
        _farmCenter!.longitude,
      );

      setState(() {
        _soilData = {
          'ph': soilData['ph'],
          'salinity': soilData['salinity'],
          'soil_temp': soilData['soil_temp'],
          'npk_n': soilData['npk_n'],
          'npk_p': soilData['npk_p'],
          'npk_k': soilData['npk_k'],
          'organic_matter': soilData['organic_matter'],
          'soil_structure': soilData['soil_structure'],
          'soil_type': soilData['soil_type'],
        };

        _climateData = {
          'climate_zone': weatherData['climate_zone'],
          'seasonal_pattern': weatherData['seasonal_pattern'],
          'average_temperature': weatherData['average_temperature'],
          'annual_rainfall': weatherData['annual_rainfall'],
          'dry_season_months': weatherData['dry_season_months'],
          'wet_season_months': weatherData['wet_season_months'],
        };

        _topographyData = {
          'elevation': weatherData['elevation'],
          'slope': weatherData['slope'],
          'landscape_type': weatherData['landscape_type'],
          'drainage': weatherData['drainage'],
          'erosion_risk': weatherData['erosion_risk'],
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
      // Initialize current map position when map is shown
      if (_showMap && _currentLocation != null) {
        _currentMapPosition = _currentLocation;
      }
    });
  }

  void _startFarmMapping() {
    setState(() {
      _isMappingFarm = true;
      _farmBoundary.clear();
      _polygons.clear();
    });
    _startBoundaryTracking();
  }

  void _stopFarmMapping() {
    setState(() {
      _isMappingFarm = false;
    });
    _stopBoundaryTracking();
    _calculateFarmArea();
  }

  void _startBoundaryTracking() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission needed for boundary tracking'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission permanently denied'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Start GPS tracking
      setState(() {
        _isTrackingBoundary = true;
      });

      // Start position stream with high accuracy
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Update every 5 meters
        ),
      ).listen((Position position) {
        if (_isTrackingBoundary && _isMappingFarm) {
          LatLng newPoint = LatLng(position.latitude, position.longitude);
          print('GPS Point received: ${position.latitude}, ${position.longitude}');
          
          // Only add point if it's significantly different from the last point
          bool shouldAddPoint = true;
          if (_farmBoundary.isNotEmpty) {
            LatLng lastPoint = _farmBoundary.last;
            double distance = _calculateDistance(lastPoint, newPoint);
            print('Distance from last point: ${distance.toStringAsFixed(2)} meters');
            
            // Only add point if it's at least 1 meter away from the last point (reduced for compound mapping)
            shouldAddPoint = distance >= 1.0;
          }
          
          if (shouldAddPoint) {
            setState(() {
              _currentGpsPosition = newPoint;
              _farmBoundary.add(newPoint);
              _updateFarmPolygon();
            });
            
            print('Added boundary point: ${newPoint.latitude}, ${newPoint.longitude} (total: ${_farmBoundary.length})');
            print('Total boundary points: ${_farmBoundary.length}');
          }
          
          // Update map to follow user
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(newPoint),
            );
          }
        }
      });

      // Start timer to add points at regular intervals and update GPS position
      _boundaryTrackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isTrackingBoundary && _isMappingFarm) {
          // Update current GPS position more frequently
          Geolocator.getCurrentPosition().then((position) {
            if (_isTrackingBoundary && _isMappingFarm) {
              setState(() {
                _currentGpsPosition = LatLng(position.latitude, position.longitude);
              });
              print('GPS Position updated: ${position.latitude}, ${position.longitude}');
            }
          });
          
          // Add boundary point every 3 seconds
          if (timer.tick % 3 == 0 && _currentLocation != null) {
            setState(() {
              _farmBoundary.add(_currentLocation!);
              _updateFarmPolygon();
            });
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS tracking started. Walk around your farm boundary.'),
          backgroundColor: AppTheme.primaryGreen,
          duration: Duration(seconds: 3),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting GPS tracking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _stopBoundaryTracking() {
    _positionStream?.cancel();
    _boundaryTrackingTimer?.cancel();
    setState(() {
      _isTrackingBoundary = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS tracking stopped. Boundary mapping complete.'),
        backgroundColor: AppTheme.secondaryBlue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _calculateFarmArea() {
    print('Calculating farm area...');
    print('Boundary points: ${_farmBoundary.length}');
    
    // Print all boundary points for debugging
    for (int i = 0; i < _farmBoundary.length; i++) {
      print('Point $i: ${_farmBoundary[i].latitude}, ${_farmBoundary[i].longitude}');
    }
    
    if (_farmBoundary.length >= 3) {
      double area = _calculatePolygonArea(_farmBoundary);
      print('Calculated area: $area');
      
      String unit = area < 0.01 ? 'sq meters' : 'acres';
      String displayArea = area < 0.01 ? area.toStringAsFixed(1) : area.toStringAsFixed(2);
      
      setState(() {
        _sizeController.text = displayArea;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Farm area calculated: $displayArea $unit'),
          backgroundColor: AppTheme.primaryGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      print('Not enough boundary points for area calculation');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Need at least 3 boundary points to calculate area'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    // Calculate distance between two points using Haversine formula
    const double earthRadius = 6371000; // Earth radius in meters
    
    double lat1 = point1.latitude * (3.14159265359 / 180);
    double lon1 = point1.longitude * (3.14159265359 / 180);
    double lat2 = point2.latitude * (3.14159265359 / 180);
    double lon2 = point2.longitude * (3.14159265359 / 180);
    
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;
    double a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;
    
    print('Calculating area for ${points.length} points');
    
    // Use a simpler but more accurate approach for small areas
    // Convert coordinates to meters using proper scaling
    List<Map<String, double>> pointsInMeters = [];
    
    // Tanzania is around -6° latitude, so we use appropriate scaling
    const double metersPerDegreeLat = 111320.0; // meters per degree latitude
    const double metersPerDegreeLon = 111320.0 * 0.9945; // meters per degree longitude at -6° latitude
    
    for (int i = 0; i < points.length; i++) {
      // Convert to meters from a reference point (first point)
      double x = (points[i].longitude - points[0].longitude) * metersPerDegreeLon;
      double y = (points[i].latitude - points[0].latitude) * metersPerDegreeLat;
      pointsInMeters.add({'x': x, 'y': y});
      print('Point $i: ${points[i].latitude}, ${points[i].longitude} -> x: $x m, y: $y m');
    }
    
    // Calculate area using shoelace formula with meter coordinates
    double area = 0.0;
    for (int i = 0; i < pointsInMeters.length; i++) {
      int j = (i + 1) % pointsInMeters.length;
      area += pointsInMeters[i]['x']! * pointsInMeters[j]['y']!;
      area -= pointsInMeters[j]['x']! * pointsInMeters[i]['y']!;
    }
    
    area = area.abs() / 2; // Area in square meters
    
    // Convert to acres (1 acre = 4046.86 square meters)
    double areaInAcres = area / 4046.86;
    
    print('Area calculation results:');
    print('Area in square meters: $area');
    print('Area in acres: $areaInAcres');
    
    // For very small areas (like a room), show in square meters instead
    if (areaInAcres < 0.01) {
      print('Area is very small, showing in square meters');
      return area; // Return square meters for small areas
    }
    
    return areaInAcres;
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

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentMapPosition = position.target;
    });
    print('Camera moved to: ${position.target.latitude}, ${position.target.longitude}');
  }

  void _onCameraIdle() {
    // This ensures coordinates are updated when camera stops moving
    if (_mapController != null) {
      _mapController!.getVisibleRegion().then((bounds) {
        setState(() {
          _currentMapPosition = LatLng(
            (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
          );
        });
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
            _buildAnalysisCard('pH', _soilData['ph']?.toString() ?? 'No data', 'pH Level'),
            _buildAnalysisCard('Salinity', _soilData['salinity']?.toString() ?? 'No data', 'dS/m'),
            _buildAnalysisCard('Soil Temp', _soilData['soil_temp']?.toString() ?? 'No data', '°C'),
            _buildAnalysisCard('N-P-K', _soilData['npk_n'] != null ? '${_soilData['npk_n']}-${_soilData['npk_p']}-${_soilData['npk_k']}' : 'No data', 'N-P-K'),
            _buildAnalysisCard('Organic Matter', _soilData['organic_matter']?.toString() ?? 'No data', '%'),
            _buildAnalysisCard('Soil Type', _soilData['soil_type'] ?? 'No data', 'Type'),
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
            _buildAnalysisCard('Climate Zone', _climateData['climate_zone'] ?? 'No data', 'Zone'),
            _buildAnalysisCard('Seasonal Pattern', _climateData['seasonal_pattern'] ?? 'No data', 'Pattern'),
            _buildAnalysisCard('Avg Temperature', _climateData['average_temperature']?.toString() ?? 'No data', '°C'),
            _buildAnalysisCard('Annual Rainfall', _climateData['annual_rainfall']?.toString() ?? 'No data', 'mm/year'),
            _buildAnalysisCard('Dry Season', _climateData['dry_season_months'] ?? 'No data', 'Months'),
            _buildAnalysisCard('Wet Season', _climateData['wet_season_months'] ?? 'No data', 'Months'),
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
            _buildAnalysisCard('Elevation', _topographyData['elevation']?.toString() ?? 'No data', 'm'),
            _buildAnalysisCard('Slope', _topographyData['slope']?.toString() ?? 'No data', '%'),
            _buildAnalysisCard('Landscape', _topographyData['landscape_type'] ?? 'No data', 'Type'),
            _buildAnalysisCard('Drainage', _topographyData['drainage'] ?? 'No data', 'Quality'),
            _buildAnalysisCard('Erosion Risk', _topographyData['erosion_risk'] ?? 'No data', 'Risk Level'),
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
    List<String> tempSelectedCrops = List.from(_selectedCrops);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Select Crops',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Text(
                  'Select the crops you plan to grow on this farm',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _availableCrops.length,
                    itemBuilder: (context, index) {
                      final crop = _availableCrops[index];
                      final isSelected = tempSelectedCrops.contains(crop);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                          ),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            crop,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          subtitle: isSelected ? Text(
                            '✓ Selected',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryGreen,
                            ),
                          ) : null,
                          value: isSelected,
                          onChanged: (bool? value) {
                            setDialogState(() {
                              if (value == true) {
                                tempSelectedCrops.add(crop);
                              } else {
                                tempSelectedCrops.remove(crop);
                              }
                            });
                          },
                          activeColor: AppTheme.primaryGreen,
                          checkColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCrops = List.from(tempSelectedCrops);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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

              // Location and Coordinates Display
              if (_exactLocationName.isNotEmpty || _currentLocation != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Name
                      if (_exactLocationName.isNotEmpty) ...[
                        Row(
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
                        const SizedBox(height: 8),
                      ],
                      // Coordinates
                      if (_currentLocation != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.gps_fixed,
                              color: AppTheme.secondaryBlue,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Coordinates:',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppTheme.borderLight),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                                                      child: Text(
                                  'Lat: ${(_isTrackingBoundary && _currentGpsPosition != null ? _currentGpsPosition!.latitude : (_currentMapPosition ?? _currentLocation)!.latitude).toStringAsFixed(6)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                    ),
                                    if (_currentMapPosition != null && _currentMapPosition != _currentLocation)
                                      Icon(
                                        Icons.gps_fixed,
                                        size: 12,
                                        color: AppTheme.secondaryBlue,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppTheme.borderLight),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                                                      child: Text(
                                  'Lng: ${(_isTrackingBoundary && _currentGpsPosition != null ? _currentGpsPosition!.longitude : (_currentMapPosition ?? _currentLocation)!.longitude).toStringAsFixed(6)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                    ),
                                    if (_currentMapPosition != null && _currentMapPosition != _currentLocation)
                                      Icon(
                                        Icons.gps_fixed,
                                        size: 12,
                                        color: AppTheme.secondaryBlue,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_isMappingFarm) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isTrackingBoundary ? Icons.gps_fixed : Icons.location_on,
                                  size: 12,
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _isTrackingBoundary 
                                      ? 'GPS tracking active - Walk around your farm boundary (${_farmBoundary.length} points)'
                                      : 'Tap to add boundary point (${_farmBoundary.length} points)',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Map Section
              if (_showMap) ...[
                if (_isMappingFarm && _isTrackingBoundary)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Boundary points collected: ${_farmBoundary.length}',
                      style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                              // Initialize current map position
                              if (_currentLocation != null) {
                                _currentMapPosition = _currentLocation;
                              }
                            },
                            markers: _markers,
                            polygons: _polygons,
                            onTap: _onMapTap,
                            onCameraMove: _onCameraMove,
                            onCameraIdle: _onCameraIdle,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          )
                        : Container(
                            color: AppTheme.surfaceLight,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 48,
                                    color: AppTheme.textSecondary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Location not available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: _getCurrentLocation,
                                    child: const Text('Get Location'),
                                  ),
                                ],
                              ),
                            ),
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
                        label: Text(_isMappingFarm ? 'Stop Mapping' : 'Mapping'),
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
              GestureDetector(
                onTap: () {
                  _showCropSelectionDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderLight),
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.surfaceLight,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedCrops.isEmpty 
                              ? 'Select Crops' 
                              : '${_selectedCrops.length} crop(s) selected',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.primaryGreen,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Selected Crops Display
              if (_selectedCrops.isNotEmpty) ...[
                Text(
                  'Selected Crops:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedCrops.map((crop) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryGreen),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          crop,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCrops.remove(crop);
                            });
                          },
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
              ],
              
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
    _positionStream?.cancel();
    _boundaryTrackingTimer?.cancel();
    _nameController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 