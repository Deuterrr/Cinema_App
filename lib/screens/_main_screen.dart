import 'package:flutter/material.dart';

import 'package:cinema_application/screens/home_screen.dart';
import 'package:cinema_application/screens/promo_screen.dart';
import 'package:cinema_application/screens/profile_screen.dart';
import 'package:cinema_application/screens/purchases_screen.dart';

import 'package:cinema_application/components/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex = widget.initialIndex;
  late List<Widget> _pages;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      MyPromosPage(),
      MyTransactionPage(),
      MyProfilePage(
        onGoToTransaction: () => _onItemTap(2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: List.generate(_pages.length, (index) {
          final isActive = index == _selectedIndex;

          return Offstage(
            offstage: !isActive,
            child: AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: _pages[index],
            ),
          );
        }),
      ),

      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTap,
      ),
    );
  }
}