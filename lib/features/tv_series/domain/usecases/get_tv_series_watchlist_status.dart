import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';

class GetTvSeriesWatchListStatus {
  final TvSeriesRepository repository;

  GetTvSeriesWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToTvSeriesWatchlist(id);
  }
}
