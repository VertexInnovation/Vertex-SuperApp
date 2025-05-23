import 'package:flutter/foundation.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthManager extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  bool _loading = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get loading => _loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthManager() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn({
    required int authCase,
    String? email,
    String? password,
  }) async {
    _error = null;
    try {
      if (authCase == 0) {
        _setLoading(true);
      } else {
        _setLoading(false);
      }
      _user = await _authService.signIn(
        authCase: authCase,
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = e is AuthException ? e.message : e.toString();
      _status = AuthStatus.unauthenticated;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = e is AuthException ? e.message : e.toString();
      _status = AuthStatus.unauthenticated;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
