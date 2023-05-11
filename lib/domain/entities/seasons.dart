import 'package:equatable/equatable.dart';

class Seasons extends Equatable {
  final int? episodeCount;
  final int? id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;

  Seasons({
    this.episodeCount,
    this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  @override
  List<Object?> get props =>
      [episodeCount, id, name, overview, posterPath, seasonNumber];
}
