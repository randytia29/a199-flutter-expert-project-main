import 'package:ditonton/features/movie/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

import 'seasons.dart';

class TvSeriesDetail extends Equatable {
  TvSeriesDetail({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final List<Seasons> seasons;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        id,
        overview,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
        seasons
      ];
}
