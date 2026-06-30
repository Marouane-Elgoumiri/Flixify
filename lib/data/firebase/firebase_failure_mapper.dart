import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_app/core/errors/failures.dart';

/// Converts Firebase exceptions to our [Failure].
class FirebaseFailureMapper {
  FirebaseFailureMapper._();

  /// Map a non-typed Firebase exception into a domain-friendly [Failure].
  ///
  /// Used for both `firebase_auth` and `cloud_firestore` errors since they
  /// share a similar code set.
  static Failure fromAuthFirebase(Object e) {
    final msg = e.toString();

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'invalid-credential':
          return ServerFailure(message: 'Invalid email or password.');
        case 'email-already-in-use':
          return ServerFailure(
            message: 'This email is already registered. Try signing in instead.',
          );
        case 'weak-password':
          return ServerFailure(message: 'Password is too weak.');
        case 'network-request-failed':
          return ServerFailure(
            message: 'Network error. Please check your connection.',
          );
        case 'too-many-requests':
          return ServerFailure(message: 'Too many attempts. Try again later.');
        case 'configuration-not-found':
          return const ServerFailure(
            message:
                'Firebase Auth is not configured. Open the Firebase Console and '
                'enable Email/Password + add your Android SHA-1 fingerprint.',
          );
        default:
          return ServerFailure(
            message: e.message ?? 'Authentication error: ${e.code}',
          );
      }
    }

    // Common pattern in some firebase_auth 5.x versions: reCAPTCHA Enterprise
    // not configured -> throws plain Exception with CONFIGURATION_NOT_FOUND.
    if (msg.contains('CONFIGURATION_NOT_FOUND')) {
      return const ServerFailure(
        message:
            'reCAPTCHA Enterprise is not configured for this project. '
            'Open the Firebase Console → Authentication → Settings → '
            'turn OFF "Authentication email enumeration (protection)".',
      );
    }

    // Fallback for Firestore / generic Firebase errors.
    return ServerFailure(
      message: msg.length > 180 ? '${msg.substring(0, 180)}…' : msg,
    );
  }
}
