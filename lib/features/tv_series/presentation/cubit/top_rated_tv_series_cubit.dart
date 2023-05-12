import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesCubit extends Cubit<TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesCubit({required GetTopRatedTvSeries topRatedTvSeries})
      : getTopRatedTvSeries = topRatedTvSeries,
        super(TopRatedTvSeriesInitial());

  void fetchTopRatedTvSeries() async {
    emit(TopRatedTvSeriesLoading());

    final result = await getTopRatedTvSeries.execute();

    result.fold((l) => emit(TopRatedTvSeriesFailed(message: l.message)),
        (r) => emit(TopRatedTvSeriesLoaded(tvSeries: r)));
  }
}
