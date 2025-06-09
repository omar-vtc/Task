part of 'feed_bloc_bloc.dart';

@immutable
sealed class FeedBlocEvent {}

class FetchFeed extends FeedBlocEvent {}

// event
class UploadFeed extends FeedBlocEvent {
  final XFile file;

  UploadFeed(this.file);
}
