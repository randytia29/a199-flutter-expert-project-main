import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MovieNowPlayingCubit movieNowPlayingCubit;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    movieNowPlayingCubit =
        MovieNowPlayingCubit(nowPlayingMovies: mockGetNowPlayingMovies);
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

  tearDown(() => movieNowPlayingCubit.close());

  test(
      'bloc should have initial state as [MovieNowPlayingInitial]',
      () => expect(
          movieNowPlayingCubit.state.runtimeType, MovieNowPlayingInitial));

  blocTest(
    'should emit [MovieNowPlayingLoading, MovieNowPlayingLoaded] state when data loaded',
    build: () => movieNowPlayingCubit,
    act: (MovieNowPlayingCubit cubit) {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchNowPlayingMovie();
    },
    expect: () => [isA<MovieNowPlayingLoading>(), isA<MovieNowPlayingLoaded>()],
    verify: (cubit) {
      verify(mockGetNowPlayingMovies.execute()).called(1);
    },
  );

  blocTest(
    'should emit [MovieNowPlayingLoading, MovieNowPlayingFailed] state when data failed',
    build: () => movieNowPlayingCubit,
    act: (MovieNowPlayingCubit cubit) {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchNowPlayingMovie();
    },
    expect: () => [isA<MovieNowPlayingLoading>(), isA<MovieNowPlayingFailed>()],
    verify: (cubit) {
      verify(mockGetNowPlayingMovies.execute()).called(1);
    },
  );
}
