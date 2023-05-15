import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/features/movie/domain/entities/genre.dart';
import 'package:ditonton/features/movie/presentation/widgets/button_watchlist_movie.dart';
import 'package:ditonton/features/movie/presentation/widgets/recommendation_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../features/movie/presentation/cubit/change_watchlist_movie_cubit.dart';
import '../../features/movie/presentation/cubit/movie_detail_cubit.dart';
import '../../features/movie/presentation/cubit/movie_recommendation_cubit.dart';
import '../../features/movie/presentation/cubit/movie_watchlist_status_cubit.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-movie';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieDetailCubit>().fetchMovieDetail(widget.id);
    context
        .read<MovieRecommendationCubit>()
        .fetchMovieRecommendation(widget.id);
    context.read<MovieWatchlistStatusCubit>().loadWatchlistStatus(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ChangeWatchlistMovieCubit, ChangeWatchlistMovieState>(
        listener: (context, changeWatchlistMovieState) {
          if (changeWatchlistMovieState is ChangeWatchlistMovieLoaded) {
            context
                .read<MovieWatchlistStatusCubit>()
                .loadWatchlistStatus(widget.id);

            ScaffoldMessenger.of(context).clearSnackBars();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(changeWatchlistMovieState.message),
              ),
            );
          }

          if (changeWatchlistMovieState is ChangeWatchlistMovieFailed) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(changeWatchlistMovieState.message),
                  );
                });
          }
        },
        child: DetailContent(),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  DetailContent();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<MovieDetailCubit, MovieDetailState>(
      builder: (context, movieDetailState) {
        if (movieDetailState is MovieDetailLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (movieDetailState is MovieDetailFailed) {
          return Text(movieDetailState.message);
        }

        if (movieDetailState is MovieDetailLoaded) {
          final movie = movieDetailState.movieDetail;

          return Stack(
            children: [
              CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                width: screenWidth,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Container(
                margin: const EdgeInsets.only(top: 48 + 8),
                child: DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: kRichBlack,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 16,
                        right: 16,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: kHeadlineSmall,
                                  ),
                                  ButtonWatchlistMovie(movie: movie),
                                  Text(
                                    _showGenres(movie.genres),
                                  ),
                                  Text(
                                    _showDuration(movie.runtime),
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: movie.voteAverage / 2,
                                        itemCount: 5,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: kMikadoYellow,
                                        ),
                                        itemSize: 24,
                                      ),
                                      Text('${movie.voteAverage}')
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Overview',
                                    style: kTitleLarge,
                                  ),
                                  Text(
                                    movie.overview,
                                  ),
                                  SizedBox(height: 16),
                                  RecommendationMovie(),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              color: Colors.white,
                              height: 4,
                              width: 48,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  // initialChildSize: 0.5,
                  minChildSize: 0.25,
                  // maxChildSize: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: kRichBlack,
                  foregroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
