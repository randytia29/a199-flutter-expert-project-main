import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/features/movie/presentation/cubit/change_watchlist_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_detail_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_now_playing_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_recommendation_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_search_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/movie_watchlist_status_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/popular_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/top_rated_movie_cubit.dart';
import 'package:ditonton/features/movie/presentation/cubit/watchlist_movie_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/change_watchlist_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_on_air_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_search_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/tv_series_watchlist_status_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/cubit/watchlist_tv_series_cubit.dart';
import 'package:ditonton/firebase_options.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:http/http.dart' as http;

import 'common/shared.dart';
import 'features/tv_series/presentation/cubit/tv_series_recommendation_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, fatal: true);

    return true;
  };

  await HttpSSLPinning.init();

  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
        BlocProvider(
          create: (context) => di.locator<TvSeriesSearchCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<WatchlistTvSeriesCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<MovieNowPlayingCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<PopularMovieCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<TopRatedMovieCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<MovieDetailCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<MovieRecommendationCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<MovieWatchlistStatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ChangeWatchlistMovieCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<MovieSearchCubit>(),
        ),
        BlocProvider(
          create: (context) => di.locator<WatchlistMovieCubit>(),
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
              return MaterialPageRoute(builder: (_) => TopRatedTvSeriesPage());
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
    );
  }
}

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
