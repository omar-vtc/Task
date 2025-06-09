import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/widgets/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  return FeedItem(imgUrl: item.url); // use correct field
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
    );
  }
}
