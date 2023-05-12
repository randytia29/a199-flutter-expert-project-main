part of 'tv_series_watchlist_status_cubit.dart';

abstract class TvSeriesWatchlistStatusState extends Equatable {
  const TvSeriesWatchlistStatusState();

  @override
  List<Object> get props => [];
}

class TvSeriesWatchlistStatusInitial extends TvSeriesWatchlistStatusState {}

class TvSeriesWatchlistStatusLoaded extends TvSeriesWatchlistStatusState {
  final bool status;

  TvSeriesWatchlistStatusLoaded({required this.status});

  @override
  List<Object> get props => [status];
}
