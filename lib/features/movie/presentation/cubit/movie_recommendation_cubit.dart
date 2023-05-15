import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_recommendation_state.dart';

class MovieRecommendationCubit extends Cubit<MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationCubit(
      {required GetMovieRecommendations movieRecommendations})
      : getMovieRecommendations = movieRecommendations,
        super(MovieRecommendationInitial());

  void fetchMovieRecommendation(int id) async {
    emit(MovieRecommendationLoading());

    final result = await getMovieRecommendations.execute(id);

    result.fold((l) => emit(MovieRecommendationFailed(message: l.message)),
        (r) => emit(MovieRecommendationLoaded(movies: r)));
  }
}
