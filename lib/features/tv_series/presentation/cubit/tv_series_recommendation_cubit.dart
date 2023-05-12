import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_recommendation_state.dart';

class TvSeriesRecommendationCubit extends Cubit<TvSeriesRecommendationState> {
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesRecommendationCubit(
      {required GetTvSeriesRecommendations tvSeriesRecommendations})
      : getTvSeriesRecommendations = tvSeriesRecommendations,
        super(TvSeriesRecommendationInitial());

  void fetchTvSeriesRecommendation(int id) async {
    emit(TvSeriesRecommendationLoading());

    final result = await getTvSeriesRecommendations.execute(id);

    result.fold((l) => emit(TvSeriesRecommendationFailed(message: l.message)),
        (r) => emit(TvSeriesRecommendationLoaded(tvSeries: r)));
  }
}
