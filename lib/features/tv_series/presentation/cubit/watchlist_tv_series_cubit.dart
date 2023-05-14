import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';

part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesCubit extends Cubit<WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesCubit({required GetWatchlistTvSeries watchlistTvSeries})
      : getWatchlistTvSeries = watchlistTvSeries,
        super(WatchlistTvSeriesInitial());

  void fetchWatchlistTvSeries() async {
    emit(WatchlistTvSeriesLoading());

    final result = await getWatchlistTvSeries.execute();

    result.fold((l) => emit(WatchlistTvSeriesFailed(message: l.message)),
        (r) => emit(WatchlistTvSeriesLoaded(tvSeries: r)));
  }
}
