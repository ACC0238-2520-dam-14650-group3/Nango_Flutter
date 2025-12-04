import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository.dart';

// ============================================================================
// USER EVENTS
// ============================================================================

/// Base class for all user events
abstract class UserEvent {
  const UserEvent();
}

/// Event to fetch list of users
class UserFetch extends UserEvent {
  final int limit;
  final int offset;

  const UserFetch({
    this.limit = 50,
    this.offset = 0,
  });
}

/// Event to refresh user list
class UserRefresh extends UserEvent {
  const UserRefresh();
}

// ============================================================================
// USER STATES
// ============================================================================

/// Base class for all user states
abstract class UserState {
  const UserState();
}

/// Initial state - no users loaded yet
class UserInitial extends UserState {
  const UserInitial();
}

/// Loading state - fetching users
class UserLoading extends UserState {
  const UserLoading();
}

/// Success state - users loaded
class UserLoaded extends UserState {
  final List<UserOut> users;

  const UserLoaded({required this.users});
}

/// Error state - failed to load users
class UserError extends UserState {
  final String message;

  const UserError({required this.message});
}

// ============================================================================
// USER BLOC
// ============================================================================

/// BLoC for managing user operations
class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository _repository;

  UserBloc({required AuthRepository repository})
      : _repository = repository,
        super(const UserInitial()) {
    // Register event handlers
    on<UserFetch>(_onFetch);
    on<UserRefresh>(_onRefresh);
  }

  /// Fetch users from API
  Future<void> _onFetch(
    UserFetch event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final users = await _repository.getUsers(
        limit: event.limit,
        offset: event.offset,
      );

      emit(UserLoaded(users: users));
    } on ApiException catch (e) {
      emit(UserError(message: e.message));
    } catch (e) {
      emit(UserError(message: 'Failed to fetch users: ${e.toString()}'));
    }
  }

  /// Refresh user list (fetch from beginning)
  Future<void> _onRefresh(
    UserRefresh event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final users = await _repository.getUsers(limit: 50, offset: 0);
      emit(UserLoaded(users: users));
    } on ApiException catch (e) {
      emit(UserError(message: e.message));
    } catch (e) {
      emit(UserError(message: 'Failed to refresh users: ${e.toString()}'));
    }
  }
}

