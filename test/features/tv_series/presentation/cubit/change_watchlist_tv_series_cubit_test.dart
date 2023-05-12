import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'change_watchlist_tv_series_cubit_test.mocks.dart';

@GenerateMocks([SaveTvSeriesWatchlist, RemoveTvSeriesWatchlist])
void main() {
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late ChangeWatchlistTvSeriesCubit changeWatchlistTvSeriesCubit;

  setUp(() {
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    changeWatchlistTvSeriesCubit = ChangeWatchlistTvSeriesCubit(
        saveTvSeries: mockSaveTvSeriesWatchlist,
        removeTvSeries: mockRemoveTvSeriesWatchlist);
  });

  tearDown(() => changeWatchlistTvSeriesCubit.close());

  test(
      'bloc should have initial state as [ChangeWatchlistTvSeriesInitial]',
      () => expect(changeWatchlistTvSeriesCubit.state.runtimeType,
          ChangeWatchlistTvSeriesInitial));

  blocTest(
    'should emit [ChangeWatchlistTvSeriesLoading, ChangeWatchlistTvSeriesLoaded] state when add data loaded',
    build: () => changeWatchlistTvSeriesCubit,
    act: (ChangeWatchlistTvSeriesCubit cubit) {
      when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      cubit.addWatchlist(testTvSeriesDetail);
    },
    expect: () => [
      isA<ChangeWatchlistTvSeriesLoading>(),
      isA<ChangeWatchlistTvSeriesLoaded>()
    ],
    verify: (cubit) {
      verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistTvSeriesLoading, ChangeWatchlistTvSeriesFailed] state when add data failed',
    build: () => changeWatchlistTvSeriesCubit,
    act: (ChangeWatchlistTvSeriesCubit cubit) {
      when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

      cubit.addWatchlist(testTvSeriesDetail);
    },
    expect: () => [
      isA<ChangeWatchlistTvSeriesLoading>(),
      isA<ChangeWatchlistTvSeriesFailed>()
    ],
    verify: (cubit) {
      verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistTvSeriesLoading, ChangeWatchlistTvSeriesLoaded] state when remove data loaded',
    build: () => changeWatchlistTvSeriesCubit,
    act: (ChangeWatchlistTvSeriesCubit cubit) {
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));

      cubit.removeWatchlist(testTvSeriesDetail);
    },
    expect: () => [
      isA<ChangeWatchlistTvSeriesLoading>(),
      isA<ChangeWatchlistTvSeriesLoaded>()
    ],
    verify: (cubit) {
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistTvSeriesLoading, ChangeWatchlistTvSeriesFailed] state when remove data failed',
    build: () => changeWatchlistTvSeriesCubit,
    act: (ChangeWatchlistTvSeriesCubit cubit) {
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

      cubit.removeWatchlist(testTvSeriesDetail);
    },
    expect: () => [
      isA<ChangeWatchlistTvSeriesLoading>(),
      isA<ChangeWatchlistTvSeriesFailed>()
    ],
    verify: (cubit) {
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)).called(1);
    },
  );
}
