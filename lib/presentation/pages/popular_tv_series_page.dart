import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';

class PopularTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesCubit, PopularTvSeriesState>(
          builder: (context, popularTvSeriesState) {
            if (popularTvSeriesState is PopularTvSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (popularTvSeriesState is PopularTvSeriesFailed) {
              return Center(
                key: Key('error_message'),
                child: Text(popularTvSeriesState.message),
              );
            }

            if (popularTvSeriesState is PopularTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = popularTvSeriesState.tvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: popularTvSeriesState.tvSeries.length,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
