part of 'change_watchlist_tv_series_cubit.dart';

abstract class ChangeWatchlistTvSeriesState extends Equatable {
  const ChangeWatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class ChangeWatchlistTvSeriesInitial extends ChangeWatchlistTvSeriesState {}

class ChangeWatchlistTvSeriesLoading extends ChangeWatchlistTvSeriesState {}

class ChangeWatchlistTvSeriesLoaded extends ChangeWatchlistTvSeriesState {
  final String message;

  ChangeWatchlistTvSeriesLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

class ChangeWatchlistTvSeriesFailed extends ChangeWatchlistTvSeriesState {
  final String message;

  ChangeWatchlistTvSeriesFailed({required this.message});

  @override
  List<Object> get props => [message];
}
