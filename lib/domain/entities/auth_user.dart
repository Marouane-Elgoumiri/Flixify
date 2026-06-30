/// The current authenticated user.
///
/// Pure Dart — never depends on `firebase_user.User` or any SDK.
/// We map SDK users to this entity inside the data layer.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
}
