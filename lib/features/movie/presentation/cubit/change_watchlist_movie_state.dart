part of 'change_watchlist_movie_cubit.dart';

abstract class ChangeWatchlistMovieState extends Equatable {
  const ChangeWatchlistMovieState();

  @override
  List<Object> get props => [];
}

class ChangeWatchlistMovieInitial extends ChangeWatchlistMovieState {}

class ChangeWatchlistMovieLoading extends ChangeWatchlistMovieState {}

class ChangeWatchlistMovieLoaded extends ChangeWatchlistMovieState {
  final String message;

  ChangeWatchlistMovieLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

class ChangeWatchlistMovieFailed extends ChangeWatchlistMovieState {
  final String message;

  ChangeWatchlistMovieFailed({required this.message});

  @override
  List<Object> get props => [message];
}
