import 'package:cinema_application/data/helpers/apihelper.dart';

class MovieServices {
  final apiHelper = ApiHelper();

  Future<String> _cacheMovieImage(String imageUrl, String title) async {
    if (imageUrl.isNotEmpty) {
      return await apiHelper.downloadAndCacheImage(imageUrl, title);
    }
    return imageUrl;
  }

  Future<List<dynamic>> _fetchDesiredMovies(String movieStatus, String currentLocation) async {
    try {
      final desiredMovies = await apiHelper
        .getDesireMoviesByCityandSchedule(movieStatus, currentLocation);

      await Future.wait(desiredMovies.map((movie) async {
        movie['m_imageurl'] = await _cacheMovieImage('m_imageurl', movie['m_title']);
      }));

      return desiredMovies;
    } catch (e) {
      throw Exception('Failed to fetch movies.');
    }
  }

  Future<Map<String, List?>> fetchMovies(String currentLocation) async {
    var nowMovies = await loadNowPlayingMovies(currentLocation);
    var upcomingMovies = await loadUpcomingMovies(currentLocation);

    return {
      'nowMovies': nowMovies,
      'upcomingMovies': upcomingMovies,
    };
  }

  Future<List<dynamic>?> loadNowPlayingMovies(String currentLocation) async {
    List nowMovies = await _fetchDesiredMovies('now_playing', currentLocation);
    return nowMovies;
  }

  Future<List<dynamic>?> loadUpcomingMovies(String currentLocation) async {
    List upcomingMovies = await _fetchDesiredMovies('upcoming', currentLocation);
    return upcomingMovies;
  }
}