part of 'movie_recommendation_cubit.dart';

abstract class MovieRecommendationState extends Equatable {
  const MovieRecommendationState();

  @override
  List<Object> get props => [];
}

class MovieRecommendationInitial extends MovieRecommendationState {}

class MovieRecommendationLoading extends MovieRecommendationState {}

class MovieRecommendationLoaded extends MovieRecommendationState {
  final List<Movie> movies;

  MovieRecommendationLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class MovieRecommendationFailed extends MovieRecommendationState {
  final String message;

  MovieRecommendationFailed({required this.message});

  @override
  List<Object> get props => [message];
}
