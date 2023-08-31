import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/domain/usecase/base_use_case.dart';
import 'package:movie_app/core/utils/enums.dart';
import 'package:movie_app/features/movies/domain/usecases/get_movies_usecase.dart';

import 'package:movie_app/features/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:movie_app/features/movies/presentation/controllers/movies_bloc/movies_state.dart';

import '../../../../favorites/domain/usecases/get_favorites_list_items_usecase.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final GetFavoritesListItemsUseCase _getFavoritesListItemsUseCase;

  MoviesBloc(
    this._getMoviesUseCase,this._getFavoritesListItemsUseCase,
  ) : super(const MoviesState()) {
    on<GetMoviesEvent>(_getMovies);
  }

  Future<void> _getMovies(
      GetMoviesEvent event, Emitter<MoviesState> emit) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
      ),
    );
    final result2 = await _getFavoritesListItemsUseCase.call(const NoParameters());
    print("TAPPEDDDDD : ${result2.fold((l) => l.message.toString(), (r) => r.toString())}");
    final result = await _getMoviesUseCase(const NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          status: RequestStatus.error,
          message: l.message,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: RequestStatus.loaded,
          movies: r,
        ),
      ),
    );
    result2.fold(
          (l) => emit(
        state.copyWith(
          status: RequestStatus.error,
          message: l.message,
        ),
      ),
          (r) {
        if (r.isEmpty) {
          emit(
            state.copyWith(
              items: []
            )
          );
        } else {
          print("TAPPEDDDDD : ${r}");
          emit(
              state.copyWith(
                  items: r
              )
          );
        }
      },
    );

  }
}
