import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /// Sends a password reset email to the specified email address
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Please enter a valid email address');
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email address';
          break;
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        default:
          message = 'Failed to send password reset email: ${e.message}';
      }
      throw AuthException(message);
    } catch (e) {
      throw AuthException('Failed to send password reset email');
    }
  }

  /// Sends a verification email to the current user
  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw AuthException('No authenticated user found');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException('Failed to send verification email: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to send verification email');
    }
  }

  /// Checks if the current user's email is verified
  Future<bool> isEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    } catch (e) {
      throw AuthException('Failed to check email verification status');
    }
  }

  /// Tests social login functionality
  Future<Map<String, dynamic>> testSocialLogin(int provider) async {
    try {
      late UserCredential userCredential;
      String providerName;

      switch (provider) {
        case 1: // Google
          providerName = 'Google';
          final googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) throw AuthException('Google Sign-In cancelled');
          
          final googleAuth = await googleUser.authentication;
          userCredential = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );
          break;

        case 2: // Facebook
          providerName = 'Facebook';
          final loginResult = await FacebookAuth.instance.login();
          if (loginResult.status != LoginStatus.success) {
            throw AuthException('Facebook login failed');
          }
          
          final accessToken = loginResult.accessToken!;
          userCredential = await FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
          break;

        case 3: // GitHub
          providerName = 'GitHub';
          final githubProvider = OAuthProvider('github.com')
            ..addScope('read:user')
            ..addScope('user:email');
          
          userCredential = await FirebaseAuth.instance.signInWithProvider(githubProvider);
          break;

        default:
          throw AuthException('Invalid provider');
      }

      // If login successful, return user info
      return {
        'success': true,
        'provider': providerName,
        'email': userCredential.user?.email,
        'name': userCredential.user?.displayName,
        'uid': userCredential.user?.uid,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'provider': provider == 1 ? 'Google' : provider == 2 ? 'Facebook' : 'GitHub',
      };
    }
  }

//Sign In methods
  Future<UserModel> signIn({
    required int authCase,
    String? email,
    String? password,
  }) async {
    try {
      late UserCredential userCredential;

      if (authCase == 0) {
        // Email/Password
        if (email == null || email.isEmpty || !email.contains('@')) {
          throw AuthException('Invalid email address');
        }

        if (password == null || password.length < 6) {
          throw AuthException('Password must be at least 6 characters');
        }

        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        final user = userCredential.user;
        if (user != null) {
          await user.reload();
          final refreshedUser = FirebaseAuth.instance.currentUser;
          if (refreshedUser != null && !refreshedUser.emailVerified) {
            await FirebaseAuth.instance.signOut();
            throw AuthException(
                'Please verify your email before signing in. Check your inbox for the verification link.');
          }
        }
        //If the above block is skipped the user has authenticated successfully.
      } else if (authCase == 1) {
        // Google Sign-In
        final googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        final googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) throw AuthException("Google Sign-In cancelled");

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          final user = userCredential.user!;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .set({
            'E-mail': user.email,
            'Name': user.displayName,
            'UID': user.uid,
            'Created At': DateTime.now(),
          });
        }
      } else if (authCase == 2) {
        // Facebook Sign-In
        final facebookAuth = FacebookAuth.instance;
        await facebookAuth.logOut();
        final LoginResult loginResult = await facebookAuth.login();

        if (loginResult.status != LoginStatus.success) {
          throw AuthException("Facebook Sign-In cancelled or failed");
        }

        final AccessToken accessToken = loginResult.accessToken!;
        final credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          final user = userCredential.user!;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .set({
            'E-mail': user.email,
            'Name': user.displayName,
            'UID': user.uid,
            'Created At': DateTime.now(),
          });
        }
      } else if (authCase == 3) {
        //github login
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signOut();
        await Future.delayed(const Duration(milliseconds: 500));
        final OAuthProvider githubProvider = OAuthProvider('github.com');
        githubProvider.addScope('read:user');
        githubProvider.addScope('user:email');

        githubProvider.setCustomParameters({
          'prompt': 'select_account',
        });
        try {
          // Trigger the sign-in flow
          userCredential = await auth.signInWithProvider(githubProvider);
          final isNewUser =
              userCredential.additionalUserInfo?.isNewUser ?? false;
          if (isNewUser) {
            final user = userCredential.user!;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.email)
                .set({
              'E-mail': user.email,
              'Name': user.displayName,
              'UID': user.uid,
              'Created At': DateTime.now(),
            });
          }
        } catch (e) {
          throw AuthException('GitHub Sign-In failed: ${e.toString()}');
        }
      } else {
        throw AuthException("Invalid auth method.");
      }

      final currentUser = FirebaseAuth.instance.currentUser!;
      final user = UserModel.fromFirebaseUser(currentUser);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      await prefs.setString(
          _tokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');
      return user;
    } on FirebaseAuthException catch (e) {
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
      throw AuthException(message);
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

      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await userCredential.user?.updateDisplayName(displayName);

        // Send verification email immediately after signup
        await userCredential.user?.sendEmailVerification();

        // Store user data in Firestore
        await _firestore
            .collection("users")
            .doc(userCredential.user?.email)
            .set({
          'E-mail': userCredential.user?.email,
          'Name': displayName,
          'UID': userCredential.user?.uid,
          'Created At': DateTime.now(),
        });

        // Don't save to SharedPreferences yet - wait for verification
        final user = UserModel.fromFirebaseUser(userCredential.user!);
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
        rethrow;
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
      await FirebaseAuth.instance.signOut();
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
