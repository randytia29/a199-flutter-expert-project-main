import 'package:ditonton/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/features/movie/presentation/cubit/change_watchlist_movie_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_watchlist_status_cubit.dart';

class ButtonWatchlistMovie extends StatelessWidget {
  const ButtonWatchlistMovie({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieWatchlistStatusCubit, MovieWatchlistStatusState>(
      builder: (context, movieWatchlistStatusState) {
        if (movieWatchlistStatusState is MovieWatchlistStatusLoaded) {
          final isAddedWatchlist = movieWatchlistStatusState.status;

          return ElevatedButton(
            onPressed: () async {
              if (!isAddedWatchlist) {
                context.read<ChangeWatchlistMovieCubit>().addWatchlist(movie);
              } else {
                context
                    .read<ChangeWatchlistMovieCubit>()
                    .removeWatchlistMovie(movie);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                Text('Watchlist'),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
