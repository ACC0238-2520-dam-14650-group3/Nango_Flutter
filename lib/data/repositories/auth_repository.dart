import '../api/api_client.dart';
import '../models/auth_models.dart';
import '../storage/token_manager.dart';

/// Repository for authentication operations
class AuthRepository {
  final ApiClient _apiClient;
  final TokenManager _tokenManager;

  AuthRepository({
    required ApiClient apiClient,
    required TokenManager tokenManager,
  })  : _apiClient = apiClient,
        _tokenManager = tokenManager;

  /// Register a new user
  ///
  /// Returns [RegisterResponse] on success
  /// Throws [ApiException] on error
  Future<RegisterResponse> register({
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(email: email, password: password);
      return await _apiClient.register(request);
    } catch (e) {
      print('[AuthRepository] Register error: $e');
      rethrow;
    }
  }

  /// Login user and store tokens
  ///
  /// Returns [TokenResponse] on success
  /// Throws [ApiException] on error
  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.login(request);

      // Save tokens securely
      await _tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return response;
    } catch (e) {
      print('[AuthRepository] Login error: $e');
      rethrow;
    }
  }

  /// Logout user and clear all tokens
  Future<void> logout() async {
    await _tokenManager.clearTokens();
    _apiClient.clearAccessToken();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasValidTokens();
  }

  /// Restore session from stored token
  Future<void> restoreSession() async {
    final token = await _tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _apiClient.setAccessToken(token);
    }
  }

  /// Get list of users
  ///
  /// Returns [List<UserOut>] on success
  /// Throws [ApiException] on error
  Future<List<UserOut>> getUsers({int limit = 50, int offset = 0}) async {
    return await _apiClient.getUsers(limit: limit, offset: offset);
  }
}

