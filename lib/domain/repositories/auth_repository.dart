import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/auth_user.dart';

/// Abstract contract for authentication.
///
/// The data layer will provide a `FirebaseAuthRepository` that implements
/// this against `firebase_auth`. Tests or stub layers may swap in
/// different backing implementations.
abstract class AuthRepository {
  /// Currently signed-in user (synchronous — null if not logged in).
  AuthUser? get currentUser;

  /// Real-time stream of the signed-in user. Emits when auth state changes.
  Stream<AuthUser?> authStateChanges();

  /// Sign in with email/password.
  Future<Result<AuthUser, Failure>> signIn({
    required String email,
    required String password,
  });

  /// Register a new account with email/password and an optional display name.
  Future<Result<AuthUser, Failure>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Send a password-reset email.
  Future<Result<void, Failure>> sendPasswordReset({required String email});

  /// Sign out the current user.
  Future<Result<void, Failure>> signOut();
}
