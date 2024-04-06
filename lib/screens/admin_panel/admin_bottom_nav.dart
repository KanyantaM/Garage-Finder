import 'package:fixtex/screens/admin_panel/all_garages_screen.dart';
import 'package:fixtex/screens/admin_panel/all_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminBottomNav> {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() async {
    setState(() {
      _screens = [
        const UserDetailsScreen(),
        GarageDetailsScreen(),
        // StatsScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.building_2_fill),
            label: 'Garages',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.graph_circle),
          //   label: 'State',
          // ),
        ],
      ),
    );
  }
}



