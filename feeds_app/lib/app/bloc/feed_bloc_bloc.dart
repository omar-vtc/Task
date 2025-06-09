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
