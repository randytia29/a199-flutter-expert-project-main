import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieCubit, PopularMovieState>(
          builder: (context, popularMovieState) {
            if (popularMovieState is PopularMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (popularMovieState is PopularMovieFailed) {
              return Center(
                key: Key('error_message'),
                child: Text(popularMovieState.message),
              );
            }

            if (popularMovieState is PopularMovieLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = popularMovieState.movies[index];

                  return MovieCard(movie);
                },
                itemCount: popularMovieState.movies.length,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
