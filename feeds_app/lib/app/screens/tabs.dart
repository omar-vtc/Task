import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/screens/feeds.dart';
import 'package:feeds_app/app/screens/likes.dart';
import 'package:feeds_app/app/screens/profile.dart';
import 'package:feeds_app/domain/useCases/feed_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late final FeedBlocBloc feedBloc;

  int _selectedScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    feedBloc = FeedBlocBloc(feedUseCase: FeedUseCase());
  }

  @override
  void dispose() {
    feedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocProvider.value(value: feedBloc, child: const FeedsScreen()),
      const LikesScreen(),
      const ProfileScreen(),
    ];

    final titles = ["Feeds", "Likes", "Profile"];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedScreenIndex])),
      body: IndexedStack(index: _selectedScreenIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: (index) {
          setState(() => _selectedScreenIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feeds"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Liked",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
