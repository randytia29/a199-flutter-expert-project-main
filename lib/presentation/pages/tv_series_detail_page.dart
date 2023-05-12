import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/features/movie/domain/entities/genre.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import '../../features/tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import '../../features/tv_series/presentation/cubit/tv_series_recommendation_cubit.dart';
import '../../features/tv_series/presentation/cubit/tv_series_watchlist_status_cubit.dart';
import '../../features/tv_series/presentation/provider/tv_series_detail_notifier.dart';
import '../../features/tv_series/presentation/widgets/button_watchlist_tv_series.dart';
import '../../features/tv_series/presentation/widgets/recommendation_tv_series.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<TvSeriesDetailCubit>().fetchTvSeriesDetail(widget.id);
    context
        .read<TvSeriesRecommendationCubit>()
        .fetchTvSeriesRecommendation(widget.id);
    context.read<TvSeriesWatchlistStatusCubit>().loadWatchlistStatus(widget.id);

    Future.microtask(() {
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .fetchTvSeriesDetail(widget.id);
      Provider.of<TvSeriesDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ChangeWatchlistTvSeriesCubit,
          ChangeWatchlistTvSeriesState>(
        listener: (context, changeWatchlistTvSeriesState) {
          if (changeWatchlistTvSeriesState is ChangeWatchlistTvSeriesLoaded) {
            context
                .read<TvSeriesWatchlistStatusCubit>()
                .loadWatchlistStatus(widget.id);

            ScaffoldMessenger.of(context).clearSnackBars();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(changeWatchlistTvSeriesState.message),
              ),
            );
          }

          if (changeWatchlistTvSeriesState is ChangeWatchlistTvSeriesFailed) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(changeWatchlistTvSeriesState.message),
                  );
                });
          }
        },
        child: Consumer<TvSeriesDetailNotifier>(
          builder: (context, provider, child) {
            if (provider.tvSeriesState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.tvSeriesState == RequestState.Loaded) {
              return SafeArea(
                child: DetailContent(),
              );
            } else {
              return Text(provider.message);
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<TvSeriesDetailCubit, TvSeriesDetailState>(
      builder: (context, tvSeriesDetailState) {
        if (tvSeriesDetailState is TvSeriesDetailLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (tvSeriesDetailState is TvSeriesDetailFailed) {
          return Text(tvSeriesDetailState.message);
        }

        if (tvSeriesDetailState is TvSeriesDetailLoaded) {
          final tvSeries = tvSeriesDetailState.tvSeriesDetail;

          return Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
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
                                    tvSeries.name,
                                    style: kHeadlineSmall,
                                  ),
                                  ButtonWatchlistTvSeries(tvSeries: tvSeries),
                                  Text(
                                    _showGenres(tvSeries.genres),
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: tvSeries.voteAverage / 2,
                                        itemCount: 5,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: kMikadoYellow,
                                        ),
                                        itemSize: 24,
                                      ),
                                      Text('${tvSeries.voteAverage}')
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    height: 175,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tvSeries.seasons.length,
                                      itemBuilder: (context, index) {
                                        final season = tvSeries.seasons[index];

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 125,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${season.posterPath ?? tvSeries.posterPath}',
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Text(season.name ?? ''),
                                            Text(
                                              '${season.episodeCount.toString()} Episode',
                                            ),
                                          ],
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          width: 8,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Overview',
                                    style: kTitleLarge,
                                  ),
                                  Text(
                                    tvSeries.overview,
                                  ),
                                  SizedBox(height: 16),
                                  RecommendationTvSeries(),
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
}
