import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_series_state.dart';

class PopularTvSeriesCubit extends Cubit<PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesCubit({required GetPopularTvSeries popularTvSeries})
      : getPopularTvSeries = popularTvSeries,
        super(PopularTvSeriesInitial());

  void fetchPopularTvSeries() async {
    emit(PopularTvSeriesLoading());

    final result = await getPopularTvSeries.execute();

    result.fold((l) => emit(PopularTvSeriesFailed(message: l.message)),
        (r) => emit(PopularTvSeriesLoaded(tvSeries: r)));
  }
}
