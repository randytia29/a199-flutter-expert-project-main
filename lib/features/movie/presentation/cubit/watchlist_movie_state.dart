part of 'watchlist_movie_cubit.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;

  WatchlistMovieLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class WatchlistMovieFailed extends WatchlistMovieState {
  final String message;

  WatchlistMovieFailed({required this.message});

  @override
  List<Object> get props => [message];
}
