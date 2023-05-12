import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:ditonton/helpers/database_helper.dart';
import 'package:ditonton/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/features/tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/features/movie/domain/repositories/movie_repository.dart';
import 'package:ditonton/features/tv_series/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/features/tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/features/tv_series/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/features/tv_series/domain/usecases/search_tv_series.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'features/movie/domain/usecases/get_movie_detail.dart';
import 'features/movie/domain/usecases/get_movie_recommendations.dart';
import 'features/movie/domain/usecases/get_now_playing_movies.dart';
import 'features/movie/domain/usecases/get_popular_movies.dart';
import 'features/movie/domain/usecases/get_top_rated_movies.dart';
import 'features/movie/domain/usecases/get_watchlist_movies.dart';
import 'features/movie/domain/usecases/get_watchlist_status.dart';
import 'features/movie/domain/usecases/remove_watchlist.dart';
import 'features/movie/domain/usecases/save_watchlist.dart';
import 'features/movie/domain/usecases/search_movies.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator
      .registerFactory(() => TvSeriesOnAirCubit(onTheAirTvSeries: locator()));

  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesListNotifier(
        getOnTheAirTvSeries: locator(),
        getPopularTvSeries: locator(),
        getTopRatedTvSeries: locator()),
  );
  locator.registerFactory(
    () => PopularTvSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvSeriesNotifier(getTopRatedTvSeries: locator()),
  );
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getTvSeriesWatchListStatus: locator(),
      saveTvSeriesWatchlist: locator(),
      removeTvSeriesWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesSearchNotifier(
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(getWatchlistTvSeries: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvSeriesWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(() =>
      TvSeriesRepositoryImpl(
          remoteDataSource: locator(), localDataSource: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemotaDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
