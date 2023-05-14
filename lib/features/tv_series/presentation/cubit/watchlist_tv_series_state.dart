part of 'watchlist_tv_series_cubit.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoaded extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  WatchlistTvSeriesLoaded({required this.tvSeries});

  @override
  List<Object> get props => [tvSeries];
}

class WatchlistTvSeriesFailed extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesFailed({required this.message});

  @override
  List<Object> get props => [message];
}
