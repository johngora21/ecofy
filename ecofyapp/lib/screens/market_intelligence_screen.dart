import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  final String selectedCrop;

  const MarketIntelligenceScreen({super.key, required this.selectedCrop});

  @override
  State<MarketIntelligenceScreen> createState() => _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Price Analysis',
    'Market Trends',
    'Demand & Supply',
    'Export Markets',
    'Local Markets',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market Intelligence - ${widget.selectedCrop}',
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
      body: Column(
        children: [
          // Tab Navigation
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedTabIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGreen : AppTheme.borderLight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _tabs[index],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildPriceAnalysis();
      case 1:
        return _buildMarketTrends();
      case 2:
        return _buildDemandSupply();
      case 3:
        return _buildExportMarkets();
      case 4:
        return _buildLocalMarkets();
      default:
        return _buildPriceAnalysis();
    }
  }

  Widget _buildPriceAnalysis() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Analysis',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Current Price Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.successGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Current Market Price',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'KES 2,500',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'per kilogram',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Price Trends
          Text(
            'Price Trends',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildTrendCard(
                  'This Month',
                  '+12%',
                  'KES 2,500',
                  AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTrendCard(
                  'Last Month',
                  '+8%',
                  'KES 2,200',
                  AppTheme.warningYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildTrendCard(
                  '3 Months Ago',
                  '+5%',
                  'KES 2,000',
                  AppTheme.secondaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTrendCard(
                  '6 Months Ago',
                  '-2%',
                  'KES 1,900',
                  AppTheme.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Price Forecast
          Text(
            'Price Forecast',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next 3 Months',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Expected to remain stable around KES 2,500/kg',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Seasonal fluctuations may cause 5-10% variations',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Export demand expected to increase prices by 15%',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrends() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Trends',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Trend Indicators
          Row(
            children: [
              Expanded(
                child: _buildTrendIndicator(
                  'Market Growth',
                  'Strong',
                  Icons.trending_up,
                  AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTrendIndicator(
                  'Volatility',
                  'Low',
                  Icons.show_chart,
                  AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildTrendIndicator(
                  'Competition',
                  'Medium',
                  Icons.people,
                  AppTheme.warningYellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTrendIndicator(
                  'Innovation',
                  'High',
                  Icons.lightbulb,
                  AppTheme.secondaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Key Trends
          Text(
            'Key Market Trends',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildTrendItem(
            'Organic Demand Rising',
            'Consumers increasingly prefer organic ${widget.selectedCrop} products',
            Icons.eco,
            AppTheme.successGreen,
          ),
          const SizedBox(height: 8),
          
          _buildTrendItem(
            'Export Opportunities',
            'Growing demand from neighboring countries',
            Icons.flight_takeoff,
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 8),
          
          _buildTrendItem(
            'Processing Industry',
            'Local processing companies expanding operations',
            Icons.factory,
            AppTheme.warningYellow,
          ),
          const SizedBox(height: 8),
          
          _buildTrendItem(
            'Technology Adoption',
            'Smart farming practices increasing yields',
            Icons.agriculture,
            AppTheme.secondaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildDemandSupply() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demand & Supply Analysis',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Demand Analysis
          Text(
            'Demand Analysis',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildDemandCard(
                  'Local Demand',
                  'High',
                  '85%',
                  Icons.home,
                  AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDemandCard(
                  'Export Demand',
                  'Medium',
                  '60%',
                  Icons.flight_takeoff,
                  AppTheme.warningYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildDemandCard(
                  'Processing Demand',
                  'High',
                  '90%',
                  Icons.factory,
                  AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDemandCard(
                  'Retail Demand',
                  'Medium',
                  '70%',
                  Icons.shopping_cart,
                  AppTheme.secondaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Supply Analysis
          Text(
            'Supply Analysis',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supply Status: Medium',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '• Current production meets 75% of total demand',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Import gap of 25% during peak demand periods',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Seasonal supply fluctuations affect pricing',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportMarkets() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Markets',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Top Export Markets
          Text(
            'Top Export Markets',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildExportMarketCard(
            'Uganda',
            'KES 3,200/kg',
            'High demand for quality ${widget.selectedCrop}',
            '25%',
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 12),
          
          _buildExportMarketCard(
            'Tanzania',
            'KES 2,800/kg',
            'Growing market for processed products',
            '20%',
            AppTheme.successGreen,
          ),
          const SizedBox(height: 12),
          
          _buildExportMarketCard(
            'South Sudan',
            'KES 3,500/kg',
            'Premium market for organic products',
            '15%',
            AppTheme.warningYellow,
          ),
          const SizedBox(height: 12),
          
          _buildExportMarketCard(
            'DR Congo',
            'KES 2,600/kg',
            'Stable demand for bulk shipments',
            '10%',
            AppTheme.secondaryBlue,
          ),
          const SizedBox(height: 20),
          
          // Export Requirements
          Text(
            'Export Requirements',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Phytosanitary certificates required',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Quality standards compliance mandatory',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Proper packaging and labeling essential',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalMarkets() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local Markets',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Major Local Markets
          Text(
            'Major Local Markets',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildLocalMarketCard(
            'Nairobi',
            'KES 2,500/kg',
            'Central market hub',
            '40%',
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 12),
          
          _buildLocalMarketCard(
            'Mombasa',
            'KES 2,300/kg',
            'Coastal market',
            '20%',
            AppTheme.successGreen,
          ),
          const SizedBox(height: 12),
          
          _buildLocalMarketCard(
            'Kisumu',
            'KES 2,400/kg',
            'Western region hub',
            '15%',
            AppTheme.warningYellow,
          ),
          const SizedBox(height: 12),
          
          _buildLocalMarketCard(
            'Nakuru',
            'KES 2,600/kg',
            'Rift Valley market',
            '10%',
            AppTheme.secondaryBlue,
          ),
          const SizedBox(height: 20),
          
          // Market Channels
          Text(
            'Market Channels',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Direct to consumers (30% of sales)',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Wholesale markets (45% of sales)',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Processing companies (25% of sales)',
                  style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Widget _buildTrendCard(String period, String change, String price, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(String title, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
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
            status,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemandCard(String type, String level, String percentage, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            type,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            level,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            percentage,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportMarketCard(String country, String price, String description, String share, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.public, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      country,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        share,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalMarketCard(String city, String price, String description, String share, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.location_city, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      city,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        share,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 