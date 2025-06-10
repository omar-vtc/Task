part of 'feed_bloc_bloc.dart';

@immutable
sealed class FeedBlocEvent {}

class FetchFeed extends FeedBlocEvent {}

// event
class UploadFeed extends FeedBlocEvent {
  final XFile file;
  final String token;

  UploadFeed(this.file, this.token);
}

class ToggleLikeEvent extends FeedBlocEvent {
  final String feedId;
  final String token;
  final String userId;
  final bool fromLikesScreen;

  ToggleLikeEvent({
    required this.feedId,
    required this.token,
    required this.userId,
    this.fromLikesScreen = false,
  });
}

class FetchLikedFeeds extends FeedBlocEvent {
  final String token;

  FetchLikedFeeds(this.token);
}
