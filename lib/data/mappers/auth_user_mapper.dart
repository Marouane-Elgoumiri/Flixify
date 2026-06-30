import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:my_app/domain/entities/auth_user.dart';

/// Maps `firebase_auth`'s [User] class to our domain [AuthUser].
///
/// Why a mapper?
/// - Domain must not depend on the SDK.
class AuthUserMapper {
  AuthUserMapper._();

  static AuthUser? fromFirebase(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
