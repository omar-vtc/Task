import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/screens/feeds.dart';
import 'package:feeds_app/app/screens/likes.dart';
import 'package:feeds_app/app/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  Widget activeScreen = FeedsScreen();
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activeScreenTitle = "Feeds";
    if (_selectedScreenIndex == 1) {
      activeScreen = LikesScreen();
      activeScreenTitle = "Likes";
    } else if (_selectedScreenIndex == 2) {
      activeScreen = ProfileScreen();
      activeScreenTitle = "Profile";
    } else {
      activeScreen = BlocProvider(
        create: (_) => FeedBlocBloc(),
        child: FeedsScreen(),
      );
      activeScreenTitle = "Feeds";
    }
    return Scaffold(
      appBar: AppBar(title: Text(activeScreenTitle)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feeds"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: "Liked",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _selectScreen,
      ),
      body: activeScreen,
    );
  }
}
