import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

/// Exposes authentication state and actions to the widget tree.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _loading = false;
  String? _error;

  AuthProvider(this._authService) {
    // Listen to Firebase auth state so screens react to login/logout.
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _loading;
  String? get error => _error;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) =>
      _run(() => _authService.signInWithEmail(email, password));

  Future<bool> signUp(String email, String password) =>
      _run(() => _authService.signUpWithEmail(email, password));

  Future<bool> signInWithGoogle() =>
      _run(() => _authService.signInWithGoogle());

  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Shared runner: toggles loading, captures errors, returns success flag.
  Future<bool> _run(Future<User?> Function() action) async {
    _error = null;
    _setLoading(true);
    try {
      await action();
      _setLoading(false);
      return true;
    } catch (e) {
      _error = AuthService.describeError(e);
      _setLoading(false);
      return false;
    }
  }
}
