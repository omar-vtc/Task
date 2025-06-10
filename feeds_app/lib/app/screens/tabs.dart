import 'package:feeds_app/app/Auth/bloc/auth_bloc.dart';
import 'package:feeds_app/app/Auth/bloc/auth_event.dart';
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
      BlocProvider(
        create:
            (_) => FeedBlocBloc(feedUseCase: FeedUseCase())..add(FetchFeed()),
        child: const FeedsScreen(),
      ),
      BlocProvider(
        create: (_) => FeedBlocBloc(feedUseCase: FeedUseCase()),
        child: const LikesScreen(),
      ),
      const ProfileScreen(),
    ];

    final titles = ["Feeds", "Likes", "Profile"];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedScreenIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
          ),
        ],
      ),
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
