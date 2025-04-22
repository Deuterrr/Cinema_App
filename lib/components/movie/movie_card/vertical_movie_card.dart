import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class VerticalMovieCard extends StatelessWidget {
  final bool bigSize;

  // movie credentials
  final String movieTitle;
  final String? movieImage;
  final String movieGenre;
  final bool useTitle;

  VerticalMovieCard({
    Key? key,
    required this.bigSize,
    required this.movieTitle,
    required this.movieImage,
    required this.movieGenre,
    required this.useTitle,
  }) : super(key: key);

  double get imageHeight => bigSize ? 332 : 212;
  double get imageWidth => bigSize ? 220 : 150;
  double get rightMargin => bigSize ? 12 : 8;
  double get dividerBox => bigSize ? 12 : 8;
  double get dividerTitleGenre => bigSize ? 5 : 4;
  double get borderWeight => bigSize ? 1.4 : 1;
  double get borderRadius => bigSize ? 8 : 6;
  // double get imageHeight => bigSize ? 260 : 184;
  // double get cardWidth => bigSize ? 0 : 0;
  // double get cardShadowDX => bigSize ? 3.4 : 3;
  // double get cardShadowDY => bigSize ? 4.2 : 3.8;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF0E2522).withOpacity(0.3), // Black
                width: borderWeight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: SizedBox(
              // color: Colors.yellow, // debug purpose
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius-1),
                child: (movieImage != null && movieImage!.isNotEmpty)
                    ? Image.file(
                        File(movieImage!),
                        fit: BoxFit.cover,
                        width: imageWidth,
                      )
                    : SvgPicture.asset(
                        'assets/icon/not_found.svg',
                        fit: BoxFit.scaleDown,
                      )
              
              )
            )
          ),

          useTitle
              ? SizedBox(height: dividerBox)
              : SizedBox(height: 0),

          useTitle
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: bigSize ? 16 : 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0E2522), // Black
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: bigSize ? 2 : 1,
                      ),

                      SizedBox(height: dividerTitleGenre),

                      Text(
                        movieGenre,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: bigSize ? 11 : 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E2522), // Black
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )
                )
            : SizedBox(height: 0),
        ],
      )  
    );
  }
}

Widget _buildMoviePoster(String imagePath) {
  if (imagePath.startsWith('/')) {
    return Image.file(File(imagePath), fit: BoxFit.cover);
  } else {
    return Image.network(imagePath, fit: BoxFit.cover);
  }
}