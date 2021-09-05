

import 'package:flutter/material.dart';
import 'colors.dart';

class Navbar extends StatefulWidget {
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  var _currentIndex = 0;

  void _switch(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, /* No switching animation */
      showSelectedLabels: false, /* Remove labels */
      showUnselectedLabels: false,
      selectedItemColor: WanderlistColors.Pink,
      unselectedItemColor: WanderlistColors.Grey,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Search',
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Flag',
          icon: Icon(Icons.flag_outlined),
          activeIcon: Icon(Icons.flag_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Hotel',
          activeIcon: Icon(Icons.hotel_rounded),
          icon: Icon(Icons.hotel_outlined),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: _switch,
    );
  }
}