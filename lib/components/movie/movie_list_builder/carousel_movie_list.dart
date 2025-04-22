import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:cinema_application/screens/booking/movie_details.dart';
import 'package:cinema_application/components/movie/movie_card/vertical_movie_card.dart';

class CarouselMovieList extends StatefulWidget {
  final List desiredMovies;

  const CarouselMovieList({
    Key? key,
    required this.desiredMovies
  }) : super(key: key);

  @override
  _CarouselMovieList createState() => _CarouselMovieList();
}

class _CarouselMovieList extends State<CarouselMovieList> {
  int _currentIndex = 0; // track for title section

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // Image Slider (Upper Section)
        CarouselSlider.builder(
          itemCount: widget.desiredMovies.length,
          options: CarouselOptions(
            height: 344,
            viewportFraction: 0.62,
            enableInfiniteScroll: true,
            autoPlay: false,
            enlargeCenterPage: true,
            disableCenter: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            String imagePath = widget.desiredMovies[index]['m_imageurl'];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Moviedetail(
                      movieTitle: widget.desiredMovies[index]['m_title'],
                      movieImage: imagePath,
                      movieGenre: widget.desiredMovies[index]['m_genre'],
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: VerticalMovieCard(
                  bigSize: true,
                  useTitle: false,
                  movieTitle: widget.desiredMovies[index]['m_title'],
                  movieImage: imagePath,
                  movieGenre: widget.desiredMovies[index]['m_genre'],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        // Movie Title & Genre
        Container(
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                widget.desiredMovies[_currentIndex]['m_title'],
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E2522) // Black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2),
              Text(
                widget.desiredMovies[_currentIndex]['m_genre'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0E2522), // Black
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        )
      ],
    );
  }
}