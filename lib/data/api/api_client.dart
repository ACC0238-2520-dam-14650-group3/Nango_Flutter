import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

/// API Client for IAM Service using HTTP package
class ApiClient {
  // URL de producción del backend
  static const String baseUrl = 'https://iam-service-nango-dam.homeservergv.com/api/v1';

  String? _accessToken;

  /// Set the access token for authenticated requests
  void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Clear the access token
  void clearAccessToken() {
    _accessToken = null;
  }

  /// Get headers for HTTP requests
  Map<String, String> _headers({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
      'Origin': 'https://iam-service-nango-dam.homeservergv.com',
      'Referer': 'https://iam-service-nango-dam.homeservergv.com/',
      'Accept-Language': 'en-US,en;q=0.9',
    };

    if (includeAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  /// Handle HTTP response and throw ApiException on error
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      String errorMessage;

      if (response.body.isEmpty) {
        // Handle empty response body
        switch (response.statusCode) {
          case 403:
            errorMessage = 'Access forbidden. Please check CORS or firewall settings.';
            break;
          case 404:
            errorMessage = 'Endpoint not found. Please verify the API URL.';
            break;
          case 500:
            errorMessage = 'Internal server error. Please try again later.';
            break;
          default:
            errorMessage = 'Request failed with status ${response.statusCode}';
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['detail']?.toString() ??
                        errorBody['message']?.toString() ??
                        'Request failed';
        } catch (e) {
          errorMessage = response.body;
        }
      }

      throw ApiException(errorMessage, response.statusCode);
    }
  }

  // ==========================================================================
  // AUTHENTICATION ENDPOINTS
  // ==========================================================================

  /// Register a new user
  ///
  /// POST /api/v1/auth/register
  ///
  /// Throws [ApiException] on error
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/register');
      final headers = _headers();
      final body = jsonEncode(request.toJson());

      print('[API] POST $uri');

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      print('[API] Register response: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('[API] Register error: ${response.body}');
      }

      final data = _handleResponse(response);
      return RegisterResponse.fromJson(data);
    } catch (e) {
      print('[API] Register exception: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Authenticate user and receive JWT tokens
  ///
  /// POST /api/v1/auth/login
  ///
  /// Throws [ApiException] on error
  Future<TokenResponse> login(LoginRequest request) async {
    try {
      final uri = Uri.parse('$baseUrl/auth/login');
      final headers = _headers();
      final body = jsonEncode(request.toJson());

      print('[API] POST $uri');

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      print('[API] Login response: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('[API] Login error: ${response.body}');
      }

      final data = _handleResponse(response);
      final tokenResponse = TokenResponse.fromJson(data);

      // Automatically set the access token
      setAccessToken(tokenResponse.accessToken);

      return tokenResponse;
    } catch (e) {
      print('[API] Login exception: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // ==========================================================================
  // USER MANAGEMENT ENDPOINTS
  // ==========================================================================

  /// Get list of users (requires authentication)
  ///
  /// GET /api/v1/users/
  ///
  /// [limit] - Maximum number of users to return (default: 50)
  /// [offset] - Number of users to skip for pagination (default: 0)
  ///
  /// Throws [ApiException] on error
  Future<List<UserOut>> getUsers({int limit = 50, int offset = 0}) async {
    try {
      final uri = Uri.parse('$baseUrl/users/').replace(
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: _headers(includeAuth: true),
      );

      final data = _handleResponse(response);

      if (data is List) {
        return data.map((json) => UserOut.fromJson(json)).toList();
      } else {
        throw ApiException('Invalid response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

