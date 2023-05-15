part of 'movie_search_cubit.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  final List<Movie> movies;

  MovieSearchLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class MovieSearchFailed extends MovieSearchState {
  final String message;

  MovieSearchFailed({required this.message});

  @override
  List<Object> get props => [message];
}
