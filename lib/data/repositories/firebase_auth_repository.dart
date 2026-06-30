import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/data/firebase/firebase_failure_mapper.dart';
import 'package:my_app/data/mappers/auth_user_mapper.dart';
import 'package:my_app/domain/entities/auth_user.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

/// Real implementation of [AuthRepository] using `firebase_auth`.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({required FirebaseAuth firebaseAuth})
      : _auth = firebaseAuth;

  final FirebaseAuth _auth;

  @override
  AuthUser? get currentUser => AuthUserMapper.fromFirebase(_auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map(
        AuthUserMapper.fromFirebase,
      );

  @override
  Future<Result<AuthUser, Failure>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = AuthUserMapper.fromFirebase(cred.user);
      if (user == null) {
        return Error(ServerFailure(message: 'Sign-in succeeded but user was empty'));
      }
      return Success(user);
    } catch (e) {
      debugPrint('signIn error: $e');
      return Error(FirebaseFailureMapper.fromAuthFirebase(e));
    }
  }

  @override
  Future<Result<AuthUser, Failure>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.trim().isNotEmpty) {
        await cred.user?.updateDisplayName(displayName);
        await cred.user?.reload();
      }
      final user = AuthUserMapper.fromFirebase(cred.user);
      if (user == null) {
        return Error(ServerFailure(message: 'Sign-up succeeded but user was empty'));
      }
      return Success(user);
    } catch (e) {
      debugPrint('signUp error: $e');
      return Error(FirebaseFailureMapper.fromAuthFirebase(e));
    }
  }

  @override
  Future<Result<void, Failure>> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Success(null);
    } catch (e) {
      return Error(FirebaseFailureMapper.fromAuthFirebase(e));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await _auth.signOut();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: 'Sign-out failed: $e'));
    }
  }
}
