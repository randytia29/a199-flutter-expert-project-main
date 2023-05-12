part of 'tv_series_recommendation_cubit.dart';

abstract class TvSeriesRecommendationState extends Equatable {
  const TvSeriesRecommendationState();

  @override
  List<Object> get props => [];
}

class TvSeriesRecommendationInitial extends TvSeriesRecommendationState {}

class TvSeriesRecommendationLoading extends TvSeriesRecommendationState {}

class TvSeriesRecommendationLoaded extends TvSeriesRecommendationState {
  final List<TvSeries> tvSeries;

  TvSeriesRecommendationLoaded({required this.tvSeries});

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesRecommendationFailed extends TvSeriesRecommendationState {
  final String message;

  TvSeriesRecommendationFailed({required this.message});

  @override
  List<Object> get props => [message];
}
