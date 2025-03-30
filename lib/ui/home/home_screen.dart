import 'package:communityeye_frontend/ui/map/map_screen.dart';
import 'package:communityeye_frontend/ui/profile/profile_screen.dart';
import 'package:communityeye_frontend/ui/reports/myreports_screen.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  late MotionTabBarController _tabBarController;

  static final List<Widget> _screens = <Widget>[
    const MyReportsScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabBarController = MotionTabBarController(
      initialIndex: _selectedIndex,
      length: _screens.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabBarController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: MotionTabBar(
        controller: _tabBarController,
        initialSelectedTab: "Maps",
        labels: const ["My Reports", "Maps", "Profile"],
        icons: const [
          Icons.assignment,
          Icons.map,
          Icons.person,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        onTabItemSelected: _onItemTapped,
      ),
    );
  }
}
