part of 'feed_bloc_bloc.dart';

@immutable
sealed class FeedBlocEvent {}

class FetchFeed extends FeedBlocEvent {}

// event
class UploadFeed extends FeedBlocEvent {
  final XFile file;

  UploadFeed(this.file);
}

class ToggleLikeEvent extends FeedBlocEvent {
  final String feedId;
  final String token;
  final String userId;

  ToggleLikeEvent({
    required this.feedId,
    required this.token,
    required this.userId,
  });
}
