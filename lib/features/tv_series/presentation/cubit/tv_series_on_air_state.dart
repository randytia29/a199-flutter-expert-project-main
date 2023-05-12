part of 'tv_series_on_air_cubit.dart';

abstract class TvSeriesOnAirState extends Equatable {
  const TvSeriesOnAirState();

  @override
  List<Object> get props => [];
}

class TvSeriesOnAirInitial extends TvSeriesOnAirState {}

class TvSeriesOnAirLoading extends TvSeriesOnAirState {}

class TvSeriesOnAirLoaded extends TvSeriesOnAirState {
  final List<TvSeries> tvSeries;

  TvSeriesOnAirLoaded({required this.tvSeries});

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesOnAirFailed extends TvSeriesOnAirState {
  final String message;

  TvSeriesOnAirFailed({required this.message});

  @override
  List<Object> get props => [message];
}
