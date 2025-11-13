import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';

export 'auth_event.dart';

// ============================================================================
// AUTHENTICATION STATES
// ============================================================================

/// Base class for all authentication states
abstract class AuthState {
  const AuthState();
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
}

/// Unauthenticated state - user is not logged in
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state - authentication operation failed
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}

/// Success state - registration completed (temporary state before auto-login)
class AuthRegistrationSuccess extends AuthState {
  final String email;

  const AuthRegistrationSuccess({required this.email});
}

// ============================================================================
// AUTHENTICATION BLOC
// ============================================================================

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    // Register event handlers
    on<AuthInitialize>(_onInitialize);
    on<AuthRegister>(_onRegister);
    on<AuthLogin>(_onLogin);
    on<AuthLogout>(_onLogout);
  }

  /// Initialize authentication - restore session if tokens exist
  Future<void> _onInitialize(
    AuthInitialize event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final isLoggedIn = await _repository.isLoggedIn();

      if (isLoggedIn) {
        await _repository.restoreSession();
        // We don't have user email in token storage, so we emit authenticated without email
        // In a real app, you might want to decode the JWT or fetch user info
        emit(const AuthAuthenticated(email: ''));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Register a new user
  Future<void> _onRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _repository.register(
        email: event.email,
        password: event.password,
      );

      // Emit success state temporarily
      emit(AuthRegistrationSuccess(email: response.email));

      // Auto-login after successful registration
      add(AuthLogin(email: event.email, password: event.password));
    } on ApiException catch (e) {
      print('[AuthBloc] Register error: ${e.message}');
      emit(AuthError(message: e.message));
    } catch (e) {
      print('[AuthBloc] Register exception: $e');
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  /// Login user
  Future<void> _onLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _repository.login(
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(email: event.email));
    } on ApiException catch (e) {
      print('[AuthBloc] Login error: ${e.message}');
      emit(AuthError(message: e.message));
    } catch (e) {
      print('[AuthBloc] Login exception: $e');
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  /// Logout user
  Future<void> _onLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails, we should still emit unauthenticated
      emit(const AuthUnauthenticated());
    }
  }
}

