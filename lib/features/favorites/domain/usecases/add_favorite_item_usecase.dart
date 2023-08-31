import 'package:movie_app/core/data/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/domain/usecase/base_use_case.dart';
import 'package:movie_app/features/favorites/domain/repository/favorites_repository.dart';

class AddFavoriteListItemUseCase extends BaseUseCase<int, Media> {
  final FavoritesListRepository _baseFavoritesListRepository;

  AddFavoriteListItemUseCase(this._baseFavoritesListRepository);

  @override
  Future<Either<Failure, int>> call(Media p) async {
    return await _baseFavoritesListRepository.addFavoriteListItem(p);
  }
}
