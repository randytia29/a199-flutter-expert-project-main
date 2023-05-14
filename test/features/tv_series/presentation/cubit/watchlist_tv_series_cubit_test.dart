import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/watchlist_tv_series_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_series_cubit_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late WatchlistTvSeriesCubit watchlistTvSeriesCubit;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesCubit =
        WatchlistTvSeriesCubit(watchlistTvSeries: mockGetWatchlistTvSeries);
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

  tearDown(() => watchlistTvSeriesCubit.close());

  test(
      'bloc should have initial state as [WatchlistTvSeriesInitial]',
      () => expect(
          watchlistTvSeriesCubit.state.runtimeType, WatchlistTvSeriesInitial));

  blocTest(
    'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesLoaded] state when data loaded',
    build: () => watchlistTvSeriesCubit,
    act: (WatchlistTvSeriesCubit cubit) {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      cubit.fetchWatchlistTvSeries();
    },
    expect: () =>
        [isA<WatchlistTvSeriesLoading>(), isA<WatchlistTvSeriesLoaded>()],
    verify: (cubit) {
      verify(mockGetWatchlistTvSeries.execute()).called(1);
    },
  );

  blocTest(
    'should emit [WatchlistTvSeriesLoading, WatchlistTvSeriesFailed] state when data failed',
    build: () => watchlistTvSeriesCubit,
    act: (WatchlistTvSeriesCubit cubit) {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchWatchlistTvSeries();
    },
    expect: () =>
        [isA<WatchlistTvSeriesLoading>(), isA<WatchlistTvSeriesFailed>()],
    verify: (cubit) {
      verify(mockGetWatchlistTvSeries.execute()).called(1);
    },
  );
}
