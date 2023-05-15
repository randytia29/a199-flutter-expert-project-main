import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movie_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieCubit popularMovieCubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieCubit = PopularMovieCubit(popularMovies: mockGetPopularMovies);
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

  tearDown(() => popularMovieCubit.close());

  test('bloc should have initial state as [PopularMovieInitial]',
      () => expect(popularMovieCubit.state.runtimeType, PopularMovieInitial));

  blocTest(
    'should emit [PopularMovieLoading, PopularMovieLoaded] state when data loaded',
    build: () => popularMovieCubit,
    act: (PopularMovieCubit cubit) {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchPopularMovie();
    },
    expect: () => [isA<PopularMovieLoading>(), isA<PopularMovieLoaded>()],
    verify: (cubit) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );

  blocTest(
    'should emit [PopularMovieLoading, PopularMovieFailed] state when data failed',
    build: () => popularMovieCubit,
    act: (PopularMovieCubit cubit) {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchPopularMovie();
    },
    expect: () => [isA<PopularMovieLoading>(), isA<PopularMovieFailed>()],
    verify: (cubit) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );
}
