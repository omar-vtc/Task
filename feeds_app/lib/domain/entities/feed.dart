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

  // Add this method:
  Feed copyWith({
    String? id,
    String? url,
    String? fileName,
    String? publicId,
    String? mediaType,
    DateTime? uploadedAt,
    FeedPoster? feedPoster,
    List<String>? likes,
  }) {
    return Feed(
      id: id ?? this.id,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      publicId: publicId ?? this.publicId,
      mediaType: mediaType ?? this.mediaType,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      feedPoster: feedPoster ?? this.feedPoster,
      likes: likes ?? this.likes,
    );
  }
}
