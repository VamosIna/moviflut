import 'package:equatable/equatable.dart';
import 'package:movie_app/core/domain/entities/media.dart';
import 'package:movie_app/core/utils/enums.dart';

class MoviesState extends Equatable {
  final List<List<Media>> movies;
  final RequestStatus status;
  final String message;
  final int? id;
  final List<Media> items;

  const MoviesState({
    this.movies = const [],
    this.id,
    this.items = const [],
    this.status = RequestStatus.loading,
    this.message = '',
  });

  MoviesState copyWith({
    List<List<Media>>? movies,
    RequestStatus? status,
    String? message,
    int? id,
    List<Media>? items,
  }) {
    return MoviesState(
      id: id ?? this.id,
      items: items ?? this.items,
      movies: movies ?? this.movies,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        movies,
        status,
        message,
      ];
}
