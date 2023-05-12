import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/search_tv_series.dart';

part 'tv_series_search_state.dart';

class TvSeriesSearchCubit extends Cubit<TvSeriesSearchState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchCubit({required SearchTvSeries tvSeriesSearch})
      : searchTvSeries = tvSeriesSearch,
        super(TvSeriesSearchInitial());

  void fetchTvSeriesSearch(String query) async {
    emit(TvSeriesSearchLoading());

    final result = await searchTvSeries.execute(query);

    result.fold((l) => emit(TvSeriesSearchFailed(message: l.message)),
        (r) => emit(TvSeriesSearchLoaded(tvSeries: r)));
  }
}
