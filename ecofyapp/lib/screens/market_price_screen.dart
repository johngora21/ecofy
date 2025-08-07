import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_theme.dart';
import '../services/api_service.dart';
import '../data/tanzania_crops.dart';
import '../data/tanzania_regions.dart';

class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({super.key});

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  String _activeTab = 'crop-prices';
  String _selectedCrop = 'Maize';
  String _selectedUnit = 'Kilogram (kg)';
  String _selectedLocation = 'Arusha';
  String _selectedPeriod = '3 Months';

  // Loading states
  bool _isLoading = false;
  String? _error;

  // Real data from backend
  List<Map<String, dynamic>> _crops = [];
  List<Map<String, dynamic>> _marketPrices = [];
  List<Map<String, dynamic>> _marketTrends = [];
  Map<String, dynamic>? _currentCropData;

  final List<String> _units = [
    'Kilogram (kg)',
    'Ton (t)',
    'Bag (50kg)',
    'Bag (100kg)',
    'Piece',
    'Liter (L)',
  ];

  final List<String> _locations = [
    'Arusha',
    'Dar es Salaam',
    'Dodoma',
    'Mbeya',
    'Morogoro',
    'Mwanza',
    'Tanga',
    'Iringa',
    'Tabora',
    'Kigoma',
  ];

  final List<String> _periods = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    '5 Years',
  ];

  final List<Map<String, String>> _tabs = [
    {'id': 'crop-prices', 'label': 'Crop Prices'},
    {'id': 'comparison', 'label': 'Comparison'},
    {'id': 'news', 'label': 'News'},
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load crops from backend
      final cropsData = await ApiService.getCrops();
      setState(() {
        _crops = cropsData;
        if (_crops.isNotEmpty) {
          _selectedCrop = _crops.first['name'];
        }
      });

      // Load market prices
      await _loadMarketPrices();
      
      // Load market trends for selected crop
      await _loadMarketTrends();

    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMarketPrices() async {
    try {
      final marketData = await ApiService.getMarketPrices();
      setState(() {
        _marketPrices = marketData['data'] ?? [];
      });
    } catch (e) {
      print('Error loading market prices: $e');
    }
  }

  Future<void> _loadMarketTrends() async {
    if (_selectedCrop.isEmpty) return;

    try {
      // Find crop ID for selected crop
      final selectedCropData = _crops.firstWhere(
        (crop) => crop['name'] == _selectedCrop,
        orElse: () => {'id': ''},
      );

      if (selectedCropData['id'] != null && selectedCropData['id'].isNotEmpty) {
        final trendsData = await ApiService.getMarketTrends(
          selectedCropData['id'],
          period: _getPeriodForApi(),
        );
        setState(() {
          _marketTrends = trendsData;
        });
      }
    } catch (e) {
      print('Error loading market trends: $e');
    }
  }

  String _getPeriodForApi() {
    switch (_selectedPeriod) {
      case '1 Month':
        return 'month';
      case '3 Months':
        return 'month';
      case '6 Months':
        return 'month';
      case '1 Year':
        return 'year';
      case '2 Years':
        return 'year';
      case '5 Years':
        return 'year';
      default:
        return 'month';
    }
  }

  void _onCropChanged(String? newValue) async {
    if (newValue != null && newValue != _selectedCrop) {
      setState(() {
        _selectedCrop = newValue;
      });
      await _loadMarketTrends();
    }
  }

  void _onLocationChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedLocation = newValue;
      });
    }
  }

  void _onPeriodChanged(String? newValue) async {
    if (newValue != null && newValue != _selectedPeriod) {
      setState(() {
        _selectedPeriod = newValue;
      });
      await _loadMarketTrends();
    }
  }

  Map<String, dynamic>? _getCurrentCropMarketData() {
    return _marketPrices.firstWhere(
      (price) => price['crop_name'] == _selectedCrop,
      orElse: () => {},
    );
  }

  // Mock data for price trends
  Map<String, List<Map<String, dynamic>>> _priceData = {
    'Maize': [
      {'date': 'Jan', 'price': 1200.0, 'volume': 1500.0},
      {'date': 'Feb', 'price': 1350.0, 'volume': 1800.0},
      {'date': 'Mar', 'price': 1420.0, 'volume': 2000.0},
      {'date': 'Apr', 'price': 1380.0, 'volume': 1900.0},
      {'date': 'May', 'price': 1550.0, 'volume': 2200.0},
      {'date': 'Jun', 'price': 1680.0, 'volume': 2400.0},
    ],
    'Rice': [
      {'date': 'Jan', 'price': 2800.0, 'volume': 800.0},
      {'date': 'Feb', 'price': 2950.0, 'volume': 900.0},
      {'date': 'Mar', 'price': 3100.0, 'volume': 1000.0},
      {'date': 'Apr', 'price': 3250.0, 'volume': 1100.0},
      {'date': 'May', 'price': 3400.0, 'volume': 1200.0},
      {'date': 'Jun', 'price': 3550.0, 'volume': 1300.0},
    ],
    'Beans': [
      {'date': 'Jan', 'price': 1800.0, 'volume': 600.0},
      {'date': 'Feb', 'price': 1950.0, 'volume': 700.0},
      {'date': 'Mar', 'price': 2100.0, 'volume': 800.0},
      {'date': 'Apr', 'price': 2250.0, 'volume': 900.0},
      {'date': 'May', 'price': 2400.0, 'volume': 1000.0},
      {'date': 'Jun', 'price': 2550.0, 'volume': 1100.0},
    ],
  };

  // Mock data for regional comparison
  Map<String, Map<String, double>> _regionalData = {
    'Maize': {
      'Arusha': 1680,
      'Dar es Salaam': 1750,
      'Dodoma': 1620,
      'Mbeya': 1580,
      'Morogoro': 1650,
      'Mwanza': 1700,
      'Tanga': 1630,
      'Iringa': 1600,
      'Tabora': 1550,
      'Kigoma': 1570,
    },
    'Rice': {
      'Arusha': 3550,
      'Dar es Salaam': 3800,
      'Dodoma': 3400,
      'Mbeya': 3350,
      'Morogoro': 3500,
      'Mwanza': 3650,
      'Tanga': 3450,
      'Iringa': 3400,
      'Tabora': 3300,
      'Kigoma': 3350,
    },
    'Beans': {
      'Arusha': 2550,
      'Dar es Salaam': 2700,
      'Dodoma': 2450,
      'Mbeya': 2400,
      'Morogoro': 2500,
      'Mwanza': 2600,
      'Tanga': 2480,
      'Iringa': 2420,
      'Tabora': 2350,
      'Kigoma': 2380,
    },
  };

  // Mock news data
  final List<Map<String, dynamic>> _newsData = [
    {
      'title': 'Maize Prices Surge 15% in Arusha Region',
      'summary': 'Strong demand and limited supply drive prices up in the northern region.',
      'date': '2024-06-15',
      'category': 'Price Alert',
      'impact': 'High',
    },
    {
      'title': 'Government Announces New Agricultural Subsidies',
      'summary': 'Farmers to receive support for improved seeds and fertilizers.',
      'date': '2024-06-14',
      'category': 'Policy',
      'impact': 'Medium',
    },
    {
      'title': 'Rice Production Expected to Increase by 20%',
      'summary': 'Favorable weather conditions boost rice cultivation across Tanzania.',
      'date': '2024-06-13',
      'category': 'Production',
      'impact': 'Medium',
    },
    {
      'title': 'Export Demand Drives Bean Prices Higher',
      'summary': 'International markets show strong interest in Tanzanian beans.',
      'date': '2024-06-12',
      'category': 'Market Trend',
      'impact': 'High',
    },
  ];

  Widget _buildPriceChart() {
    if (_marketTrends.isEmpty) {
      return Container(
        height: 300,
        padding: const EdgeInsets.all(16),
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
        child: const Center(
          child: Text('No price trend data available'),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1.5,
          child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 200,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.borderLight,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: AppTheme.borderLight,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= 0 && value.toInt() < _marketTrends.length) {
                    final date = _marketTrends[value.toInt()]['date'] ?? '';
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 200,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt()}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  );
                },
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppTheme.borderLight),
          ),
          minX: 0,
          maxX: (_marketTrends.length - 1).toDouble(),
          minY: 0,
          maxY: _marketTrends.map((e) => (e['price'] as num).toDouble()).reduce((a, b) => a > b ? a : b) + 200,
          lineBarsData: [
            LineChartBarData(
              spots: _marketTrends.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), (entry.value['price'] as num).toDouble());
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.withOpacity(0.3)],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppTheme.primaryGreen,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.3),
                    AppTheme.primaryGreen.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeChart() {
    final data = _priceData[_selectedCrop] ?? [];
    if (data.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: data.map((e) => e['volume'] as double).reduce((a, b) => a > b ? a : b) + 200,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            data[value.toInt()]['date'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppTheme.borderLight),
              ),
              barGroups: data.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['volume'].toDouble(),
                      color: AppTheme.secondaryBlue,
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 200,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.borderLight,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegionalComparisonChart() {
    final regionalPrices = _regionalData[_selectedCrop] ?? {};
    if (regionalPrices.isEmpty) return const SizedBox.shrink();

    final sortedData = regionalPrices.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1.5,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: sortedData.first.value + 100,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: AppTheme.primaryGreen,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${sortedData[group.x].key}\n${rod.toY.toInt()} TZS',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      if (value.toInt() >= 0 && value.toInt() < sortedData.length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            sortedData[value.toInt()].key,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(
                        '${value.toInt()}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: AppTheme.borderLight),
              ),
              barGroups: sortedData.asMap().entries.map((entry) {
                final isSelectedLocation = entry.value.key == _selectedLocation;
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: isSelectedLocation ? AppTheme.primaryGreen : AppTheme.secondaryBlue,
                      width: 25,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 200,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.borderLight,
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCropPricesTab() {
    final currentCropData = _getCurrentCropMarketData();
    final currentPrice = currentCropData?['current_price'] ?? 0.0;
    final percentChange = currentCropData?['percent_change'] ?? 0.0;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: AppTheme.errorRed, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
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
              onPressed: _loadInitialData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Summary Card
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: AppTheme.primaryGreen, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Current Price',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${currentPrice.toInt()} TZS',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: percentChange >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            percentChange >= 0 ? Icons.trending_up : Icons.trending_down,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${percentChange.abs().toStringAsFixed(1)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'per $_selectedUnit in $_selectedLocation',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Price Trend Chart
          Text(
            'Price Trend',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceChart(),
          const SizedBox(height: 20),

          // Volume Chart
          Text(
            'Trading Volume',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildVolumeChart(),
          const SizedBox(height: 20),

          // Market Statistics
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Market Statistics',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Current Price', 
                        '${currentPrice.toInt()} TZS', 
                        Icons.trending_up, 
                        AppTheme.successGreen
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Price Change', 
                        '${percentChange.toStringAsFixed(1)}%', 
                        Icons.trending_up, 
                        percentChange >= 0 ? AppTheme.successGreen : AppTheme.errorRed
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Market Status', 
                        percentChange >= 0 ? 'Rising' : 'Falling', 
                        Icons.analytics, 
                        AppTheme.secondaryBlue
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Recommendation', 
                        currentCropData?['recommendation']?.split('.')[0] ?? 'No data', 
                        Icons.lightbulb, 
                        AppTheme.warningYellow
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regional Comparison Chart
          Text(
            'Regional Price Comparison',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRegionalComparisonChart(),
          const SizedBox(height: 20),

          // Regional Price List
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price by Region',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...(_regionalData[_selectedCrop] ?? {}).entries.map((entry) {
                  final isSelected = entry.key == _selectedLocation;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isSelected ? AppTheme.primaryGreen : AppTheme.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${entry.value.toInt()} TZS',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market News & Updates',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._newsData.map((news) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getImpactColor(news['impact']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news['category'],
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getImpactColor(news['impact']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news['impact'],
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _getImpactColor(news['impact']),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      news['date'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  news['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news['summary'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Color _getImpactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'high':
        return AppTheme.errorRed;
      case 'medium':
        return AppTheme.warningYellow;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'crop-prices':
        return _buildCropPricesTab();
      case 'comparison':
        return _buildComparisonTab();
      case 'news':
        return _buildNewsTab();
      default:
        return _buildCropPricesTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Green Top Bar with Back Arrow and Title Only
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Market Price',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Selection Dropdowns (Outside Green Bar)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Crop and Unit Selection Row
                Row(
                  children: [
                    // Crop Selection
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCrop,
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryGreen),
                          items: TanzaniaCrops.getCropNames().map((crop) {
                            return DropdownMenuItem<String>(
                              value: crop,
                              child: Text(
                                crop,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onCropChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Unit Selection
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedUnit,
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryGreen),
                          items: _units.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(
                                unit,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedUnit = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Location and Period Selection Row
                Row(
                  children: [
                    // Location Selection
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedLocation,
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryGreen),
                          items: TanzaniaRegions.getRegionNames().map((location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Text(
                                location,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onLocationChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Period Selection
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          isExpanded: true,
                          underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryGreen),
                          items: _periods.map((period) {
                            return DropdownMenuItem<String>(
                              value: period,
                              child: Text(
                                period,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onPeriodChanged,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Horizontal Tab Buttons
                Row(
                  children: _tabs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tab = entry.value;
                    final isSelected = _activeTab == tab['id'];
                    
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeTab = tab['id']!;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tab['label']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }
} 
