part of 'feed_bloc_bloc.dart';

@immutable
sealed class FeedBlocState {}

final class FeedBlocInitial extends FeedBlocState {}

final class FeedBlocLoading extends FeedBlocState {}

final class FeedBlocLoaded extends FeedBlocState {
  final List<Media> item;
  final bool hasReachedEnd;

  FeedBlocLoaded({required this.item, required this.hasReachedEnd});
}

final class FeedBlocError extends FeedBlocState {
  final String message;
  FeedBlocError(this.message);
}
