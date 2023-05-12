import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../features/tv_series/presentation/cubit/tv_series_search_cubit.dart';
import '../../features/tv_series/presentation/widgets/tv_series_card_list.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<MovieSearchNotifier>(context, listen: false)
                    .fetchMovieSearch(query);

                context.read<TvSeriesSearchCubit>().fetchTvSeriesSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kTitleLarge,
            ),
            Container(
              width: double.infinity,
              height: 56,
              child: TabBar(
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
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Consumer<MovieSearchNotifier>(
                    builder: (context, data, child) {
                      if (data.state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (data.state == RequestState.Loaded) {
                        final result = data.searchResult;
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final movie = data.searchResult[index];
                            return MovieCard(movie);
                          },
                          itemCount: result.length,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  BlocBuilder<TvSeriesSearchCubit, TvSeriesSearchState>(
                    builder: (context, tvSeriesSearchState) {
                      if (tvSeriesSearchState is TvSeriesSearchLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (tvSeriesSearchState is TvSeriesSearchInitial) {
                        return Container(
                          child: Center(
                            child: Text('Tidak ada daftar yang ditampilkan'),
                          ),
                        );
                      }

                      if (tvSeriesSearchState is TvSeriesSearchLoaded) {
                        final tvSeries = tvSeriesSearchState.tvSeries;

                        if (tvSeries.isEmpty) {
                          return Container(
                            child: Center(
                              child: Text('Tidak ada daftar yang ditampilkan'),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final tvSerie = tvSeries[index];

                            return TvSeriesCard(tvSerie);
                          },
                          itemCount: tvSeries.length,
                        );
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
