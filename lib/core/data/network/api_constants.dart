
class ApiConstants {
  static const String apiKey = 'ff951af73ca3d4b152d92dcc97117f8f';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String baseBackdropUrl = 'https://image.tmdb.org/t/p/w1280';
  static const String basePosterUrl = 'https://image.tmdb.org/t/p/w500';
  static const String baseProfileUrl = 'https://image.tmdb.org/t/p/w300';
  static const String baseVideoUrl = 'https://www.youtube.com/watch?v=';

  static const String moviePlaceHolder =
      '';

  static const String castPlaceHolder =
      '';

  // movies paths
  static const String nowPlayingMoviesPath =
      '$baseUrl/movie/now_playing?api_key=$apiKey';

  static const String popularMoviesPath =
      '$baseUrl/movie/popular?api_key=$apiKey';

  static const String topRatedMoviesPath =
      '$baseUrl/movie/top_rated?api_key=$apiKey';

  static String getMovieDetailsPath(int movieId) {
    return '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=videos,credits,reviews,similar';
  }

  static String getAllPopularMoviesPath(int page) {
    return '$baseUrl/movie/popular?api_key=$apiKey&page=$page';
  }

  static String getAllTopRatedMoviesPath(int page) {
    return '$baseUrl/movie/top_rated?api_key=$apiKey&page=$page';
  }

  // search paths
  static String getSearchPath(String title) {
    return '$baseUrl/search/movie?api_key=$apiKey&query=$title';
  }
}
