import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_recommendation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_recommendation_cubit_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationCubit movieRecommendationCubit;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationCubit = MovieRecommendationCubit(
        movieRecommendations: mockGetMovieRecommendations);
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

  tearDown(() => movieRecommendationCubit.close());

  test(
      'bloc should have initial state as [MovieRecommendationInitial]',
      () => expect(movieRecommendationCubit.state.runtimeType,
          MovieRecommendationInitial));

  blocTest(
    'should emit [MovieRecommendationLoading, MovieRecommendationLoaded] state when data loaded',
    build: () => movieRecommendationCubit,
    act: (MovieRecommendationCubit cubit) {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchMovieRecommendation(1);
    },
    expect: () =>
        [isA<MovieRecommendationLoading>(), isA<MovieRecommendationLoaded>()],
    verify: (cubit) {
      verify(mockGetMovieRecommendations.execute(1)).called(1);
    },
  );

  blocTest(
    'should emit [MovieRecommendationLoading, MovieRecommendationFailed] state when data failed',
    build: () => movieRecommendationCubit,
    act: (MovieRecommendationCubit cubit) {
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchMovieRecommendation(1);
    },
    expect: () =>
        [isA<MovieRecommendationLoading>(), isA<MovieRecommendationFailed>()],
    verify: (cubit) {
      verify(mockGetMovieRecommendations.execute(1)).called(1);
    },
  );
}
