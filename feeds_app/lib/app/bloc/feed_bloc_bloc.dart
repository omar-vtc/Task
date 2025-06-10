import 'package:bloc/bloc.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/useCases/feed_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'feed_bloc_event.dart';
part 'feed_bloc_state.dart';

class FeedBlocBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  final FeedUseCase feedUseCase;

  FeedBlocBloc({required this.feedUseCase}) : super(FeedBlocInitial()) {
    on<FetchFeed>(_onFetchFeed);
    on<UploadFeed>((event, emit) async {
      try {
        emit(FeedBlocLoading());
        final Feed newFeed = await feedUseCase.uploadFeed(
          event.file,
          event.token,
        );

        _items.insert(0, newFeed);
        emit(
          FeedBlocLoaded(
            item: List.from(_items),
            hasReachedEnd: _hasReachedEnd,
          ),
        );
      } catch (e) {
        emit(FeedBlocError('Upload failed: $e'));
      }
    });

    on<ToggleLikeEvent>((event, emit) async {
      final currentState = state;

      if (currentState is FeedBlocLoaded) {
        List<Feed> updatedItems =
            currentState.item.map((feed) {
              if (feed.id == event.feedId) {
                List<String> updatedLikes = List.from(feed.likes);
                if (updatedLikes.contains(event.userId)) {
                  updatedLikes.remove(event.userId);
                } else {
                  updatedLikes.add(event.userId);
                }
                return feed.copyWith(likes: updatedLikes);
              }
              return feed;
            }).toList();

        // 👇 Filter out from liked feeds if unliked
        if (event.fromLikesScreen) {
          updatedItems =
              updatedItems
                  .where((feed) => feed.likes.contains(event.userId))
                  .toList();
        }

        emit(
          FeedBlocLoaded(
            item: updatedItems,
            hasReachedEnd: currentState.hasReachedEnd,
          ),
        );

        try {
          await feedUseCase.toggleLike(event.feedId, event.token);
        } catch (e) {
          emit(FeedBlocError("Failed to toggle like"));
          // Optional: re-fetch if needed
          if (event.fromLikesScreen) {
            add(FetchLikedFeeds(event.token));
          } else {
            add(FetchFeed());
          }
        }
      }
    });

    on<FetchLikedFeeds>((event, emit) async {
      print("called");
      emit(FeedBlocLoading());
      try {
        final likedFeeds = await feedUseCase.getUserLikedFeeds(event.token);
        emit(FeedBlocLoaded(item: likedFeeds, hasReachedEnd: true));
      } catch (e) {
        emit(FeedBlocError("Failed to load liked feeds"));
      }
    });
  }

  final List<Feed> _items = [];
  int _page = 1;
  final int _limit = 5;
  bool _isFetching = false;
  bool _hasReachedEnd = false;

  Future<void> _onFetchFeed(
    FetchFeed event,
    Emitter<FeedBlocState> emit,
  ) async {
    if (_isFetching || _hasReachedEnd) return;

    _isFetching = true;

    if (_items.isEmpty) {
      emit(FeedBlocLoading());
    }

    try {
      final List<Feed> newFeeds = await feedUseCase.getFeeds(
        page: _page,
        limit: _limit,
      );

      if (newFeeds.isEmpty) {
        _hasReachedEnd = true;
      } else {
        _items.addAll(newFeeds);
        _page++;
      }

      emit(
        FeedBlocLoaded(item: List.from(_items), hasReachedEnd: _hasReachedEnd),
      );
    } catch (e) {
      emit(FeedBlocError('Failed to load feeds: $e'));
    } finally {
      _isFetching = false;
    }
  }
}
