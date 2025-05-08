import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinema_application/components/fetch/fetch_state_builder.dart';
import 'package:cinema_application/components/open_dialog.dart';
import 'package:cinema_application/data/helpers/fetch_status.dart';
import 'package:flutter/material.dart';

import 'package:cinema_application/data/services/location_services.dart';
import 'package:cinema_application/data/services/movie_services.dart';

import 'package:cinema_application/screens/booking/explore_movies.dart';
import 'package:cinema_application/screens/booking/search_movie.dart';

import 'package:cinema_application/data/models/listmovie.dart';
import 'package:cinema_application/data/models/film.dart';

import 'package:cinema_application/components/custom_appbar.dart';
import 'package:cinema_application/components/custom_icon_button.dart';
import 'package:cinema_application/components/location_panel.dart';
import 'package:cinema_application/components/section_icon.dart';
import 'package:cinema_application/components/movie/movie_list_builder/carousel_movie_list.dart';
import 'package:cinema_application/components/movie/movie_list_builder/horizontal_movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// location to be shown
  String currentLocation = "         ";

  /// movies data
  List<dynamic>? _nowMovies;
  List<dynamic>? _upcomingMovies;

  /// view control
  FetchStatus _fetchStatus = FetchStatus.loading;

  /// services
  final movieServices = MovieServices();
  final locationServices = LocationServices();

  // debug purpose -> masih ada yg akses: iklan
  late List<MovieList> listmoviefirst;
  late List<AllMovie> allmovie;

  @override
  initState() {
    super.initState();
    /// fetch location and movies
    _initData();

    /// debug purpose -> masih ada yg akses: iklan
    listmoviefirst = MovieList.getList();
    allmovie = AllMovie.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f3f8), // Cool White
      /// appbar
      appBar: CustomAppBar(
        useAppTitle: false,
        centerText: "Cinema App",
        showBackButton: false,
        showBottomBorder: true,
        trailingButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// location button
            CustomIconButton(
              icon: Icons.location_on_outlined,
              onPressed: () => openDialog(
                context,
                0.76,
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
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              usingText: false,
              color: const Color(0xFFF686F6), // Magenta
            )
          ]
        )
      ),

      /// body
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadSavedLocation();
            _fetchMovies();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// displaying ads
                  _adsSlider(),

                  /// displaying vouchers and coupons
                  _displayVoucher(),
                  const SizedBox(height: 6),

                  /// displaying now showing movies in box
                  _nowPlaying(),
                  const SizedBox(height: 6),

                  /// displaying upcoming movies in box
                  _upcoming(),
                ]
              )
            )
          )
        )
      ) 
    );
  }

  Widget _adsSlider() {
    final screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        // calculate aspect ratio by max height
        double maxHeight = screenHeight * 0.19;
        double aspectRatio = constraints.maxWidth / maxHeight;
        return CarouselSlider.builder(
          itemCount: listmoviefirst.length,
          itemBuilder: (context, index, realIndex) {
            final movie = listmoviefirst[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(
                  child: ClipRRect(
                    child: Image.asset(
                      movie.images,
                      fit: BoxFit.cover
                    )
                  )
                ),
                Positioned(
                  bottom: 22,
                  left: 0,
                  right: 26,
                  child: Text(
                    movie.nameMovie,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF), // White
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    )
                  )
                )
              ]
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            aspectRatio: aspectRatio, // Dynamic aspect ratio
            viewportFraction: 1.0,
          )
        );
      }
    );
  }

  Widget _displayVoucher() {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionWithIcon(
                  title: 'Level',
                  value: ' Classic',
                  haveIcon: false,),
              _verticalDivider(),
              SectionWithIcon(
                  title: 'Points',
                  value: ' 0',
                  haveIcon: false,),
              _verticalDivider(),
              SectionWithIcon(
                  title: 'Vouchers',
                  value: ' 0',
                  haveIcon: true,
                  icon: 'assets/icon/coupunicon.svg'),
              _verticalDivider(),
              SectionWithIcon(
                  title: 'Coupons',
                  value: ' 0',
                  haveIcon: true,
                  icon: 'assets/icon/discount.svg')
            ],
          )
        )
      )
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.only(left: 8),
    );
  }

  Widget _nowPlaying() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// header
          _headerSection(
            "Now Playing",
            () => _navigateToExplore(true)
          ),
          const SizedBox(height: 16),

          /// List Movie
          FetchStateBuilder(
            height: 440, 
            fetchStatus: _fetchStatus, 
            listOfThings: _nowMovies, 
            builder: (listOfThings) => CarouselMovieList(desiredMovies: listOfThings)
          )
        ]
      )
    );
  }

  Widget _upcoming() {
    return Container(
      padding: const EdgeInsets.only(bottom: 80),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// header
          _headerSection(
            "Upcoming", 
            () => _navigateToExplore(false)
          ),
          const SizedBox(height: 14),

          /// List movie
          FetchStateBuilder(
            height: 280,
            fetchStatus: _fetchStatus,
            listOfThings: _upcomingMovies,
            builder: (movies) => HorizontalMovieList(desiredMovies: movies)
          )
        ],
      ),
    );
  }

  Widget _headerSection(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF0E2522), // Black
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
          child: GestureDetector(
            onTap: onSeeAll,
            child: Text(
              "See All",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
                color: Color(0xFF4A6761) // Dark Tosca
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _initData() async {
    await _loadSavedLocation();
    await _fetchMovies();
  }

  Future<void> _loadSavedLocation() async {
    String location = await locationServices.getSavedLocation();
    setState(() => currentLocation = location);
  }

  Future<void> _fetchMovies() async {
    setState(() => _fetchStatus = FetchStatus.loading);

    try {
      final movies = await movieServices.fetchMovies(currentLocation);
      final now = List.from(movies['nowMovies'] ?? []);
      final upcoming = List.from(movies['upcomingMovies'] ?? []);

      setState(() {
        _nowMovies = now;
        _upcomingMovies = upcoming;
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

  void _updateFromLocationPanel(selectedLocation) {
    setState(() => currentLocation = selectedLocation);
  }

  void _navigateToExplore(bool nowShowingIsClicked) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreMovies(
          nowShowingIsClicked: nowShowingIsClicked,
          nowMovies: _nowMovies,
          upcomingMovies: _upcomingMovies,
        ),
      ),
    ).then((_) {
      _loadSavedLocation();
    });
  }
}