import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movie_state.dart';

class PopularMovieCubit extends Cubit<PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieCubit({required GetPopularMovies popularMovies})
      : getPopularMovies = popularMovies,
        super(PopularMovieInitial());

  void fetchPopularMovie() async {
    emit(PopularMovieLoading());

    final result = await getPopularMovies.execute();

    result.fold((l) => emit(PopularMovieFailed(message: l.message)),
        (r) => emit(PopularMovieLoaded(movies: r)));
  }
}
