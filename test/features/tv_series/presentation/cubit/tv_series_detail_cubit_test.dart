import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_cubit_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late TvSeriesDetailCubit tvSeriesDetailCubit;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    tvSeriesDetailCubit =
        TvSeriesDetailCubit(tvSeriesDetail: mockGetTvSeriesDetail);
  });

  tearDown(() => tvSeriesDetailCubit.close());

  test(
      'bloc should have initial state as [TvSeriesDetailInitial]',
      () =>
          expect(tvSeriesDetailCubit.state.runtimeType, TvSeriesDetailInitial));

  blocTest(
    'should emit [TvSeriesDetailLoading, TvSeriesDetailLoaded] state when data loaded',
    build: () => tvSeriesDetailCubit,
    act: (TvSeriesDetailCubit cubit) {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Right(testTvSeriesDetail));

      cubit.fetchTvSeriesDetail(1);
    },
    expect: () => [isA<TvSeriesDetailLoading>(), isA<TvSeriesDetailLoaded>()],
    verify: (cubit) {
      verify(mockGetTvSeriesDetail.execute(1)).called(1);
    },
  );

  blocTest(
    'should emit [TvSeriesDetailLoading, TvSeriesDetailFailed] state when data failed',
    build: () => tvSeriesDetailCubit,
    act: (TvSeriesDetailCubit cubit) {
      when(mockGetTvSeriesDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchTvSeriesDetail(1);
    },
    expect: () => [isA<TvSeriesDetailLoading>(), isA<TvSeriesDetailFailed>()],
    verify: (cubit) {
      verify(mockGetTvSeriesDetail.execute(1)).called(1);
    },
  );
}
