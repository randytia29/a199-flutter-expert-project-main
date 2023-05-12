import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/search_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_cubit_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late MockSearchTvSeries mockSearchTvSeries;
  late TvSeriesSearchCubit tvSeriesSearchCubit;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    tvSeriesSearchCubit =
        TvSeriesSearchCubit(tvSeriesSearch: mockSearchTvSeries);
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

  tearDown(() => tvSeriesSearchCubit.close());

  test(
      'bloc should have initial state as [TvSeriesSearchInitial]',
      () =>
          expect(tvSeriesSearchCubit.state.runtimeType, TvSeriesSearchInitial));

  blocTest(
    'should emit [TvSeriesSearchLoading, TvSeriesSearchLoaded] state when data loaded',
    build: () => tvSeriesSearchCubit,
    act: (TvSeriesSearchCubit cubit) {
      when(mockSearchTvSeries.execute('game of throne'))
          .thenAnswer((_) async => Right(tTvSeriesList));

      cubit.fetchTvSeriesSearch('game of throne');
    },
    expect: () => [isA<TvSeriesSearchLoading>(), isA<TvSeriesSearchLoaded>()],
    verify: (cubit) {
      verify(mockSearchTvSeries.execute('game of throne')).called(1);
    },
  );

  blocTest(
    'should emit [TvSeriesSearchLoading, TvSeriesSearchFailed] state when data failed',
    build: () => tvSeriesSearchCubit,
    act: (TvSeriesSearchCubit cubit) {
      when(mockSearchTvSeries.execute('game of throne'))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchTvSeriesSearch('game of throne');
    },
    expect: () => [isA<TvSeriesSearchLoading>(), isA<TvSeriesSearchFailed>()],
    verify: (cubit) {
      verify(mockSearchTvSeries.execute('game of throne')).called(1);
    },
  );
}
