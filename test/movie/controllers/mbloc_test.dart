import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/core/data/error/failure.dart';
import 'package:movie_app/core/data/error/failure.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/domain/usecase/base_use_case.dart';
import 'package:movie_app/core/utils/enums.dart';
import 'package:movie_app/features/favorites/domain/usecases/get_favorites_list_items_usecase.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';
import 'package:movie_app/features/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movie_app/features/movies/presentation/controllers/movies_bloc/movies_bloc.dart';
import 'package:movie_app/features/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:movie_app/features/movies/presentation/controllers/movies_bloc/movies_state.dart';
class MockGetMoviesUseCase extends Mock implements GetMoviesUseCase {}
class MockGetFavMoviesUseCase extends Mock implements GetFavoritesListItemsUseCase {}

void main() {
  late MockGetMoviesUseCase? mockGetMoviesUseCase;
  late MockGetFavMoviesUseCase? mockGetMoviesUseCase2;
  late MoviesBloc? moviesBloc;
  MoviesState moviesState = MoviesState();

  setUp(() {
    mockGetMoviesUseCase = MockGetMoviesUseCase();
    mockGetMoviesUseCase2 = MockGetFavMoviesUseCase();
    moviesBloc = MoviesBloc(mockGetMoviesUseCase!,mockGetMoviesUseCase2!);
  });

  tearDown(() {
    moviesBloc?.close();
  });

  test('initial state is correct', () {
    expect(moviesBloc!.state, moviesState);
  });

  test('close does not emit new states', () {
    expectLater(
      moviesBloc!.stream,
      emitsInOrder([emitsDone]),
    );
    moviesBloc?.close();
  });
  final MovieResponse = [
      MovieModel(
          tmdbID: 1,
          title: 'movie 1',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
      MovieModel(
          tmdbID: 2,
          title: 'movie 2',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
  ];
  final tMoviesResponse = [
    const [
      MovieModel(
          tmdbID: 1,
          title: 'movie 1',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
      MovieModel(
          tmdbID: 2,
          title: 'movie 2',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
    ],
    const [
      MovieModel(
          tmdbID: 3,
          title: 'movie 3',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
      MovieModel(
          tmdbID: 4,
          title: 'movie 4',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
    ],
    const [
      MovieModel(
          tmdbID: 5,
          title: 'movie 5',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
      MovieModel(
          tmdbID: 6,
          title: 'movie 6',
          posterUrl: 'posterUrl',
          backdropUrl: 'backdropUrl',
          voteAverage: 3.4,
          releaseDate: '2022/10/5',
          overview: 'new movie with great actors',
          isMovie: true),
    ]
  ];

  const ServerFailure tErrorResponse = ServerFailure('Something went wrong');


  test(
    'get movies event should return list of list of movies in state',
        () async {
      // Arrange
      when(() => mockGetMoviesUseCase!(const NoParameters()))
          .thenAnswer((_) async => Right(tMoviesResponse));
      when(() => mockGetMoviesUseCase2!(const NoParameters()))
          .thenAnswer((_) async => Right(MovieResponse));
      // Assert Later
      expectLater(
        moviesBloc!.stream,
        emitsInOrder([moviesState]),
      ).then((_) {
        verify(() => mockGetMoviesUseCase!(const NoParameters()));
        expect(moviesBloc!.state.movies.isNotEmpty, true);
        expect(moviesBloc!.state.status, RequestStatus.loaded);
      });
      // Act
      moviesBloc!.add(GetMoviesEvent());
      // Assert
      verifyNoMoreInteractions(mockGetMoviesUseCase);
    },
  );

  test(
    'get movies event should return error state',
        () async {
      // Arrange
      when(
            () => mockGetMoviesUseCase!(const NoParameters()),
      ).thenAnswer(((invocation) async => const Left(tErrorResponse)));
      when(
            () => mockGetMoviesUseCase2!(const NoParameters()),
      ).thenAnswer(((invocation) async => const Left(tErrorResponse)));
      // Assert Later
      expectLater(
        moviesBloc!.stream,
        emitsInOrder([moviesState]),
      ).then((_) {
        verify(() => mockGetMoviesUseCase!(const NoParameters()));
        expect(moviesBloc!.state.movies.isEmpty, true);
        expect(moviesBloc!.state.status, RequestStatus.error);
      });
      // Act
      moviesBloc!.add(GetMoviesEvent());
      // Assert
      verifyNoMoreInteractions(mockGetMoviesUseCase);
    },
  );
}
