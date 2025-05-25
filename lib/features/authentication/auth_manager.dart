import 'package:flutter/foundation.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Future<void> _checkAuthStatus() async {
  //   _setLoading(true);
  //   try {
  //     final isLoggedIn = await _authService.isLoggedIn();
  //     if (isLoggedIn) {
  //       _user = await _authService.getCurrentUser();
  //       _status = AuthStatus.authenticated;
  //     } else {
  //       _status = AuthStatus.unauthenticated;
  //     }
  //   } catch (e) {
  //     _status = AuthStatus.unauthenticated;
  //     _error = e.toString();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future _checkAuthStatus() async {
    _setLoading(true);
    try {
      // Check both SharedPreferences AND Firebase current user
      final isLoggedIn = await _authService.isLoggedIn();
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
        _status = AuthStatus.authenticated;
      } else if (firebaseUser != null) {
        // Reload to get latest verification status
        await firebaseUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null && refreshedUser.emailVerified) {
          // User is signed in with Firebase and email is verified
          // but not saved to SharedPreferences yet - save them now
          final user = UserModel.fromFirebaseUser(refreshedUser);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_user', jsonEncode(user.toJson()));
          await prefs.setString('auth_token',
              'demo-token-${DateTime.now().millisecondsSinceEpoch}');

          _user = user;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
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
        //Manual Email users.
        _setLoading(true);
      } else {
        _setLoading(false); //Google,FaceBook and GitHub
      }
      _user = await _authService.signIn(
        authCase: authCase,
        email: email,
        password: password,
      );
      //Suggestion : Try reloading once more here to sync the changes, only if it didnt work
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
      _status = AuthStatus
          .unauthenticated; //-> Fix tried: Email must be verified only then authenticated is set true
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> resendVerificationEmail() async {
    _error = null;
    try {
      await _authService.resendVerificationEmail();
      return true;
    } catch (e) {
      _error = e is AuthException ? e.message : e.toString();
      notifyListeners();
      return false;
    }
  }
}
