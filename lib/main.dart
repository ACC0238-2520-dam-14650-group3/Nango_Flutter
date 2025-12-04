import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nango_flutter/views/initial_view.dart';
import 'package:nango_flutter/views/home_view.dart';
import 'providers/dependency_provider.dart';
import 'bloc/auth/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DependencyProvider(
      child: MaterialApp(
        title: 'Nango Flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthSplashScreen(),
      ),
    );
  }
}

/// Splash screen that checks authentication status on app start
class AuthSplashScreen extends StatelessWidget {
  const AuthSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        repository: context.read<AuthRepository>(),
      )..add(const AuthInitialize()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // User is logged in, go to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          } else if (state is AuthUnauthenticated) {
            // User is not logged in, show initial view
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InitialView()),
            );
          }
        },
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

