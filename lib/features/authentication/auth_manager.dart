import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthManager extends ChangeNotifier {
  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';
  static const String _lastActiveKey = 'last_active';
  
  final AuthService _authService = AuthService();
  Timer? _sessionTimer;
  
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  bool _loading = false;
  bool _isEmailVerified = false;
  
  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get loading => _loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isEmailVerified => _isEmailVerified;

  AuthManager() {
    _init();
  }

  Future<void> _init() async {
    await _checkAuthStatus();
    _startSessionTimer();
    _setupAuthStateListener();
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

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      final token = prefs.getString(_tokenKey);
      final lastActive = prefs.getInt(_lastActiveKey);
      
      // Check session timeout (30 days)
      if (lastActive != null) {
        final lastActiveTime = DateTime.fromMillisecondsSinceEpoch(lastActive);
        final difference = DateTime.now().difference(lastActive);
        if (difference.inDays > 30) {
          await _clearSession();
          _status = AuthStatus.unauthenticated;
          return;
        }
      }

      final firebaseUser = FirebaseAuth.instance.currentUser;
      
      if (firebaseUser != null) {
        // Reload to get latest verification status
        await firebaseUser.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        
        if (refreshedUser != null) {
          _isEmailVerified = refreshedUser.emailVerified;
          
          if (_isEmailVerified) {
            _user = UserModel.fromFirebaseUser(refreshedUser);
            await _updateSessionData(_user!);
            _status = AuthStatus.authenticated;
            return;
          }
        }
      }
      
      // If we have a saved user but no Firebase user, try to restore session
      if (userJson != null && token != null) {
        try {
          _user = UserModel.fromJson(jsonDecode(userJson));
          _status = AuthStatus.authenticated;
          return;
        } catch (e) {
          await _clearSession();
        }
      }
      
      _status = AuthStatus.unauthenticated;
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

  Future<bool> sendVerificationEmail() async {
    _error = null;
    _setLoading(true);
    try {
      await _authService.sendVerificationEmail();
      return true;
    } catch (e) {
      _error = e is AuthException ? e.message : e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> checkEmailVerification() async {
    try {
      _isEmailVerified = await _authService.isEmailVerified();
      if (_isEmailVerified) {
        _status = AuthStatus.authenticated;
        notifyListeners();
      }
      return _isEmailVerified;
    } catch (e) {
      _error = 'Failed to check email verification status';
      return false;
    }
  }
  
  Future<bool> sendPasswordResetEmail(String email) async {
    _error = null;
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = e is AuthException ? e.message : e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Session management
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _updateLastActive();
    });
  }
  
  Future<void> _updateLastActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastActiveKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  Future<void> _updateSessionData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_userKey, jsonEncode(user.toJson())),
      prefs.setString(_tokenKey, 'token-${DateTime.now().millisecondsSinceEpoch}'),
      _updateLastActive(),
    ]);
  }
  
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_userKey),
      prefs.remove(_tokenKey),
      prefs.remove(_lastActiveKey),
    ]);
  }
  
  void _setupAuthStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _status = AuthStatus.unauthenticated;
        _user = null;
        await _clearSession();
      } else {
        _isEmailVerified = user.emailVerified;
        if (_isEmailVerified) {
          _user = UserModel.fromFirebaseUser(user);
          await _updateSessionData(_user!);
          _status = AuthStatus.authenticated;
        }
      }
      notifyListeners();
    });
  }
  
  /// Tests social login functionality with the specified provider
  /// [provider] 1 for Google, 2 for Facebook, 3 for GitHub
  Future<Map<String, dynamic>> testSocialLogin(int provider) async {
    _error = null;
    _setLoading(true);
    try {
      final result = await _authService.testSocialLogin(provider);
      
      if (result['success'] == true) {
        // If login was successful, update the auth state
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _isEmailVerified = user.emailVerified;
          if (_isEmailVerified) {
            _user = UserModel.fromFirebaseUser(user);
            await _updateSessionData(_user!);
            _status = AuthStatus.authenticated;
          }
        }
      }
      
      return result;
    } catch (e) {
      _error = e.toString();
      return {
        'success': false,
        'error': e.toString(),
        'provider': provider == 1 ? 'Google' : provider == 2 ? 'Facebook' : 'GitHub',
      };
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}
