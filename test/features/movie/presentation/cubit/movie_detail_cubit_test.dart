import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import '../provider/movie_detail_notifier_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailCubit movieDetailCubit;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailCubit = MovieDetailCubit(movieDetail: mockGetMovieDetail);
  });

  tearDown(() => movieDetailCubit.close());

  test('bloc should have initial state as [MovieDetailInitial]',
      () => expect(movieDetailCubit.state.runtimeType, MovieDetailInitial));

  blocTest(
    'should emit [MovieDetailLoading, MovieDetailLoaded] state when data loaded',
    build: () => movieDetailCubit,
    act: (MovieDetailCubit cubit) {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));

      cubit.fetchMovieDetail(1);
    },
    expect: () => [isA<MovieDetailLoading>(), isA<MovieDetailLoaded>()],
    verify: (cubit) {
      verify(mockGetMovieDetail.execute(1)).called(1);
    },
  );

  blocTest(
    'should emit [MovieDetailLoading, MovieDetailFailed] state when data failed',
    build: () => movieDetailCubit,
    act: (MovieDetailCubit cubit) {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchMovieDetail(1);
    },
    expect: () => [isA<MovieDetailLoading>(), isA<MovieDetailFailed>()],
    verify: (cubit) {
      verify(mockGetMovieDetail.execute(1)).called(1);
    },
  );
}
