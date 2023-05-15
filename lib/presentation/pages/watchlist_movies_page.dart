import 'package:ditonton/common/utils.dart';
import 'package:ditonton/features/movie/presentation/cubit/watchlist_movie_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/watchlist_tv_series_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    context.read<WatchlistMovieCubit>().fetchWatchlistMovie();
    context.read<WatchlistTvSeriesCubit>().fetchWatchlistTvSeries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistMovieCubit>().fetchWatchlistMovie();
    context.read<WatchlistTvSeriesCubit>().fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kDavysGrey,
          tabs: const [
            Tab(
              text: 'Movie',
            ),
            Tab(
              text: 'TV Series',
            )
          ],
          labelStyle: kTitleLarge,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
              builder: (context, watchlistMovieState) {
                if (watchlistMovieState is WatchlistMovieLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (watchlistMovieState is WatchlistMovieFailed) {
                  return Center(
                    key: Key('error_message'),
                    child: Text(watchlistMovieState.message),
                  );
                }

                if (watchlistMovieState is WatchlistMovieLoaded) {
                  final movies = watchlistMovieState.movies;

                  if (movies.isEmpty) {
                    return Center(
                      child: Text('Tidak ada watchlist disimpan'),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final movie = movies[index];

                      return MovieCard(movie);
                    },
                    itemCount: movies.length,
                  );
                }

                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<WatchlistTvSeriesCubit, WatchlistTvSeriesState>(
              builder: (context, watchlistTvSeriesState) {
                if (watchlistTvSeriesState is WatchlistTvSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (watchlistTvSeriesState is WatchlistTvSeriesFailed) {
                  return Center(
                    key: Key('error_message'),
                    child: Text(watchlistTvSeriesState.message),
                  );
                }

                if (watchlistTvSeriesState is WatchlistTvSeriesLoaded) {
                  final tvSeriess = watchlistTvSeriesState.tvSeries;

                  if (tvSeriess.isEmpty) {
                    return Center(
                      child: Text('Tidak ada watchlist disimpan'),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final tvSeries = tvSeriess[index];
                      return TvSeriesCard(tvSeries);
                    },
                    itemCount: tvSeriess.length,
                  );
                }

                return Container();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }
}
