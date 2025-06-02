import 'package:bloc/bloc.dart';
import 'package:feeds_app/domain/entities/media.dart';
import 'package:meta/meta.dart';

part 'feed_bloc_event.dart';
part 'feed_bloc_state.dart';

class FeedBlocBloc extends Bloc<FeedBlocEvent, FeedBlocState> {
  FeedBlocBloc() : super(FeedBlocInitial()) {
    on<FeedBlocEvent>((event, emit) {});
  }
}
