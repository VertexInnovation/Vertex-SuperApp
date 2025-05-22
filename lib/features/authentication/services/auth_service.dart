import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // {// Simulate network delay
      // await Future.delayed(const Duration(milliseconds: 1500));

      // Validate credentials (replace with actual API call)
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Invalid email address');
      }

      if (password.isEmpty || password.length < 6) {
        throw AuthException('Password must be at least 6 characters');
      }

      // // For demo, we'll create a user with the email
      // final user = UserModel(
      //   id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      //   email: email,
      //   displayName: email.split('@').first,
      //   createdAt: DateTime.now(),
      // );

      //User Sign in through firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = UserModel.fromFirebaseUser(userCredential.user!);

      // Save user to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(
          _tokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');

      return user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      //use message for snackbar stuff
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later.';
          break;
        default:
          message = 'Authentication error: ${e.message}';
          break;
      }

      // You can show a user-friendly message based on e.code (e.g., 'user-not-found', 'wrong-password')
      // Show SnackBar (requires BuildContext)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: Colors.red,
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );

      throw AuthException('Firebase error: ${e.message}');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw AuthException('Google sign-in cancelled');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = UserModel.fromFirebaseUser(userCredential.user!);

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(
          _tokenKey, 'google-token-${DateTime.now().millisecondsSinceEpoch}');
      return user;
    } catch (e) {
      throw AuthException(e.toString());
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
      // final user = UserModel(
      //   id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      //   email: email,
      //   displayName: displayName,
      //   createdAt: DateTime.now(),
      // );

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = UserModel.fromFirebaseUser(userCredential.user!);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user.toJson()));
        await prefs.setString(
            _tokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');

        return user;
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase authentication errors
        if (e.code == 'weak-password') {
          // The password provided is too weak.
          print('Error: The password provided is too weak.');
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'The password provided is too weak.',
          );
        } else if (e.code == 'email-already-in-use') {
          // The account already exists for that email.
          print('Error: The account already exists for that email.');
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'An account already exists with that email.',
          );
        }
        // Re-throw other FirebaseAuthExceptions to be handled by the caller
        throw e;
      }
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
