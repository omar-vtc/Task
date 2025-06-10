import 'package:feeds_app/app/Auth/bloc/auth_bloc.dart';
import 'package:feeds_app/app/Auth/bloc/auth_state.dart';
import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/widgets/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBlocBloc>().add(FetchFeed());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<FeedBlocBloc>().add(FetchFeed());
      }
    });
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<FeedBlocBloc>().add(UploadFeed(image));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String? token;
    String? userId;

    if (authState is Authenticated) {
      userId = authState.user.id;
      token = (authState as Authenticated).token;
    }
    return Scaffold(
      body: BlocBuilder<FeedBlocBloc, FeedBlocState>(
        builder: (context, state) {
          if (state is FeedBlocInitial || state is FeedBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FeedBlocError) {
            return Center(child: Text(state.message));
          } else if (state is FeedBlocLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount:
                  state.hasReachedEnd
                      ? state.item.length
                      : state.item.length + 1,
              itemBuilder: (context, index) {
                if (index < state.item.length) {
                  final item = state.item[index];
                  return FeedItem(
                    imgUrl: item.url,
                    firstName: item.feedPoster.firstName,
                    lastName: item.feedPoster.lastName,
                    isLiked: userId != null && item.likes.contains(userId),
                    onLikeToggle: () {
                      context.read<FeedBlocBloc>().add(
                        ToggleLikeEvent(
                          feedId: item.id,
                          token: token!,
                          userId: userId!,
                        ),
                      );
                    },
                  ); // use correct field
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: IconButton(
        onPressed: _pickAndUploadImage,
        icon: Icon(
          Icons.add_box_rounded,
          size: 40,
          color: const Color.fromARGB(255, 134, 16, 238),
        ),
      ),
    );
  }
}
