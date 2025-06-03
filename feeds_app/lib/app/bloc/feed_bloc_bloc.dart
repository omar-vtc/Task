import 'package:bloc/bloc.dart';
import 'package:feeds_app/app/widgets/feed_item.dart';
import 'package:feeds_app/domain/entities/media.dart';
import 'package:meta/meta.dart';

part 'feed_bloc_event.dart';
part 'feed_bloc_state.dart';

class FeedBlocBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  FeedBlocBloc() : super(FeedBlocInitial()) {
    on<FetchFeed>(_onFetchFeed);
  }

  final List<Media> _items = [];
  int _page = 0;
  bool _isFetching = false;
  bool _hasReachedEnd = false;
  Future<void> _onFetchFeed(
    FetchFeed event,
    Emitter<FeedBlocState> emit,
  ) async {
    if (_isFetching || _hasReachedEnd) return;

    _isFetching = true;

    // Emit loading only if it's the first load
    if (_items.isEmpty) {
      emit(FeedBlocLoading());
    }

    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      final List<Media> newItems = List.generate(
        20,
        (index) => Media(
          id: '$_page-$index',
          imageUrl: 'https://picsum.photos/id/${_page * 20 + index}/300/200',
        ),
      );

      // Simulate reaching the end (you can tweak this logic)
      if (_page >= 10) {
        _hasReachedEnd = true;
      } else {
        _items.addAll(newItems);
        _page++;
      }

      emit(
        FeedBlocLoaded(item: List.from(_items), hasReachedEnd: _hasReachedEnd),
      );
    } catch (e) {
      emit(FeedBlocError('Failed to load images.'));
    } finally {
      _isFetching = false;
    }
  }
}
