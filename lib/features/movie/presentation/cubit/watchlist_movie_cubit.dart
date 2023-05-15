import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieCubit({required GetWatchlistMovies watchlistMovies})
      : getWatchlistMovies = watchlistMovies,
        super(WatchlistMovieInitial());

  void fetchWatchlistMovie() async {
    emit(WatchlistMovieLoading());

    final result = await getWatchlistMovies.execute();

    result.fold((l) => emit(WatchlistMovieFailed(message: l.message)),
        (r) => emit(WatchlistMovieLoaded(movies: r)));
  }
}
