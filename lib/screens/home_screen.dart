import 'package:drivety_app/models/status_data.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/menu_card.dart';
import '../widgets/status_item.dart';
import '../services/auth_service.dart'; // Import the auth service

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';
  String _userRole = 'Safety Officer';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from AuthService
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await AuthService.getCurrentUser();
      setState(() {
        _userName = userData['userName'] ?? 'User';
        _userRole = userData['userRole'] ?? 'Safety Officer';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading user data: $e');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout();
              },
              child: const Text('LOGOUT'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Call logout method from AuthService
      final success = await AuthService.logout();

      // Close loading indicator
      Navigator.of(context).pop();

      if (success) {
        // Navigate to login screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have been logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to logout. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sliver App Bar
            SliverAppBar(
              expandedHeight: 150.0, // Reduced height
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Driverty',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withAlpha(204),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withAlpha(26), // 0.1 opacity (26/255)
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -50,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withAlpha(26), // 0.1 opacity (26/255)
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Icon(
                            Icons.shield,
                            size: 40, // Reduced size
                            color: Colors.white
                                .withAlpha(179), // 0.7 opacity (179/255)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notifications coming soon!')),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'profile') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile coming soon!')),
                      );
                    } else if (value == 'logout') {
                      _showLogoutDialog();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 8),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(51), // 0.2 opacity (51/255)
                                  radius: 24,
                                  child: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome, $_userName',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _userRole,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Today\'s Safety Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Status Items - Using Wrap for better responsiveness
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.spaceAround,
                              children: _buildStatusItems(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Menu Title
                    Text(
                      'Safety Menu',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Menu Grid in a separate SliverToBoxAdapter to avoid overflow
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  // Using a fixed height for the grid to prevent overflow
                  height: MediaQuery.of(context).size.width > 600
                      ? 230 // Height for larger screens (1 row of 4)
                      : 460, // Height for smaller screens (2 rows of 2)
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: Constants.menuOptions.length,
                    itemBuilder: (context, index) {
                      return MenuCard(option: Constants.menuOptions[index]);
                    },
                  ),
                ),
              ),
            ),

            // Bottom padding to prevent FAB overlap
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency feature coming soon!')),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency),
      ),
    );
  }

  List<Widget> _buildStatusItems() {
    return StatusData.items
        .map((item) => Expanded(
              child: StatusItem(
                icon: item['icon'],
                label: item['label'],
                value: item['value'],
                color: item['color'],
              ),
            ))
        .toList();
  }
}
