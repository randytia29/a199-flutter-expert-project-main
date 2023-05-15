import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/features/movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/features/movie/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'change_watchlist_movie_state.dart';

class ChangeWatchlistMovieCubit extends Cubit<ChangeWatchlistMovieState> {
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  ChangeWatchlistMovieCubit(
      {required SaveWatchlist watchlistSave,
      required RemoveWatchlist watchlistRemove})
      : saveWatchlist = watchlistSave,
        removeWatchlist = watchlistRemove,
        super(ChangeWatchlistMovieInitial());

  void addWatchlist(MovieDetail movieDetail) async {
    emit(ChangeWatchlistMovieLoading());

    final result = await saveWatchlist.execute(movieDetail);

    result.fold((l) => emit(ChangeWatchlistMovieFailed(message: l.message)),
        (r) => emit(ChangeWatchlistMovieLoaded(message: r)));
  }

  void removeWatchlistMovie(MovieDetail movieDetail) async {
    emit(ChangeWatchlistMovieLoading());

    final result = await removeWatchlist.execute(movieDetail);

    result.fold((l) => emit(ChangeWatchlistMovieFailed(message: l.message)),
        (r) => emit(ChangeWatchlistMovieLoaded(message: r)));
  }
}
