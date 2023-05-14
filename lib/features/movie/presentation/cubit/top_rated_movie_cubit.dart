import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieCubit extends Cubit<TopRatedMovieState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMovieCubit({required GetTopRatedMovies topRatedMovies})
      : getTopRatedMovies = topRatedMovies,
        super(TopRatedMovieInitial());

  void fetchTopRatedMovie() async {
    emit(TopRatedMovieLoading());

    final result = await getTopRatedMovies.execute();

    result.fold((l) => emit(TopRatedMovieFailed(message: l.message)),
        (r) => emit(TopRatedMovieLoaded(movies: r)));
  }
}
