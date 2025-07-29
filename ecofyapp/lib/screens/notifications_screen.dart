import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = ['All', 'Orders', 'Market', 'System', 'Promotions'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Order Delivered',
      'message': 'Your order ORD-001 has been successfully delivered to Arusha, Tanzania.',
      'type': 'Orders',
      'timestamp': '2 hours ago',
      'isRead': false,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'id': '2',
      'title': 'Price Alert',
      'message': 'Maize prices have increased by 12% in your region. Consider selling now.',
      'type': 'Market',
      'timestamp': '4 hours ago',
      'isRead': false,
      'icon': Icons.trending_up,
      'color': Colors.orange,
    },
    {
      'id': '3',
      'title': 'New Product Available',
      'message': 'H6213 drought-resistant maize seeds are now available in your area.',
      'type': 'Market',
      'timestamp': '1 day ago',
      'isRead': true,
      'icon': Icons.inventory,
      'color': Colors.blue,
    },
    {
      'id': '4',
      'title': 'Weather Update',
      'message': 'Heavy rainfall expected in your region. Plan your farming activities accordingly.',
      'type': 'System',
      'timestamp': '1 day ago',
      'isRead': true,
      'icon': Icons.wb_sunny,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'Special Offer',
      'message': 'Get 20% off on all fertilizers this week. Limited time offer!',
      'type': 'Promotions',
      'timestamp': '2 days ago',
      'isRead': true,
      'icon': Icons.local_offer,
      'color': Colors.red,
    },
    {
      'id': '6',
      'title': 'Order Shipped',
      'message': 'Your order ORD-002 is on its way. Expected delivery in 2-3 days.',
      'type': 'Orders',
      'timestamp': '3 days ago',
      'isRead': true,
      'icon': Icons.local_shipping,
      'color': Colors.blue,
    },
    {
      'id': '7',
      'title': 'Market Analysis Ready',
      'message': 'Your comprehensive market analysis for maize is now available.',
      'type': 'System',
      'timestamp': '3 days ago',
      'isRead': true,
      'icon': Icons.analytics,
      'color': Colors.green,
    },
    {
      'id': '8',
      'title': 'Farming Tips',
      'message': 'New farming techniques for better maize yield are now available.',
      'type': 'System',
      'timestamp': '4 days ago',
      'isRead': true,
      'icon': Icons.tips_and_updates,
      'color': Colors.teal,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    }
    return _notifications.where((notification) => notification['type'] == _selectedFilter).toList();
  }

  int get _unreadCount {
    return _notifications.where((notification) => !notification['isRead']).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_unreadCount',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppTheme.primaryGreen : Colors.white,
                        foregroundColor: isSelected ? Colors.white : AppTheme.textSecondary,
                        elevation: isSelected ? 0 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryGreen : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 64, color: AppTheme.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re all caught up!',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: notification['isRead'] 
            ? Border.all(color: Colors.grey[200]!)
            : Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification['icon'],
                color: notification['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.w600,
                            color: notification['isRead'] ? AppTheme.textPrimary : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (!notification['isRead'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: notification['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notification['type'],
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: notification['color'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification['timestamp'],
                        style: GoogleFonts.poppins(
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
      ),
    );
  }
} 