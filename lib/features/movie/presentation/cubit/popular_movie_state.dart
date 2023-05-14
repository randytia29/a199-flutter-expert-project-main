part of 'popular_movie_cubit.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieLoaded extends PopularMovieState {
  final List<Movie> movies;

  PopularMovieLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class PopularMovieFailed extends PopularMovieState {
  final String message;

  PopularMovieFailed({required this.message});

  @override
  List<Object> get props => [message];
}
