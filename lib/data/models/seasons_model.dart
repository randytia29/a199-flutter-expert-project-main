import 'package:ditonton/domain/entities/seasons.dart';
import 'package:equatable/equatable.dart';

class SeasonsModel extends Equatable {
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;

  SeasonsModel({
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  factory SeasonsModel.fromJson(Map<String, dynamic> json) => SeasonsModel(
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "episode_count": episodeCount,
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  Seasons toEntity() {
    return Seasons(
        episodeCount: this.episodeCount,
        id: this.id,
        name: this.name,
        overview: this.overview,
        posterPath: this.posterPath,
        seasonNumber: this.seasonNumber);
  }

  @override
  List<Object?> get props =>
      [episodeCount, id, name, overview, posterPath, seasonNumber];
}
