import 'package:feeds_app/app/screens/tabs.dart';
import 'package:feeds_app/app/widgets/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feeds_app/app/screens/feeds.dart';
import 'package:feeds_app/app/screens/login.dart';
import 'package:feeds_app/app/Auth/bloc/auth_bloc.dart';
import 'package:feeds_app/app/Auth/bloc/auth_state.dart';
import 'package:feeds_app/app/Auth/bloc/auth_event.dart';
import 'package:feeds_app/app/Auth/repository/auth_repository.dart';
import 'package:feeds_app/app/Auth/services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AuthBloc(
            authRepository: AuthRepository(),
            storageService: StorageService(),
          )..add(CheckAuthStatus()),
      child: MaterialApp(
        title: 'Feeds App',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (_) => const LoginScreen(),
          '/tabs': (_) => const TabsScreen(),
        },
        home: const AuthWrapper(), // ✅ now reactive
      ),
    );
  }
}
