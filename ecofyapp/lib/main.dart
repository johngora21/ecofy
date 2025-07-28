import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/market_price_screen.dart';
import 'screens/farms_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/resources_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EcofyApp());
}

class EcofyApp extends StatelessWidget {
  const EcofyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecofy',
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/market': (context) => const MarketplaceScreen(),
        '/market-price': (context) => const MarketPriceScreen(),
        '/farms': (context) => const FarmsScreen(),
        '/resources': (context) => const ResourcesScreen(),
        '/orders': (context) => const OrdersScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MarketplaceScreen(),
    const FarmsScreen(),
    const ResourcesScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Marketplace',
    'Farms',
    'Resources',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.primaryGreenDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ecofy User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'user@ecofy.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: AppTheme.primaryGreen),
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: AppTheme.primaryGreen),
              title: const Text('Market Price'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/market-price');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppTheme.primaryGreen),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: AppTheme.primaryGreen),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to reports
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: AppTheme.textSecondary),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorRed),
              title: const Text('Logout', style: TextStyle(color: AppTheme.errorRed)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Handle logout
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.textTertiary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Farms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
