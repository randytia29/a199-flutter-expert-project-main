import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMovieCubit topRatedMovieCubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieCubit =
        TopRatedMovieCubit(topRatedMovies: mockGetTopRatedMovies);
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

  tearDown(() => topRatedMovieCubit.close());

  test('bloc should have initial state as [TopRatedMovieInitial]',
      () => expect(topRatedMovieCubit.state.runtimeType, TopRatedMovieInitial));

  blocTest(
    'should emit [TopRatedMovieLoading, TopRatedMovieLoaded] state when data loaded',
    build: () => topRatedMovieCubit,
    act: (TopRatedMovieCubit cubit) {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchTopRatedMovie();
    },
    expect: () => [isA<TopRatedMovieLoading>(), isA<TopRatedMovieLoaded>()],
    verify: (cubit) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );

  blocTest(
    'should emit [TopRatedMovieLoading, TopRatedMovieFailed] state when data failed',
    build: () => topRatedMovieCubit,
    act: (TopRatedMovieCubit cubit) {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchTopRatedMovie();
    },
    expect: () => [isA<TopRatedMovieLoading>(), isA<TopRatedMovieFailed>()],
    verify: (cubit) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );
}
