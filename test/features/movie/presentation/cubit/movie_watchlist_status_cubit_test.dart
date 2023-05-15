import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/features/movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_watchlist_status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_detail_notifier_test.mocks.dart';

@GenerateMocks([GetWatchListStatus])
void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MovieWatchlistStatusCubit movieWatchlistStatusCubit;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    movieWatchlistStatusCubit =
        MovieWatchlistStatusCubit(watchListStatus: mockGetWatchListStatus);
  });

  tearDown(() => movieWatchlistStatusCubit.close());

  test(
      'bloc should have initial state as [MovieWatchlistStatusInitial]',
      () => expect(movieWatchlistStatusCubit.state.runtimeType,
          MovieWatchlistStatusInitial));

  blocTest(
    'should emit [MovieWatchlistStatusLoaded] state when data loaded',
    build: () => movieWatchlistStatusCubit,
    act: (MovieWatchlistStatusCubit cubit) {
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);

      cubit.loadWatchlistStatus(1);
    },
    expect: () => [isA<MovieWatchlistStatusLoaded>()],
    verify: (cubit) {
      verify(mockGetWatchListStatus.execute(1)).called(1);
    },
  );
}
