import 'dart:convert';

import 'package:feeds_app/data/models/feed_poster_dto.dart';
import 'package:feeds_app/domain/entities/feed.dart';

class FeedDto extends Feed {
  FeedDto({
    required super.id,
    required super.url,
    required super.fileName,
    required super.publicId,
    required super.mediaType,
    required super.uploadedAt,
    required super.feedPoster,
  });

  factory FeedDto.fromJson(Map<String, dynamic> json) {
    return FeedDto(
      id: json['_id'],
      url: json['url'],
      fileName: json['fileName'],
      publicId: json['publicId'],
      mediaType: json['mediaType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      feedPoster: FeedPosterDto.fromJson(json['userId']),
    );
  }
}
