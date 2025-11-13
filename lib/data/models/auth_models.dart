import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

// ============================================================================
// REQUEST MODELS
// ============================================================================

/// Request model for user registration
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;

  RegisterRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// Request model for user login
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

// ============================================================================
// RESPONSE MODELS
// ============================================================================

/// Response model for user registration
@JsonSerializable()
class RegisterResponse {
  final int id;
  final String email;

  RegisterResponse({
    required this.id,
    required this.email,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

/// Response model for authentication tokens
@JsonSerializable()
class TokenResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}

/// Response model for user information
@JsonSerializable()
class UserOut {
  final int? id;
  final String email;

  @JsonKey(name: 'is_active')
  final bool isActive;

  UserOut({
    this.id,
    required this.email,
    required this.isActive,
  });

  factory UserOut.fromJson(Map<String, dynamic> json) =>
      _$UserOutFromJson(json);
}

// ============================================================================
// ERROR MODELS
// ============================================================================

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

