// import 'dart:io';

// import 'package:cinema_application/data/models/listmovie.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class HorizontalMovieCard extends StatelessWidget {
  final List nowMovies;
  final List upcomingMovies;
  final bool nowShowingIsClicked;
  final int index; // reminder: determine which movie to display

  HorizontalMovieCard({
    Key? key,
    required this.nowShowingIsClicked,
    required this.nowMovies,
    required this.upcomingMovies,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final desiredMovies = nowShowingIsClicked ? nowMovies[index] : upcomingMovies[index];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),   // White
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.2)), // Grey
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // left part: image
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff000000).withOpacity(0.1)),
              borderRadius: BorderRadius.circular(6)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: (desiredMovies['m_imageurl'] != null && desiredMovies['m_imageurl']!.isNotEmpty)
                  ? Image.file(
                      File(desiredMovies['m_imageurl']!),
                      height: 140,
                      width: 100,
                      fit: BoxFit.cover,
                  )
                : Image.network(
                    desiredMovies['m_imageurl'],
                    height: 140,
                    width: 100,
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
          ),

          const SizedBox(width: 16),

          // right part: details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // top
                Row(
                  children: [

                    // Rating
                    if (nowShowingIsClicked) ...[
                      const Spacer(),
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
                              "debug",
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
                      SizedBox(height: 26),
                  ],
                ),

                const SizedBox(height: 12),

                // Movie Title
                Text(
                  desiredMovies['m_title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Bottom
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
                          // border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          desiredMovies['m_genre'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (nowShowingIsClicked) ...[
                        Row(
                          children: [


                            // Time
                            // SvgPicture.asset('assets/icon/clock.svg'),
                            // const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xff000000).withOpacity(0.08),
                                // border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                "debug",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // R-rated
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xff000000).withOpacity(0.08),
                                // border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                "debug",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                )
                              )
                            )
                          ]
                        )
                      ]
                    ]
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}