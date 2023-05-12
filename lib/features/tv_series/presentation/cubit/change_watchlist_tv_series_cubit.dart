import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_tv_series_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'change_watchlist_tv_series_state.dart';

class ChangeWatchlistTvSeriesCubit extends Cubit<ChangeWatchlistTvSeriesState> {
  final SaveTvSeriesWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;

  ChangeWatchlistTvSeriesCubit(
      {required SaveTvSeriesWatchlist saveTvSeries,
      required RemoveTvSeriesWatchlist removeTvSeries})
      : saveTvSeriesWatchlist = saveTvSeries,
        removeTvSeriesWatchlist = removeTvSeries,
        super(ChangeWatchlistTvSeriesInitial());

  void addWatchlist(TvSeriesDetail tvSeriesDetail) async {
    emit(ChangeWatchlistTvSeriesLoading());

    final result = await saveTvSeriesWatchlist.execute(tvSeriesDetail);

    result.fold((l) => emit(ChangeWatchlistTvSeriesFailed(message: l.message)),
        (r) => emit(ChangeWatchlistTvSeriesLoaded(message: r)));
  }

  void removeWatchlist(TvSeriesDetail tvSeriesDetail) async {
    emit(ChangeWatchlistTvSeriesLoading());

    final result = await removeTvSeriesWatchlist.execute(tvSeriesDetail);

    result.fold((l) => emit(ChangeWatchlistTvSeriesFailed(message: l.message)),
        (r) => emit(ChangeWatchlistTvSeriesLoaded(message: r)));
  }
}
