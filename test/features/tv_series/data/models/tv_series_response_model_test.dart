import 'dart:convert';

import 'package:ditonton/features/tv_series/data/models/tv_series_model.dart';
import 'package:ditonton/features/tv_series/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    voteAverage: 1.0,
    voteCount: 1,
    name: 'name',
    originCountry: ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
  );

  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  group('fromJson', () {
    test('should return a valid tv series from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/on_the_air.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "poster_path": "/path.jpg",
            "popularity": 1.0,
            "id": 1,
            "backdrop_path": "/path.jpg",
            "vote_average": 1,
            "overview": "Overview",
            "origin_country": ["en"],
            "genre_ids": [1, 2, 3, 4],
            "original_language": "originalLanguage",
            "vote_count": 1,
            "name": "name",
            "original_name": "originalName"
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
