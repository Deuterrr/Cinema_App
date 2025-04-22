import 'package:flutter/material.dart';

import 'package:cinema_application/screens/booking/movie_details.dart';
import 'package:cinema_application/components/movie/movie_card/horizontal_movie_card.dart';

class VerticalMovieList extends StatelessWidget {
  final bool nowShowingIsClicked;
  final List nowMovies;
  final List<dynamic> upcomingMovies;

  const VerticalMovieList({
    Key? key,
    required this.nowShowingIsClicked,
    required this.nowMovies,
    required this.upcomingMovies,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.blue, // debug
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
        child: Column(
          children: List.generate(
            nowShowingIsClicked ? nowMovies.length : upcomingMovies.length,
            (index) {
              final desiredMovies = nowShowingIsClicked
                  ? nowMovies[index]
                  : upcomingMovies[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Moviedetail(
                        movieTitle:         desiredMovies['m_title'],
                        movieImage:         desiredMovies['m_imageurl'],
                        movieGenre:         desiredMovies['m_genre'],
                        movieDescription:   "debug",
                        movieRating:        "debug",
                        movieYears:         "debug",
                        movieDuration:      "debug",
                        movieWatchlist:     "debug",
                      )
                    )
                  );
                },
                child: HorizontalMovieCard(
                  nowShowingIsClicked: nowShowingIsClicked,
                  nowMovies: nowMovies,
                  upcomingMovies: upcomingMovies,
                  index: index,
                ),
              );
            },
          ),
        ),
      ),
    );

  }
}