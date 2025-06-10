import 'package:feeds_app/domain/entities/feed_poster.dart';

class Feed {
  final String id;
  final String url;
  final String fileName;
  final String publicId;
  final String mediaType;
  final DateTime uploadedAt;
  final FeedPoster feedPoster;
  final List<String> likes;

  Feed({
    required this.id,
    required this.url,
    required this.fileName,
    required this.publicId,
    required this.mediaType,
    required this.uploadedAt,
    required this.feedPoster,
    required this.likes,
  });
}
