import 'package:ditonton/features/movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailCubit])
void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;

  setUp(() {
    mockMovieDetailCubit = MockMovieDetailCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>(
      create: (context) => mockMovieDetailCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() => mockMovieDetailCubit.close());

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream)
        .thenAnswer((realInvocation) => Stream.value(MovieDetailLoading()));
    when(mockMovieDetailCubit.state).thenReturn(MovieDetailLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(DetailContent()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockMovieDetailCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(MovieDetailFailed(message: 'message')));
    when(mockMovieDetailCubit.state)
        .thenReturn(MovieDetailFailed(message: 'message'));

    final textFinder = find.byType(Text);

    await tester.pumpWidget(_makeTestableWidget(DetailContent()));

    expect(textFinder, findsOneWidget);
  });
}
