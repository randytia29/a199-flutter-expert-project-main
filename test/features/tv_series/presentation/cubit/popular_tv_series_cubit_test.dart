import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_cubit_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesCubit popularTvSeriesCubit;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesCubit =
        PopularTvSeriesCubit(popularTvSeries: mockGetPopularTvSeries);
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

  tearDown(() => popularTvSeriesCubit.close());

  test(
      'bloc should have initial state as [PopularTvSeriesInitial]',
      () => expect(
          popularTvSeriesCubit.state.runtimeType, PopularTvSeriesInitial));

  blocTest(
    'should emit [PopularTvSeriesLoading, PopularTvSeriesLoaded] state when data loaded',
    build: () => popularTvSeriesCubit,
    act: (PopularTvSeriesCubit cubit) {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      cubit.fetchPopularTvSeries();
    },
    expect: () => [isA<PopularTvSeriesLoading>(), isA<PopularTvSeriesLoaded>()],
    verify: (cubit) {
      verify(mockGetPopularTvSeries.execute()).called(1);
    },
  );

  blocTest(
    'should emit [PopularTvSeriesLoading, PopularTvSeriesFailed] state when data failed',
    build: () => popularTvSeriesCubit,
    act: (PopularTvSeriesCubit cubit) {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchPopularTvSeries();
    },
    expect: () => [isA<PopularTvSeriesLoading>(), isA<PopularTvSeriesFailed>()],
    verify: (cubit) {
      verify(mockGetPopularTvSeries.execute()).called(1);
    },
  );
}
