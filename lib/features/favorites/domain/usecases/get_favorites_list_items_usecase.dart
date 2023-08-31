import 'package:movie_app/core/data/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/domain/usecase/base_use_case.dart';
import 'package:movie_app/features/favorites/domain/repository/favorites_repository.dart';

class GetFavoritesListItemsUseCase extends BaseUseCase<List<Media>, NoParameters> {
  final FavoritesListRepository _baseFavoritesListRepository;

  GetFavoritesListItemsUseCase(this._baseFavoritesListRepository);

  @override
  Future<Either<Failure, List<Media>>> call(NoParameters p) async {
    return await _baseFavoritesListRepository.getFavoritesListItems();
  }
}
