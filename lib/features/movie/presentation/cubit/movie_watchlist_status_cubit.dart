import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/usecases/get_watchlist_status.dart';
import 'package:equatable/equatable.dart';

part 'movie_watchlist_status_state.dart';

class MovieWatchlistStatusCubit extends Cubit<MovieWatchlistStatusState> {
  final GetWatchListStatus getWatchListStatus;

  MovieWatchlistStatusCubit({required GetWatchListStatus watchListStatus})
      : getWatchListStatus = watchListStatus,
        super(MovieWatchlistStatusInitial());

  void loadWatchlistStatus(int id) async {
    final status = await getWatchListStatus.execute(id);

    emit(MovieWatchlistStatusLoaded(status: status));
  }
}
