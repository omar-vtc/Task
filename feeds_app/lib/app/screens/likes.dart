import 'package:feeds_app/app/Auth/bloc/auth_bloc.dart';
import 'package:feeds_app/app/Auth/bloc/auth_state.dart';
import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/widgets/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<FeedBlocBloc>().add(FetchLikedFeeds(authState.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String? userId;
    String? token;

    if (authState is Authenticated) {
      userId = authState.user.id;
      token = authState.token;
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
              itemCount: state.item.length,
              itemBuilder: (context, index) {
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
                        fromLikesScreen: true,
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
