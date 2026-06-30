import 'dart:async';

import 'package:get/get.dart';

import 'package:my_app/core/errors/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/utils/result.dart';
import 'package:my_app/domain/entities/auth_user.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/domain/usecases/reset_password.dart';
import 'package:my_app/domain/usecases/sign_in.dart';
import 'package:my_app/domain/usecases/sign_out.dart';
import 'package:my_app/domain/usecases/sign_up.dart';

/// State of the auth flow.
enum AuthStatus { unknown, signedOut, signingIn, signedIn, error }

/// Controller backing all auth screens AND the auth gate.
///
/// Reactive: `Rx<AuthStatus>`, `Rxn<AuthUser>`, `RxString errorMessage`,
/// `RxBool isLoading`. UI binds with [Obx] / [GetBuilder].
class AuthController extends GetxController {
  AuthController({
    required AuthRepository authRepository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _auth = authRepository,
        _signIn = signInUseCase,
        _signUp = signUpUseCase,
        _signOut = signOutUseCase,
        _reset = resetPasswordUseCase;

  final AuthRepository _auth;
  final SignInUseCase _signIn;
  // ignore: unused_field
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  final ResetPasswordUseCase _reset;

  // ─── Reactive state ────────────────────────────────
  final Rx<AuthStatus> status = AuthStatus.unknown.obs;
  final Rxn<AuthUser> user = Rxn<AuthUser>();
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<AuthUser?>? _authSub;

  // ─── Lifecycle ──────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  void _onAuthChanged(AuthUser? next) {
    if (next == null) {
      status.value = AuthStatus.signedOut;
      user.value = null;
    } else {
      status.value = AuthStatus.signedIn;
      user.value = next;
    }
  }

  // ─── Commands ───────────────────────────────────────

  /// Sign in. Returns true on success, false on failure.
  Future<bool> signIn({required String email, required String password}) async {
    return _run(() async {
      final r = await _signIn(SignInParams(email: email, password: password));
      return r;
    });
  }

  /// Sign up. Returns true on success.
  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return _run(() async {
      final r = await _signUp(SignUpParams(
        email: email,
        password: password,
        displayName: displayName,
      ));
      return r;
    });
  }

  /// Send password-reset email.
  Future<bool> sendPasswordReset(String email) async {
    return _run(() async {
      final r = await _reset(email);
      return r;
    });
  }

  Future<void> signOutUser() async {
    isLoading.value = true;
    try {
      await _signOut(NoParams());
    } finally {
      isLoading.value = false;
    }
  }

  /// Driver: sets loading, captures failure messages uniformly.
  Future<bool> _run(Future<Result<dynamic, Failure>> Function() op) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final r = await op();
      return r.when(
        success: (data) => true,
        error: (failure) {
          errorMessage.value = failure.message;
          status.value = AuthStatus.error;
          return false;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
