import 'dart:io';
import 'dart:ui';

import 'package:cinema_application/components/fetch/fetch_state_builder.dart';
import 'package:cinema_application/components/movie/movie_filter_panel.dart';
import 'package:cinema_application/components/open_dialog.dart';
// import 'package:cinema_application/components/selection_panel.dart';
import 'package:cinema_application/data/helpers/apihelper.dart';
import 'package:cinema_application/data/helpers/fetch_status.dart';
import 'package:flutter/material.dart';

import 'package:cinema_application/data/services/location_services.dart';
import 'package:cinema_application/data/services/movie_services.dart';

import 'package:cinema_application/screens/booking/movie_details.dart';
import 'package:cinema_application/screens/booking/search_movie.dart';

import 'package:cinema_application/components/custom_appbar.dart';
import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:cinema_application/components/location_panel.dart';
import 'package:cinema_application/components/movie/movie_card/horizontal_movie_card.dart';
import 'package:cinema_application/components/selection_state.dart';

class ExploreMovies extends StatefulWidget {
  final bool nowShowingIsClicked;
  final List<dynamic>? nowMovies;
  final List<dynamic>? upcomingMovies;

  const ExploreMovies({
    super.key, 
    required this.nowShowingIsClicked,
    required this.nowMovies,
    required this.upcomingMovies
  });

  @override
  State<ExploreMovies> createState() => _ExploreMoviesState();
}

class _ExploreMoviesState extends State<ExploreMovies> {
  /// selected filter movies
  String _selectedOption = 'Latest';

  /// location to be shown
  String currentLocation = '          ';

  /// movie data
  List<dynamic>? allNowPlaying;
  List<dynamic>? allUpcoming;
  late dynamic desiredMovies;

  /// movie counts
  String totalNowPlaying = "";
  String totalUpcoming = "";

  /// view control
  late bool nowShowingIsClicked;
  // bool isLoading = true;
  bool nowUsingGrid = false;
  FetchStatus _fetchStatus = FetchStatus.loading;

  /// services
  final movieServices = MovieServices();
  final locationServices = LocationServices();
  final apiHelper = ApiHelper();

  @override
  void initState() {
    super.initState();

    nowShowingIsClicked = widget.nowShowingIsClicked;
    allNowPlaying = widget.nowMovies ?? [];
    allUpcoming = widget.upcomingMovies ?? [];

    desiredMovies = nowShowingIsClicked ? allNowPlaying : allUpcoming;

    totalNowPlaying = allNowPlaying!.length.toString();
    totalUpcoming = allUpcoming!.length.toString();

    _loadSavedLocation();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      /// appbar
      appBar: CustomAppBar(
        centerText: "Explore",
        showBottomBorder: false,
        trailingButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// location button
            CustomIconButton(
              icon: Icons.location_on_outlined,
              onPressed: () => openDialog(
                context, 0.76, 
                "Pick your location", 
                LocationPanel(onSelect: _updateFromLocationPanel)
              ),
              usingText: true,
              theText: currentLocation,
              color: Color(0xFFFEC958), // Orange
            ),
            const SizedBox(width: 6),

            /// search button
            CustomIconButton(
              icon: Icons.search_rounded,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
              usingText: false,
              color: const Color(0xFFF686F6), // Magenta
            )
          ],
        ),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadSavedLocation();
            _fetchMovies();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Top Section
              _topSection(),
              const SizedBox(height: 6),

              /// Movie List Section
              Expanded(
                child: nowUsingGrid
                    ? FetchStateBuilder(
                        fetchStatus: _fetchStatus,
                        listOfThings: desiredMovies,
                        builder: (movies) => _gridViewMovieList(movies)
                      )
                    : FetchStateBuilder(
                        fetchStatus: _fetchStatus,
                        listOfThings: desiredMovies,
                        builder: (movies) => _listViewMovieList(movies)
                      )
              )
            ]
          )
        )
      )
    );
  }

  Widget _topSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
      child: Column(
        children: [
          /// Selection Part
          _selectDesiredMovies(),
          const SizedBox(height: 8),

          /// Details and Buttons
          _detailsAndButtons()
        ],
      )
    );
  }

  Widget _selectDesiredMovies() {
    return Row(
      children: [
        SelectionState(
          text: 'Now Playing',
          isClicked: nowShowingIsClicked,
          onPressed: () {
            if (!nowShowingIsClicked) _toggleButton();
          }
        ),
        const SizedBox(width: 8),
        SelectionState(
          text: '  Upcoming  ',
          isClicked: !nowShowingIsClicked,
          onPressed: () {
            if (nowShowingIsClicked) _toggleButton();
          }
        )
      ]
    );
  }

  Widget _detailsAndButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 1, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _totalDesiredMovies(),
          Row(
            children: [
              /// Filter Button
              CustomIconButton(
                icon: Icons.tune,
                onPressed: () async => openDialog(
                  context,
                  0.46,
                  "Sort the movies",
                  MovieFilter(
                    selectedOption: _selectedOption,
                    onSelect: (option) {
                      setState(() => _selectedOption = option);
                    }
                  )
                ),
                usingText: false,
                color: Color(0xff48E4d4), // Turqoise
              ),
              SizedBox(width: 6),
              /// Grid View Button
              CustomIconButton(
                icon: nowUsingGrid ? Icons.format_list_bulleted : Icons.grid_view,
                onPressed: () => _gridViewButton(),
                usingText: false,
                color: Color(0xff46E1D1), // Turqoise
              )
            ]
          )
        ],
      )
    );
  }

  Widget _totalDesiredMovies() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 8, 0, 0),
      child: nowShowingIsClicked
          ? Text(
              "Movies ($totalNowPlaying)",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E2522), // Black
              )
            )
          : Text(
              "Movies ($totalUpcoming)",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E2522), // Black
              )
            ),
    );
  }

  Widget _listViewMovieList(dynamic desiredMovies) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 42),
        child: ListView.builder(
          itemCount: desiredMovies.length,
          itemBuilder: (context, index) {
            final movie = desiredMovies[index];
            /// card part
            return Padding(
              padding: const EdgeInsets.all(2),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Moviedetail(
                        movieTitle:         movie['m_title'],
                        movieImage:         movie['m_imageurl'],
                        movieGenre:         movie['m_genre'],
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
                  index: index,
                  movieTitle:     movie['m_title'],
                  movieImage:     movie['m_imageurl'],
                  movieGenre:     movie['m_genre'],
                  movieScore:     "debug",
                  movieDuration:  "debug",
                  movieRated:     "debug",
                )
              )
            );
          }
        )
    );
  }

  Widget _gridViewMovieList(dynamic desiredMovies) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,             // 2 rows vertically
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 5.9,       // 3:4 aspect (width : height)
          ),
          itemCount: desiredMovies.length,
          itemBuilder: (context, index) {
            final movie = desiredMovies[index];
            /// card part
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Moviedetail(
                      movieTitle:         movie['m_title'],
                      movieImage:         movie['m_imageurl'],
                      movieGenre:         movie['m_genre'],
                      movieDescription:   "debug",
                      movieRating:        "debug",
                      movieYears:         "debug",
                      movieDuration:      "debug",
                      movieWatchlist:     "debug",
                    )
                  )
                );
              },
              child: _cardVertical(movie)
            );
          }
        )
    );
  }

  Widget _cardVertical(dynamic movie) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF), // White
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff000000).withOpacity(0.1)),
              borderRadius: BorderRadius.circular(6)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: 
              AspectRatio(
                aspectRatio: 3 / 4.6,
                child: _isFilePath(movie['m_imageurl'])
                    ? Image.file(
                        File(movie['m_imageurl']),
                        fit: BoxFit.cover, // Or BoxFit.fitWidth depending on your preference
                      )
                    : Image.network(
                        movie['m_imageurl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie, size: 50, color: Colors.grey),
                          );
                        }
                      )
              )
            )
          ),
          const SizedBox(height: 8),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['m_title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    // Genre
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xff000000).withOpacity(0.08),
                      ),
                      child: Text(
                        movie['m_genre'],
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Duration
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xff000000).withOpacity(0.08),
                      ),
                      child: Text(
                        "debug",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Rated
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xff000000).withOpacity(0.08),
                      ),
                      child: Text(
                        "debug",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    )
                  ]
                )
              ]
            )
          )
        ]
      )
    );
  }

  Future<void> _loadSavedLocation() async {
    final location = await locationServices.getSavedLocation();
    setState(() => currentLocation = location);
  }

  Future<void> _fetchMovies() async {
    setState(() => _fetchStatus = FetchStatus.loading);

    try {
      var movies = await movieServices.fetchMovies(currentLocation);
      final now = movies['nowMovies'] ?? [];
      final upcoming = movies['upcomingMovies'] ?? [];

      setState(() {
        allNowPlaying = now;
        allUpcoming = upcoming;
        _fetchStatus =
            (now.isEmpty && upcoming.isEmpty) ? FetchStatus.empty : FetchStatus.success;
      });
    } on SocketException {
      setState(() => _fetchStatus = FetchStatus.connectionError);
    } catch (e, stackTrace) {
      setState(() => _fetchStatus = FetchStatus.unknownError);
      debugPrint("Error fetching movies: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _toggleButton() {
    setState(() {
      nowShowingIsClicked = !nowShowingIsClicked;
      desiredMovies = nowShowingIsClicked ? allNowPlaying : allUpcoming;
    });
  }

  void _gridViewButton() {
    setState(() => nowUsingGrid = !nowUsingGrid);
  }

  void _updateFromLocationPanel(selectedLocation) {
    setState(() => currentLocation = selectedLocation);
  }

  bool _isFilePath(String path) => !(path.startsWith('http://') || path.startsWith('https://'));


}
