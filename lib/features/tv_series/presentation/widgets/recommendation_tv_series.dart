import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants.dart';
import '../../../../presentation/pages/tv_series_detail_page.dart';
import '../cubit/tv_series_recommendation_cubit.dart';

class RecommendationTvSeries extends StatelessWidget {
  const RecommendationTvSeries({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: kTitleLarge,
        ),
        BlocBuilder<TvSeriesRecommendationCubit, TvSeriesRecommendationState>(
          builder: (context, tvSeriesRecommendationState) {
            if (tvSeriesRecommendationState is TvSeriesRecommendationLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (tvSeriesRecommendationState is TvSeriesRecommendationFailed) {
              return Text(tvSeriesRecommendationState.message);
            }

            if (tvSeriesRecommendationState is TvSeriesRecommendationLoaded) {
              final recommendations = tvSeriesRecommendationState.tvSeries;
              return Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final tvSeries = recommendations[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            TvSeriesDetailPage.ROUTE_NAME,
                            arguments: tvSeries.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: recommendations.length,
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
