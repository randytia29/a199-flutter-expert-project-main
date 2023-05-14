import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

part 'movie_now_playing_state.dart';

class MovieNowPlayingCubit extends Cubit<MovieNowPlayingState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  MovieNowPlayingCubit({required GetNowPlayingMovies nowPlayingMovies})
      : getNowPlayingMovies = nowPlayingMovies,
        super(MovieNowPlayingInitial());

  void fetchNowPlayingMovie() async {
    emit(MovieNowPlayingLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold((l) => emit(MovieNowPlayingFailed(message: l.message)),
        (r) => emit(MovieNowPlayingLoaded(movies: r)));
  }
}
