import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants.dart';
import '../../../../presentation/pages/movie_detail_page.dart';
import '../cubit/movie_recommendation_cubit.dart';

class RecommendationMovie extends StatelessWidget {
  const RecommendationMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: kTitleLarge,
        ),
        BlocBuilder<MovieRecommendationCubit, MovieRecommendationState>(
          builder: (context, movieRecommendationState) {
            if (movieRecommendationState is MovieRecommendationLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (movieRecommendationState is MovieRecommendationFailed) {
              return Text(movieRecommendationState.message);
            }

            if (movieRecommendationState is MovieRecommendationLoaded) {
              final recommendations = movieRecommendationState.movies;

              return Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final movie = recommendations[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            MovieDetailPage.ROUTE_NAME,
                            arguments: movie.id,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
