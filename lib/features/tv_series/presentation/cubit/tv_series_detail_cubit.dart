import 'package:bloc/bloc.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_state.dart';

class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;

  TvSeriesDetailCubit({required GetTvSeriesDetail tvSeriesDetail})
      : getTvSeriesDetail = tvSeriesDetail,
        super(TvSeriesDetailInitial());

  void fetchTvSeriesDetail(int id) async {
    emit(TvSeriesDetailLoading());

    final result = await getTvSeriesDetail.execute(id);

    result.fold((l) => emit(TvSeriesDetailFailed(message: l.message)),
        (r) => emit(TvSeriesDetailLoaded(tvSeriesDetail: r)));
  }
}
