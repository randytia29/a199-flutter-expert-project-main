import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_watchlist_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_watchlist_status_cubit_test.mocks.dart';

@GenerateMocks([GetTvSeriesWatchListStatus])
void main() {
  late MockGetTvSeriesWatchListStatus mockGetTvSeriesWatchListStatus;
  late TvSeriesWatchlistStatusCubit tvSeriesWatchlistStatusCubit;

  setUp(() {
    mockGetTvSeriesWatchListStatus = MockGetTvSeriesWatchListStatus();
    tvSeriesWatchlistStatusCubit = TvSeriesWatchlistStatusCubit(
        tvSeriesWatchListStatus: mockGetTvSeriesWatchListStatus);
  });

  tearDown(() => tvSeriesWatchlistStatusCubit.close());

  test(
      'bloc should have initial state as [TvSeriesWatchlistStatusInitial]',
      () => expect(tvSeriesWatchlistStatusCubit.state.runtimeType,
          TvSeriesWatchlistStatusInitial));

  blocTest(
    'should emit [TvSeriesWatchlistStatusLoaded] state when data loaded',
    build: () => tvSeriesWatchlistStatusCubit,
    act: (TvSeriesWatchlistStatusCubit cubit) {
      when(mockGetTvSeriesWatchListStatus.execute(1))
          .thenAnswer((_) async => true);

      cubit.loadWatchlistStatus(1);
    },
    expect: () => [isA<TvSeriesWatchlistStatusLoaded>()],
    verify: (cubit) {
      verify(mockGetTvSeriesWatchListStatus.execute(1)).called(1);
    },
  );
}
