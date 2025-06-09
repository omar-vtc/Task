import 'package:feeds_app/domain/entities/feed_poster.dart';

class FeedPosterDto extends FeedPoster {
  FeedPosterDto({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  factory FeedPosterDto.fromJson(Map<String, dynamic> json) {
    return FeedPosterDto(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
