import 'package:feeds_app/app/Auth/bloc/auth_bloc.dart';
import 'package:feeds_app/app/Auth/bloc/auth_state.dart';
import 'package:feeds_app/app/screens/feeds.dart';
import 'package:feeds_app/app/screens/login.dart';
import 'package:feeds_app/app/bloc/feed_bloc_bloc.dart';
import 'package:feeds_app/app/screens/tabs.dart';
import 'package:feeds_app/domain/useCases/feed_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return TabsScreen();
        } else if (state is AuthInitial || state is AuthError) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
