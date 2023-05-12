import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_watchlist_status_state.dart';

class TvSeriesWatchlistStatusCubit extends Cubit<TvSeriesWatchlistStatusState> {
  final GetTvSeriesWatchListStatus getTvSeriesWatchListStatus;

  TvSeriesWatchlistStatusCubit(
      {required GetTvSeriesWatchListStatus tvSeriesWatchListStatus})
      : getTvSeriesWatchListStatus = tvSeriesWatchListStatus,
        super(TvSeriesWatchlistStatusInitial());

  void loadWatchlistStatus(int id) async {
    final status = await getTvSeriesWatchListStatus.execute(id);

    emit(TvSeriesWatchlistStatusLoaded(status: status));
  }
}
