import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieCubit, TopRatedMovieState>(
          builder: (context, topRatedMovieState) {
            if (topRatedMovieState is TopRatedMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (topRatedMovieState is TopRatedMovieFailed) {
              return Center(
                key: Key('error_message'),
                child: Text(topRatedMovieState.message),
              );
            }

            if (topRatedMovieState is TopRatedMovieLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = topRatedMovieState.movies[index];

                  return MovieCard(movie);
                },
                itemCount: topRatedMovieState.movies.length,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
