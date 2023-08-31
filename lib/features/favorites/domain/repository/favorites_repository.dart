import 'package:dartz/dartz.dart';
import 'package:movie_app/core/data/error/failure.dart';
import 'package:movie_app/core/domain/entities/media.dart';

abstract class FavoritesListRepository {
  Future<Either<Failure, List<Media>>> getFavoritesListItems();
  Future<Either<Failure, int>> addFavoriteListItem(Media media);
  Future<Either<Failure, Unit>> removeFavoriteListItem(int index);
  Future<Either<Failure, int>> checkIfItemAdded(int tmdbId);
}
