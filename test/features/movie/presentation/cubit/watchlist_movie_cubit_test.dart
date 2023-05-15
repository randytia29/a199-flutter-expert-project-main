import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/features/movie/presentation/cubit/watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/watchlist_movie_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieCubit watchlistMovieCubit;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieCubit =
        WatchlistMovieCubit(watchlistMovies: mockGetWatchlistMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  tearDown(() => watchlistMovieCubit.close());

  test(
      'bloc should have initial state as [WatchlistMovieInitial]',
      () =>
          expect(watchlistMovieCubit.state.runtimeType, WatchlistMovieInitial));

  blocTest(
    'should emit [WatchlistMovieLoading, WatchlistMovieLoaded] state when data loaded',
    build: () => watchlistMovieCubit,
    act: (WatchlistMovieCubit cubit) {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchWatchlistMovie();
    },
    expect: () => [isA<WatchlistMovieLoading>(), isA<WatchlistMovieLoaded>()],
    verify: (cubit) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );

  blocTest(
    'should emit [WatchlistMovieLoading, WatchlistMovieFailed] state when data failed',
    build: () => watchlistMovieCubit,
    act: (WatchlistMovieCubit cubit) {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchWatchlistMovie();
    },
    expect: () => [isA<WatchlistMovieLoading>(), isA<WatchlistMovieFailed>()],
    verify: (cubit) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );
}
