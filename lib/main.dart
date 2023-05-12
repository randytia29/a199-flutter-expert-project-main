import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_watchlist_status_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/tv_series_search_notifier.dart';
import 'package:ditonton/features/movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/features/tv_series/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

import 'features/tv_series/presentation/cubit/tv_series_recommendation_cubit.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (context) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => di.locator<TvSeriesOnAirCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<PopularTvSeriesCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<TopRatedTvSeriesCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<TvSeriesDetailCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<TvSeriesRecommendationCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<TvSeriesWatchlistStatusCubit>(),
          ),
          BlocProvider(
            create: (context) => di.locator<ChangeWatchlistTvSeriesCubit>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
          ),
          home: HomeMoviePage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomeMoviePage());
              case PopularMoviesPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
              case TopRatedMoviesPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
              case MovieDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => MovieDetailPage(id: id),
                  settings: settings,
                );
              case TvSeriesDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => TvSeriesDetailPage(id: id),
                  settings: settings,
                );
              case SearchPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => SearchPage());
              case WatchlistMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
              case AboutPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => AboutPage());
              case PopularTvSeriesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => PopularTvSeriesPage());
              case TopRatedTvSeriesPage.ROUTE_NAME:
                return MaterialPageRoute(
                    builder: (_) => TopRatedTvSeriesPage());
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                });
            }
          },
        ),
      ),
    );
  }
}
