import 'package:flutter/material.dart';

import 'package:cinema_application/screens/home_screen.dart';
import 'package:cinema_application/screens/promo_screen.dart';
import 'package:cinema_application/screens/profile_screen.dart';
import 'package:cinema_application/screens/purchases_screen.dart';

import 'package:cinema_application/components/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  final List<Widget> _pages = [
    const HomePage(),
    const MyPromosPage(),
    const MyTransactionPage(),
    const MyProfilePage(),
  ];

  int _selectedIndex = 0;

  void _onItemTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0 || index == 1 || index == 3) {
            return KeepAliveWrapper(child: _pages[index]);
          } else {
            return _pages[index]; // These pages will unload when not visible
          }
        },
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTap,
      ),
    );
  }
}

// Wrapper to prevent refresh on selected pages
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}