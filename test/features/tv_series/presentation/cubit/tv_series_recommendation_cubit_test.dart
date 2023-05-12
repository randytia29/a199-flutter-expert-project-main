import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_recommendation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_recommendation_cubit_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late TvSeriesRecommendationCubit tvSeriesRecommendationCubit;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationCubit = TvSeriesRecommendationCubit(
        tvSeriesRecommendations: mockGetTvSeriesRecommendations);
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

  tearDown(() => tvSeriesRecommendationCubit.close());

  test(
      'bloc should have initial state as [TvSeriesRecommendationInitial]',
      () => expect(tvSeriesRecommendationCubit.state.runtimeType,
          TvSeriesRecommendationInitial));

  blocTest(
    'should emit [TvSeriesRecommendationLoading, TvSeriesRecommendationLoaded] state when data loaded',
    build: () => tvSeriesRecommendationCubit,
    act: (TvSeriesRecommendationCubit cubit) {
      when(mockGetTvSeriesRecommendations.execute(1))
          .thenAnswer((_) async => Right(tTvSeriesList));

      cubit.fetchTvSeriesRecommendation(1);
    },
    expect: () => [
      isA<TvSeriesRecommendationLoading>(),
      isA<TvSeriesRecommendationLoaded>()
    ],
    verify: (cubit) {
      verify(mockGetTvSeriesRecommendations.execute(1)).called(1);
    },
  );

  blocTest(
    'should emit [TvSeriesRecommendationLoading, TvSeriesRecommendationFailed] state when data failed',
    build: () => tvSeriesRecommendationCubit,
    act: (TvSeriesRecommendationCubit cubit) {
      when(mockGetTvSeriesRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      cubit.fetchTvSeriesRecommendation(1);
    },
    expect: () => [
      isA<TvSeriesRecommendationLoading>(),
      isA<TvSeriesRecommendationFailed>()
    ],
    verify: (cubit) {
      verify(mockGetTvSeriesRecommendations.execute(1)).called(1);
    },
  );
}
