import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_on_air_cubit_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late TvSeriesOnAirCubit tvSeriesOnAirCubit;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    tvSeriesOnAirCubit =
        TvSeriesOnAirCubit(onTheAirTvSeries: mockGetOnTheAirTvSeries);
  });

  tearDown(() => tvSeriesOnAirCubit.close());

  test('bloc should have initial state as [TvSeriesOnAirInitial]',
      () => expect(tvSeriesOnAirCubit.state.runtimeType, TvSeriesOnAirInitial));

  blocTest(
    'should emit [TvSeriesOnAirLoading, TvSeriesOnAirLoaded] state when data loaded',
    build: () => tvSeriesOnAirCubit,
    act: (TvSeriesOnAirCubit cubit) {
      when(mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => const Right([]));

      cubit.fetchOnTheAirTvSeries();
    },
    expect: () => [isA<TvSeriesOnAirLoading>(), isA<TvSeriesOnAirLoaded>()],
    verify: (cubit) {
      verify(mockGetOnTheAirTvSeries.execute()).called(1);
    },
  );

  blocTest(
    'should emit [TvSeriesOnAirLoading, TvSeriesOnAirFailed] state when data failed',
    build: () => tvSeriesOnAirCubit,
    act: (TvSeriesOnAirCubit cubit) {
      when(mockGetOnTheAirTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchOnTheAirTvSeries();
    },
    expect: () => [isA<TvSeriesOnAirLoading>(), isA<TvSeriesOnAirFailed>()],
    verify: (cubit) {
      verify(mockGetOnTheAirTvSeries.execute()).called(1);
    },
  );
}
