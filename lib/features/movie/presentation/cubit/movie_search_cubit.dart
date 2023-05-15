import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchCubit({required SearchMovies moviesSearch})
      : searchMovies = moviesSearch,
        super(MovieSearchInitial());

  void fetchMovieSearch(String query) async {
    emit(MovieSearchLoading());

    final result = await searchMovies.execute(query);

    result.fold((l) => emit(MovieSearchFailed(message: l.message)),
        (r) => emit(MovieSearchLoaded(movies: r)));
  }
}
