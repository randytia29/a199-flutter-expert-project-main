import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/domain/usecases/search_movies.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_cubit_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;
  late MovieSearchCubit movieSearchCubit;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchCubit = MovieSearchCubit(moviesSearch: mockSearchMovies);
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

  tearDown(() => movieSearchCubit.close());

  test('bloc should have initial state as [MovieSearchInitial]',
      () => expect(movieSearchCubit.state.runtimeType, MovieSearchInitial));

  blocTest(
    'should emit [MovieSearchLoading, MovieSearchLoaded] state when data loaded',
    build: () => movieSearchCubit,
    act: (MovieSearchCubit cubit) {
      when(mockSearchMovies.execute('spiderman'))
          .thenAnswer((_) async => Right(tMovieList));

      cubit.fetchMovieSearch('spiderman');
    },
    expect: () => [isA<MovieSearchLoading>(), isA<MovieSearchLoaded>()],
    verify: (cubit) {
      verify(mockSearchMovies.execute('spiderman')).called(1);
    },
  );

  blocTest(
    'should emit [MovieSearchLoading, MovieSearchFailed] state when data failed',
    build: () => movieSearchCubit,
    act: (MovieSearchCubit cubit) {
      when(mockSearchMovies.execute('spiderman'))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchMovieSearch('spiderman');
    },
    expect: () => [isA<MovieSearchLoading>(), isA<MovieSearchFailed>()],
    verify: (cubit) {
      verify(mockSearchMovies.execute('spiderman')).called(1);
    },
  );
}
