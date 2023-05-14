import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/features/tv_series/domain/entities/tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';
import 'tv_series_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieNowPlayingCubit>().fetchNowPlayingMovie();
    context.read<PopularMovieCubit>().fetchPopularMovie();
    context.read<TopRatedMovieCubit>().fetchTopRatedMovie();
    context.read<TvSeriesOnAirCubit>().fetchOnTheAirTvSeries();
    context.read<PopularTvSeriesCubit>().fetchPopularTvSeries();
    context.read<TopRatedTvSeriesCubit>().fetchTopRatedTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing Movie',
                style: kTitleLarge,
              ),
              BlocBuilder<MovieNowPlayingCubit, MovieNowPlayingState>(
                builder: (context, movieNowPlayingState) {
                  if (movieNowPlayingState is MovieNowPlayingLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (movieNowPlayingState is MovieNowPlayingLoaded) {
                    return MovieList(movieNowPlayingState.movies);
                  }

                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Popular Movie',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMovieCubit, PopularMovieState>(
                builder: (context, popularMovieState) {
                  if (popularMovieState is PopularMovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (popularMovieState is PopularMovieLoaded) {
                    return MovieList(popularMovieState.movies);
                  }

                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Top Rated Movie',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMovieCubit, TopRatedMovieState>(
                builder: (context, topRatedMovieState) {
                  if (topRatedMovieState is TopRatedMovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (topRatedMovieState is TopRatedMovieLoaded) {
                    return MovieList(topRatedMovieState.movies);
                  }

                  return Text('Failed');
                },
              ),
              Text(
                'On The Air TV Series',
                style: kTitleLarge,
              ),
              BlocBuilder<TvSeriesOnAirCubit, TvSeriesOnAirState>(
                builder: (context, tvSeriesOnAirState) {
                  if (tvSeriesOnAirState is TvSeriesOnAirLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (tvSeriesOnAirState is TvSeriesOnAirLoaded) {
                    return TvSeriesList(tvSeriesOnAirState.tvSeries);
                  }

                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Popular TV Series',
                onTap: () => Navigator.pushNamed(
                    context, PopularTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvSeriesCubit, PopularTvSeriesState>(
                builder: (context, popularTvSeriesState) {
                  if (popularTvSeriesState is PopularTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (popularTvSeriesState is PopularTvSeriesLoaded) {
                    return TvSeriesList(popularTvSeriesState.tvSeries);
                  }

                  return Text('Failed');
                },
              ),
              _buildSubHeading(
                title: 'Top Rated TV Series',
                onTap: () => Navigator.pushNamed(
                    context, TopRatedTvSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvSeriesCubit, TopRatedTvSeriesState>(
                builder: (context, topRatedTvSeriesState) {
                  if (topRatedTvSeriesState is TopRatedTvSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (topRatedTvSeriesState is TopRatedTvSeriesLoaded) {
                    return TvSeriesList(topRatedTvSeriesState.tvSeries);
                  }

                  return Text('Failed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kTitleLarge,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSerie = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tvSerie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSerie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
