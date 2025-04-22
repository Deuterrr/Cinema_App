import 'dart:ui';

import 'package:cinema_application/components/movie/movie_list_container.dart';
import 'package:cinema_application/data/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  String currentLocation = '          ';
  List<dynamic>? nowMovies;
  List<dynamic>? upcomingMovies;
  bool isLoading = true;

  // debug purpose -> masih ada yg akses: iklan
  late List<MovieList> listmoviefirst;
  late List<AllMovie> allmovie;

  final movieServices = MovieServices();
  final locationServices = LocationServices();

  @override
  initState() {
    super.initState();
    _loadLocation();
    _fetchMovies();

    // debug purpose -> masih ada yg akses: iklan
    listmoviefirst = MovieList.getList();
    allmovie = AllMovie.getList();
  }

  Future<void> _loadLocation() async {
    String location = await locationServices.getLocation();
    setState(() {
      currentLocation = location;
    });
  }

  Future<void> _fetchMovies() async {
    setState(() => isLoading = true);
    try {
      var movies = await movieServices.fetchMovies(currentLocation);
      setState(() {
        nowMovies = movies['nowMovies'];
        upcomingMovies = movies['upcomingMovies'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f3f8), // Cool White
      
      // appbar
      appBar: CustomAppBar(
        useAppTitle: false,
        centerText: "Cinema App",
        showBackButton: false,
        showBottomBorder: true,
        trailingButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Location button
            CustomIconButton(
              icon: Icons.location_on_outlined,
              onPressed: () {
                _locationPanel(context);
              },
              usingText: true,
              theText: currentLocation,
              color: Color(0xFFFEC958), // Orange
            ),

            SizedBox(width: 6),

            // Search button
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

      // body
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadLocation();
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

                  // displaying ads
                  _adsSlider(),

                  // displaying vouchers and coupons
                  _displayVoucher(),

                  SizedBox(height: 6),

                  // displaying now showing movies in box
                  _nowPlayingMovie(),

                  SizedBox(height: 6),

                  // displaying upcoming movies in box
                  _upcomingMovie(),
                ]
              )
            )
          )
        )
      ) 
    );
  }

  _locationPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "BlurredDialog",
      transitionDuration: Duration(milliseconds: 210),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // Static blur background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Color(0xFFFFFFFF).withOpacity(0.35),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: anim1,
                  curve: Curves.easeOut,
                )),

                // The Panel
                child: LocationPanel(
                  onSelect: (selectedLocation) {
                    setState(() {
                      currentLocation = selectedLocation;
                    });
                  }
                )
              )
            )
          ]
        );
      }
    );
  }

  Widget _adsSlider() {
    return LayoutBuilder(
      builder: (context, constraints) {

        // calculate aspect ratio by max height
        double maxHeight = 174;
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
                    // borderRadius: BorderRadius.circular(8),
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

  // list popular movie
  Widget _nowPlayingMovie() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Text(
                  "Now Playing",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0E2522), // Black
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat"
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreMovies(
                          nowShowingIsClicked: true,
                          nowMovies: nowMovies,
                          upcomingMovies: upcomingMovies
                        )
                      )
                    ).then((_) {
                      setState(() {
                        _loadLocation();
                      });
                    });
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Montserrat",
                      color: Color(0xFF4A6761) // Dark Tosca
                    )
                  )
                )
              )
            ]
          ),
          
          SizedBox(height: 14),

          // List Movie
          MovieListContainer(
            height: 440,              // 332 (slider) + 12 (gap) + 78 (title-genre) + 18 (aesthetic) 
            isLoading: isLoading, 
            movieList: nowMovies, 
            builder: (movies) => CarouselMovieList(desiredMovies: movies)
          )
        ]
      )
    );
  }

  // list upcoming movie
  Widget _upcomingMovie() {
    return Container(
      padding: const EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Text(
                  "Upcoming",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF0E2522), // Black
                    fontWeight: FontWeight.w600,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreMovies(
                          nowShowingIsClicked: false,
                          nowMovies: nowMovies,
                          upcomingMovies: upcomingMovies
                        )
                      ),
                    ).then((_) {
                      setState(() {
                        _loadLocation();
                      });
                    });
                  },
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
          ),
          
          SizedBox(height: 14),

          // List movie
          MovieListContainer(
            height: 280,
            isLoading: isLoading,
            movieList: upcomingMovies,
            builder: (movies) => HorizontalMovieList(desiredMovies: movies)
          )
        ],
      ),
    );
  }
}