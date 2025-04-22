import 'package:flutter/material.dart';

class MovieListContainer extends StatelessWidget {
  final double height;
  final bool isLoading;
  final List<dynamic>? movieList;
  final Widget Function(List<dynamic>) builder;

  const MovieListContainer({
    super.key,
    required this.height,
    required this.isLoading,
    required this.movieList,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieList == null || movieList!.isEmpty
              ? const Center(
                  child: Text(
                    'Please ensure network is available',
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF0E2522),
                    ),
                  ),
                )
              : builder(movieList!),
    );
  }
}
