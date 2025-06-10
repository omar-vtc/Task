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
        final Feed newFeed = await feedUseCase.uploadFeed(event.file);

        _items.insert(0, newFeed); // optimistically add to top
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
        // 1. Optimistically update the UI
        List<Feed> updatedItems =
            currentState.item.map((feed) {
              if (feed.id == event.feedId) {
                List<String> updatedLikes = List.from(feed.likes);
                if (updatedLikes.contains(event.userId)) {
                  updatedLikes.remove(event.userId);
                } else {
                  updatedLikes.add(event.userId);
                }
                return Feed(
                  id: feed.id,
                  url: feed.url,
                  fileName: feed.fileName,
                  publicId: feed.publicId,
                  mediaType: feed.mediaType,
                  uploadedAt: feed.uploadedAt,
                  feedPoster: feed.feedPoster,
                  likes: updatedLikes,
                );
              }
              return feed;
            }).toList();

        emit(
          FeedBlocLoaded(
            item: updatedItems,
            hasReachedEnd: currentState.hasReachedEnd,
          ),
        );

        // 2. Call backend use case
        try {
          await feedUseCase.toggleLike(event.feedId, event.token);
        } catch (e) {
          // Optional: handle failure (e.g., revert state or notify user)
          emit(FeedBlocError("Failed to toggle like"));
          // Optionally re-emit previous state or re-fetch
          add(FetchFeed());
        }
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
