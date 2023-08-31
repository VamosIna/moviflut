import 'package:dio/dio.dart';
import 'package:movie_app/core/data/error/exceptions.dart';
import 'package:movie_app/features/movies/data/models/movie_details_model.dart';

import 'package:movie_app/core/data/network/api_constants.dart';
import 'package:movie_app/core/data/network/error_message_model.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<List<MovieModel>>> getMovies();
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getAllPopularMovies(int page);
  Future<List<MovieModel>> getAllTopRatedMovies(int page);
}

class MoviesRemoteDataSourceImpl extends MoviesRemoteDataSource {
  final Dio dio = Dio();
  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    dio.interceptors.add(PrettyDioLogger(responseBody: true));
    final response = await dio.get(ApiConstants.nowPlayingMoviesPath);
    if (response.statusCode == 200) {
      print("TEST");
      return List<MovieModel>.from((response.data['results'] as List)
          .map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    dio.interceptors.add(PrettyDioLogger(responseBody: true));
    final response = await dio.get(ApiConstants.popularMoviesPath);
    if (response.statusCode == 200) {
      print("TEST");

      return List<MovieModel>.from((response.data['results'] as List)
          .map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    dio.interceptors.add(PrettyDioLogger(responseBody: true));
    final response = await dio.get(ApiConstants.topRatedMoviesPath);
    if (response.statusCode == 200) {
      print("TEST");

      return List<MovieModel>.from((response.data['results'] as List)
          .map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<List<MovieModel>>> getMovies() async {
    final response = Future.wait(
      [
        getNowPlayingMovies(),
        getPopularMovies(),
        getTopRatedMovies(),
      ],
      eagerError: true,
    );
    return response;
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    dio.interceptors.add(PrettyDioLogger(responseBody: true));
    final response = await dio.get(ApiConstants.getMovieDetailsPath(movieId));
    if (response.statusCode == 200) {
      print("TEST");

      return MovieDetailsModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllPopularMovies(int page) async {
    final response =
        await Dio().get(ApiConstants.getAllPopularMoviesPath(page));
    if (response.statusCode == 200) {
      print("TEST");

      return List<MovieModel>.from((response.data['results'] as List)
          .map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<MovieModel>> getAllTopRatedMovies(int page) async {
    final response =
        await Dio().get(ApiConstants.getAllTopRatedMoviesPath(page));
    if (response.statusCode == 200) {
      print("TEST");

      return List<MovieModel>.from((response.data['results'] as List)
          .map((e) => MovieModel.fromJson(e)));
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
