import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';

import '../../features/tv_series/domain/entities/tv_series_detail.dart';

class SaveTvSeriesWatchlist {
  final TvSeriesRepository repository;

  SaveTvSeriesWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail movie) {
    return repository.saveTvSeriesWatchlist(movie);
  }
}
