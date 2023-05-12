import 'package:ditonton/features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tv_series_detail.dart';
import '../cubit/tv_series_watchlist_status_cubit.dart';

class ButtonWatchlistTvSeries extends StatelessWidget {
  const ButtonWatchlistTvSeries({
    Key? key,
    required this.tvSeries,
  }) : super(key: key);

  final TvSeriesDetail tvSeries;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvSeriesWatchlistStatusCubit,
        TvSeriesWatchlistStatusState>(
      builder: (context, tvSeriesWatchlistStatusState) {
        if (tvSeriesWatchlistStatusState is TvSeriesWatchlistStatusLoaded) {
          final isAddedWatchlist = tvSeriesWatchlistStatusState.status;

          return ElevatedButton(
            onPressed: () async {
              if (!isAddedWatchlist) {
                context
                    .read<ChangeWatchlistTvSeriesCubit>()
                    .addWatchlist(tvSeries);
              } else {
                context
                    .read<ChangeWatchlistTvSeriesCubit>()
                    .removeWatchlist(tvSeries);
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
