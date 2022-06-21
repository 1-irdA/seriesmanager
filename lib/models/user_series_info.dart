import 'package:intl/intl.dart';

class UserSeriesInfo {
  static DateFormat df = DateFormat('MM/yyyy');

  final int duration;
  final int seasons;
  final int episodes;
  final DateTime beginAt;
  final DateTime endAt;

  UserSeriesInfo(
      this.duration, this.seasons, this.episodes, this.beginAt, this.endAt);

  UserSeriesInfo.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        seasons = json['seasons'],
        episodes = json['episodes'],
        beginAt = DateTime.parse(json['beginAt']),
        endAt = DateTime.parse(json['endAt']);

  String formatBeginAt() => df.format(beginAt);

  String formatEndAt() => df.format(endAt);
}
