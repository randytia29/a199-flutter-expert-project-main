import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_on_air_state.dart';

class TvSeriesOnAirCubit extends Cubit<TvSeriesOnAirState> {
  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  TvSeriesOnAirCubit({required GetOnTheAirTvSeries onTheAirTvSeries})
      : getOnTheAirTvSeries = onTheAirTvSeries,
        super(TvSeriesOnAirInitial());

  void fetchOnTheAirTvSeries() async {
    emit(TvSeriesOnAirLoading());

    final result = await getOnTheAirTvSeries.execute();

    result.fold((l) => emit(TvSeriesOnAirFailed(message: l.message)),
        (r) => emit(TvSeriesOnAirLoaded(tvSeries: r)));
  }
}
