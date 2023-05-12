part of 'tv_series_search_cubit.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchInitial extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchLoaded extends TvSeriesSearchState {
  final List<TvSeries> tvSeries;

  TvSeriesSearchLoaded({required this.tvSeries});

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesSearchFailed extends TvSeriesSearchState {
  final String message;

  TvSeriesSearchFailed({required this.message});

  @override
  List<Object> get props => [message];
}
