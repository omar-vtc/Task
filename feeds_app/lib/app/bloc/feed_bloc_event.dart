part of 'feed_bloc_bloc.dart';

@immutable
sealed class FeedBlocEvent {}

class FetchFeed extends FeedBlocEvent {}
