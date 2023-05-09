import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

import '../../common/failure.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getOnTheAirTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  // Future<Either<Failure, MovieDetail>> getTvSeriesDetail(int id);
  // Future<Either<Failure, List<Movie>>> getTvSeriesRecommendations(int id);
  // Future<Either<Failure, List<Movie>>> searchTvSeries(String query);
  // Future<Either<Failure, String>> saveTvSeriesWatchlist(MovieDetail movie);
  // Future<Either<Failure, String>> removeTvSeriesWatchlist(MovieDetail movie);
  // Future<bool> isAddedToWatchlist(int id);
  // Future<Either<Failure, List<Movie>>> getWatchlistTvSeries();
}
