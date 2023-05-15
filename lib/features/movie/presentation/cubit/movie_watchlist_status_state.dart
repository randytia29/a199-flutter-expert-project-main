part of 'movie_watchlist_status_cubit.dart';

abstract class MovieWatchlistStatusState extends Equatable {
  const MovieWatchlistStatusState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistStatusInitial extends MovieWatchlistStatusState {}

class MovieWatchlistStatusLoaded extends MovieWatchlistStatusState {
  final bool status;

  MovieWatchlistStatusLoaded({required this.status});

  @override
  List<Object> get props => [status];
}
