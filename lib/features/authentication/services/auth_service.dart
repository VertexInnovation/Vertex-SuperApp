import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';

  // This would be replaced with actual API calls in production
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Validate credentials (replace with actual API call)
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Invalid email address');
      }
      
      if (password.isEmpty || password.length < 6) {
        throw AuthException('Password must be at least 6 characters');
      }

      // For demo, we'll create a user with the email
      final user = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@').first,
        createdAt: DateTime.now(),
      );

      // Save user to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(_tokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');

      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Validate input (replace with actual API call)
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Invalid email address');
      }
      
      if (password.isEmpty || password.length < 6) {
        throw AuthException('Password must be at least 6 characters');
      }

      if (displayName.isEmpty) {
        throw AuthException('Display name cannot be empty');
      }

      // For demo, create a user
      final user = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      // Save user to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(_tokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');

      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  Future<bool> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
      return true;
    } catch (e) {
      debugPrint('Error signing out: $e');
      return false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;
      
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_tokenKey);
    } catch (e) {
      return false;
    }
  }
}