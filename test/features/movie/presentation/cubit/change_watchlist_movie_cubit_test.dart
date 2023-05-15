import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/features/movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton/features/movie/presentation/cubit/change_watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';

@GenerateMocks([SaveWatchlist, RemoveWatchlist])
void main() {
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late ChangeWatchlistMovieCubit changeWatchlistMovieCubit;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    changeWatchlistMovieCubit = ChangeWatchlistMovieCubit(
        watchlistSave: mockSaveWatchlist, watchlistRemove: mockRemoveWatchlist);
  });

  tearDown(() => changeWatchlistMovieCubit.close());

  test(
      'bloc should have initial state as [ChangeWatchlistMovieInitial]',
      () => expect(changeWatchlistMovieCubit.state.runtimeType,
          ChangeWatchlistMovieInitial));

  blocTest(
    'should emit [ChangeWatchlistMovieLoading, ChangeWatchlistMovieLoaded] state when add data loaded',
    build: () => changeWatchlistMovieCubit,
    act: (ChangeWatchlistMovieCubit cubit) {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));

      cubit.addWatchlist(testMovieDetail);
    },
    expect: () =>
        [isA<ChangeWatchlistMovieLoading>(), isA<ChangeWatchlistMovieLoaded>()],
    verify: (cubit) {
      verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistMovieLoading, ChangeWatchlistMovieFailed] state when add data failed',
    build: () => changeWatchlistMovieCubit,
    act: (ChangeWatchlistMovieCubit cubit) {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

      cubit.addWatchlist(testMovieDetail);
    },
    expect: () =>
        [isA<ChangeWatchlistMovieLoading>(), isA<ChangeWatchlistMovieFailed>()],
    verify: (cubit) {
      verify(mockSaveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistMovieLoading, ChangeWatchlistMovieLoaded] state when remove data loaded',
    build: () => changeWatchlistMovieCubit,
    act: (ChangeWatchlistMovieCubit cubit) {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));

      cubit.removeWatchlistMovie(testMovieDetail);
    },
    expect: () =>
        [isA<ChangeWatchlistMovieLoading>(), isA<ChangeWatchlistMovieLoaded>()],
    verify: (cubit) {
      verify(mockRemoveWatchlist.execute(testMovieDetail)).called(1);
    },
  );

  blocTest(
    'should emit [ChangeWatchlistMovieLoading, ChangeWatchlistMovieFailed] state when remove data failed',
    build: () => changeWatchlistMovieCubit,
    act: (ChangeWatchlistMovieCubit cubit) {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));

      cubit.removeWatchlistMovie(testMovieDetail);
    },
    expect: () =>
        [isA<ChangeWatchlistMovieLoading>(), isA<ChangeWatchlistMovieFailed>()],
    verify: (cubit) {
      verify(mockRemoveWatchlist.execute(testMovieDetail)).called(1);
    },
  );
}
