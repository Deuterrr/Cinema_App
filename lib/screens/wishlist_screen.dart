import 'package:cinema_application/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class MyWishlistPage extends StatefulWidget {
  const MyWishlistPage({super.key});

  @override
  State<MyWishlistPage> createState() => _MyWishlistPageState();
}

class _MyWishlistPageState extends State<MyWishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFFFFFFF), // White
      backgroundColor: Color(0xFFf0f3f8), // Flat White
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: CustomAppBar(
          centerText: 'Wishlist',
          showBackButton: false
        ),
      ),
      body: Center(
        child: Text(
          "Favorite Pages"
        ),
      ),
    );
  }
}