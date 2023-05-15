part of 'movie_detail_cubit.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movieDetail;

  MovieDetailLoaded({required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailFailed extends MovieDetailState {
  final String message;

  MovieDetailFailed({required this.message});

  @override
  List<Object> get props => [message];
}
