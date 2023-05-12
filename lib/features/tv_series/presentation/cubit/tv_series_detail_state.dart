part of 'tv_series_detail_cubit.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object> get props => [];
}

class TvSeriesDetailInitial extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;

  TvSeriesDetailLoaded({required this.tvSeriesDetail});

  @override
  List<Object> get props => [tvSeriesDetail];
}

class TvSeriesDetailFailed extends TvSeriesDetailState {
  final String message;

  TvSeriesDetailFailed({required this.message});

  @override
  List<Object> get props => [message];
}
