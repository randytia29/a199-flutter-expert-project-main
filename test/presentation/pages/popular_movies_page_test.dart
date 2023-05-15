import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMovieCubit])
void main() {
  late MockPopularMovieCubit mockPopularMovieCubit;

  setUp(() {
    mockPopularMovieCubit = MockPopularMovieCubit();
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

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieCubit>(
      create: (context) => mockPopularMovieCubit,
      child: MaterialApp(home: body),
    );
  }

  tearDown(() => mockPopularMovieCubit.close());

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockPopularMovieCubit.stream)
        .thenAnswer((realInvocation) => Stream.value(PopularMovieLoading()));
    when(mockPopularMovieCubit.state).thenReturn(PopularMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockPopularMovieCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(PopularMovieLoaded(movies: tMovieList)));
    when(mockPopularMovieCubit.state)
        .thenReturn(PopularMovieLoaded(movies: tMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockPopularMovieCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(PopularMovieFailed(message: 'Error Message')));
    when(mockPopularMovieCubit.state)
        .thenReturn(PopularMovieFailed(message: 'Message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
