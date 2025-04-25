import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HorizontalMovieCard extends StatelessWidget {
  final String movieImage;
  final String movieTitle;
  final String movieGenre;
  final String? movieScore;
  final String? movieDuration;
  final String? movieRated;
  final int index; // reminder: determine which movie to display

  HorizontalMovieCard({
    Key? key,
    required this.movieImage,
    required this.movieTitle,
    required this.movieGenre,
    this.movieScore,
    this.movieDuration,
    this.movieRated,
    required this.index,
  }) : super(key: key);

  bool isFilePath(String path) => !(path.startsWith('http://') || path.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF), // White
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1, // spreads
            blurRadius: 2,   // Softness
            offset: Offset(0, 0.8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // left part: image
          _leftPart(movieImage),

          const SizedBox(width: 18),

          // right part: details
          _rightPart(movieTitle, movieGenre, movieScore, movieDuration, movieRated)
        ]
      )
    );
  }

  // Widget _leftPart(dynamic desiredMovies) {
  Widget _leftPart(String movieImage) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff000000).withOpacity(0.1)),
        borderRadius: BorderRadius.circular(6)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: isFilePath(movieImage)
            ? Image.file(
                File(movieImage),
                height: 140,
                width: 90,
                fit: BoxFit.cover,
            )
            : Image.network(
                movieImage,
                height: 140,
                width: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 160,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 50, color: Colors.grey),
                  );
                }
              )
      )
    );
  }

  // Widget _rightPart(dynamic desiredMovies) {
  Widget _rightPart(String movieTitle, String movieGenre, String? movieScore, String? movieDuration, String? movieRated) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // top
          _rightTopPart(movieScore),
          const SizedBox(height: 12),

          // Bottom
          ..._rightBottomPart(movieTitle, movieGenre, movieDuration, movieRated)
        ]
      )
    );
  }

  // Widget _rightTopPart() {
  Widget _rightTopPart(String? movieScore) {
    return Row(
      children: [
        if (movieScore != null && movieScore.isEmpty) 
        ...[
          const Spacer(),

        // Rating
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xffDC555E),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/icon/star.svg'),
                const SizedBox(width: 4),
                Text(
                  movieScore,
                  style: const TextStyle(
                    color: Color(0xffFFFDF7),
                    fontFamily: "Montserrat",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.12,
                  ),
                ),
              ],
            ),
          ),
        ]
        else 
          SizedBox(height: 26)
      ],
    );
  }

  // Widget _rightBottomPart(dynamic desiredMovies) {
  List<Widget> _rightBottomPart(String movieTitle, String movieGenre, String? movieDuration, String? movieRated) {
    return [

      // Movie Title
      Text(
        movieTitle,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      
      const SizedBox(height: 8),
      
      SizedBox(
        height: 24,
        child: Row(
          children: [

            // Genre
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xff000000).withOpacity(0.08),
              ),
              child: Text(
                movieGenre,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(width: 8),

            if (movieDuration != null && movieDuration.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff000000).withOpacity(0.08),
                  // border: Border.all(color: Colors.black),
                ),
                child: Text(
                  movieDuration,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(width: 8)
            ],

            if (movieRated != null && movieRated.isNotEmpty)
              // Rated
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xff000000).withOpacity(0.08),
                  // border: Border.all(color: Colors.black),
                ),
                child: Text(
                  movieRated,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  )
                )
              )
          ]
        )
      )
    ];
  }
}