import 'package:ditonton/features/movie/presentation/cubit/change_watchlist_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_recommendation_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/watchlist_movie_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_recommendation_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_search_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_watchlist_status_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/watchlist_tv_series_cubit.dart';
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
import 'package:ditonton/main.dart';
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
import 'features/movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'features/movie/presentation/cubit/movie_search_cubit.dart';
import 'features/movie/presentation/cubit/movie_watchlist_status_cubit.dart';

final locator = GetIt.instance;

void init() {
  // Bloc

  // Movie
  locator
      .registerFactory(() => MovieNowPlayingCubit(nowPlayingMovies: locator()));
  locator.registerFactory(() => PopularMovieCubit(popularMovies: locator()));
  locator.registerFactory(() => TopRatedMovieCubit(topRatedMovies: locator()));
  locator.registerFactory(() => MovieDetailCubit(movieDetail: locator()));
  locator.registerFactory(
      () => MovieRecommendationCubit(movieRecommendations: locator()));
  locator.registerFactory(
      () => MovieWatchlistStatusCubit(watchListStatus: locator()));
  locator.registerFactory(() => ChangeWatchlistMovieCubit(
      watchlistSave: locator(), watchlistRemove: locator()));
  locator.registerFactory(() => MovieSearchCubit(moviesSearch: locator()));
  locator
      .registerFactory(() => WatchlistMovieCubit(watchlistMovies: locator()));

  // Tv Series
  locator
      .registerFactory(() => TvSeriesOnAirCubit(onTheAirTvSeries: locator()));
  locator
      .registerFactory(() => PopularTvSeriesCubit(popularTvSeries: locator()));
  locator.registerFactory(
      () => TopRatedTvSeriesCubit(topRatedTvSeries: locator()));
  locator.registerFactory(() => TvSeriesDetailCubit(tvSeriesDetail: locator()));
  locator.registerFactory(
      () => TvSeriesRecommendationCubit(tvSeriesRecommendations: locator()));
  locator.registerFactory(
      () => TvSeriesWatchlistStatusCubit(tvSeriesWatchListStatus: locator()));
  locator.registerFactory(() => ChangeWatchlistTvSeriesCubit(
      saveTvSeries: locator(), removeTvSeries: locator()));
  locator.registerFactory(() => TvSeriesSearchCubit(tvSeriesSearch: locator()));
  locator.registerFactory(
      () => WatchlistTvSeriesCubit(watchlistTvSeries: locator()));

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
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
