import 'package:equatable/equatable.dart';

// ============================================================================
// AUTHENTICATION EVENTS
// ============================================================================

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize authentication state (restore session)
class AuthInitialize extends AuthEvent {
  const AuthInitialize();
}

/// Event to register a new user
class AuthRegister extends AuthEvent {
  final String email;
  final String password;

  const AuthRegister({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to login a user
class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to logout the current user
class AuthLogout extends AuthEvent {
  const AuthLogout();
}

// ============================================================================
// AUTHENTICATION STATES
// ============================================================================

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking if user is logged in
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state - authentication operation in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state - user is logged in
class AuthAuthenticated extends AuthState {
  final String email;

  const AuthAuthenticated({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Unauthenticated state - user is not logged in
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state - authentication operation failed
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Success state - registration completed (temporary state before auto-login)
class AuthRegistrationSuccess extends AuthState {
  final String email;

  const AuthRegistrationSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

