import 'package:flutter/material.dart';

import 'package:cinema_application/screens/booking/movie_details.dart';
import 'package:cinema_application/components/movie/movie_card/vertical_movie_card.dart';

class HorizontalMovieList extends StatelessWidget {
  final List desiredMovies;

  const HorizontalMovieList({Key? key, required this.desiredMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Row(
          children: List.generate(desiredMovies.length, (index) {
            String imagePath = desiredMovies[index]['m_imageurl'];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Moviedetail(
                      movieTitle: desiredMovies[index]['m_title'],
                      movieImage: imagePath,
                      movieGenre: desiredMovies[index]['m_genre'],
                      movieDescription: 'huhaa',
                      movieRating: '3',
                      movieYears: '2025',
                      movieDuration: '120 Min',
                      movieWatchlist: 'movieWatchlist',
                    ),
                  ),
                );
              },
              child: Container(
                width: 146,
                // MediaQuery.of(context).size.width * 0.4, // Adjust width like viewportFraction
                padding: const EdgeInsets.symmetric(horizontal:7), // Adjust spacing
                child: VerticalMovieCard(
                  bigSize: false,
                  useTitle: true,
                  movieTitle: desiredMovies[index]['m_title'],
                  movieImage: imagePath,
                  movieGenre: desiredMovies[index]['m_genre'],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}