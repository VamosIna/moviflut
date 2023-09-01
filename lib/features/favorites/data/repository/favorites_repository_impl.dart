import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/data/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app/features/favorites/data/datasource/favorites_local_data_source.dart';
import 'package:movie_app/features/favorites/data/models/favorite_item_model.dart';
import 'package:movie_app/features/favorites/domain/repository/favorites_repository.dart';


class FavoriteListRepositoryImpl extends FavoritesListRepository {
  final FavoritesListLocalDataSource _baseFavoriteslistLocalDataSource;

  FavoriteListRepositoryImpl(this._baseFavoriteslistLocalDataSource);

  @override
  Future<Either<Failure, List<Media>>> getFavoritesListItems() async {
    final result =
        (await _baseFavoriteslistLocalDataSource.getFavoriteListItems());
    try {
      return Right(result);
    } on HiveError catch (failure) {
      return Left(DatabaseFailure(failure.message));
    }
  }
  @override
  Future<Either<Failure, List<Media>>> searchFavoritesListItems(String q) async {
    final result =
        (await _baseFavoriteslistLocalDataSource.searchFavoriteListItems(q));
    try {
      return Right(result);
    } on HiveError catch (failure) {
      return Left(DatabaseFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, int>> addFavoriteListItem(Media media) async {
    try {
      int id = await _baseFavoriteslistLocalDataSource.addFavoriteListItem(
        FavoritelistItemModel.fromEntity(media),
      );
      return Right(id);
    } on HiveError catch (failure) {
      return Left(DatabaseFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFavoriteListItem(int index) async {
    try {
      await _baseFavoriteslistLocalDataSource.removeFavoriteListItem(index);
      return const Right(unit);
    } on HiveError catch (failure) {
      return Left(DatabaseFailure(failure.message));
    }
  }

  @override
  Future<Either<Failure, int>> checkIfItemAdded(int tmdbId) async {
    try {
      final result =
          await _baseFavoriteslistLocalDataSource.isItemAdded(tmdbId);
      return Right(result);
    } on HiveError catch (failure) {
      return Left(DatabaseFailure(failure.message));
    }
  }
}
