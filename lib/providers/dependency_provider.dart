import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/storage/token_manager.dart';

/// Provides dependencies throughout the app using Provider
class DependencyProvider extends StatelessWidget {
  final Widget child;

  const DependencyProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide ApiClient as a singleton
        Provider<ApiClient>(
          create: (_) => ApiClient(),
          dispose: (_, apiClient) => apiClient.clearAccessToken(),
        ),

        // Provide TokenManager as a singleton
        Provider<TokenManager>(
          create: (_) => TokenManager(),
        ),

        // Provide AuthRepository with dependencies
        ProxyProvider2<ApiClient, TokenManager, AuthRepository>(
          update: (_, apiClient, tokenManager, __) => AuthRepository(
            apiClient: apiClient,
            tokenManager: tokenManager,
          ),
        ),
      ],
      child: child,
    );
  }
}

