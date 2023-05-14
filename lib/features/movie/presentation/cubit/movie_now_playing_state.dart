part of 'movie_now_playing_cubit.dart';

abstract class MovieNowPlayingState extends Equatable {
  const MovieNowPlayingState();

  @override
  List<Object> get props => [];
}

class MovieNowPlayingInitial extends MovieNowPlayingState {}

class MovieNowPlayingLoading extends MovieNowPlayingState {}

class MovieNowPlayingLoaded extends MovieNowPlayingState {
  final List<Movie> movies;

  MovieNowPlayingLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class MovieNowPlayingFailed extends MovieNowPlayingState {
  final String message;

  MovieNowPlayingFailed({required this.message});

  @override
  List<Object> get props => [message];
}
