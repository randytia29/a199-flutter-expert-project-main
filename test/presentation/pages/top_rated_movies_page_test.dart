import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMovieCubit])
void main() {
  late MockTopRatedMovieCubit mockTopRatedMovieCubit;

  setUp(() {
    mockTopRatedMovieCubit = MockTopRatedMovieCubit();
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
    return BlocProvider<TopRatedMovieCubit>(
      create: (context) => mockTopRatedMovieCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockTopRatedMovieCubit.stream)
        .thenAnswer((realInvocation) => Stream.value(TopRatedMovieLoading()));
    when(mockTopRatedMovieCubit.state).thenReturn(TopRatedMovieLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockTopRatedMovieCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(TopRatedMovieLoaded(movies: tMovieList)));
    when(mockTopRatedMovieCubit.state)
        .thenReturn(TopRatedMovieLoaded(movies: tMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockTopRatedMovieCubit.stream).thenAnswer((realInvocation) =>
        Stream.value(TopRatedMovieFailed(message: 'Error Message')));
    when(mockTopRatedMovieCubit.state)
        .thenReturn(TopRatedMovieFailed(message: 'Error Message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
