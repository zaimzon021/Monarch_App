import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'explore/explore_tab.dart';
import 'profile/profile_tab.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const ExploreTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_filled, size: 28)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.explore_outlined, size: 28)),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline, size: 28)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
