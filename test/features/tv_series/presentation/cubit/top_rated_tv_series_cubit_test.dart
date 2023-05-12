import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesCubit topRatedTvSeriesCubit;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesCubit =
        TopRatedTvSeriesCubit(topRatedTvSeries: mockGetTopRatedTvSeries);
  });

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  tearDown(() => topRatedTvSeriesCubit.close());

  test(
      'bloc should have initial state as [TopRatedTvSeriesInitial]',
      () => expect(
          topRatedTvSeriesCubit.state.runtimeType, TopRatedTvSeriesInitial));

  blocTest(
    'should emit [TopRatedTvSeriesLoading, TopRatedTvSeriesLoaded] state when data loaded',
    build: () => topRatedTvSeriesCubit,
    act: (TopRatedTvSeriesCubit cubit) {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      cubit.fetchTopRatedTvSeries();
    },
    expect: () =>
        [isA<TopRatedTvSeriesLoading>(), isA<TopRatedTvSeriesLoaded>()],
    verify: (cubit) {
      verify(mockGetTopRatedTvSeries.execute()).called(1);
    },
  );

  blocTest(
    'should emit [TopRatedTvSeriesLoading, TopRatedTvSeriesFailed] state when data failed',
    build: () => topRatedTvSeriesCubit,
    act: (TopRatedTvSeriesCubit cubit) {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchTopRatedTvSeries();
    },
    expect: () =>
        [isA<TopRatedTvSeriesLoading>(), isA<TopRatedTvSeriesFailed>()],
    verify: (cubit) {
      verify(mockGetTopRatedTvSeries.execute()).called(1);
    },
  );
}
