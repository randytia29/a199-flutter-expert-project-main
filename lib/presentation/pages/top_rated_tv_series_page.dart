import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';

class TopRatedTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesCubit, TopRatedTvSeriesState>(
          builder: (context, topRatedTvSeriesState) {
            if (topRatedTvSeriesState is TopRatedTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (topRatedTvSeriesState is TopRatedTvSeriesFailed) {
              return Center(
                key: Key('error_message'),
                child: Text(topRatedTvSeriesState.message),
              );
            }

            if (topRatedTvSeriesState is TopRatedTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = topRatedTvSeriesState.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: topRatedTvSeriesState.tvSeries.length,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
