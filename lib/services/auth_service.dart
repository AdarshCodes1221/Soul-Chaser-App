import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Represents a signed-in app user
class AppUser {
  final String email;
  final String? displayName;

  const AppUser(this.email, {this.displayName});

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      user.email ?? '',
      displayName: user.displayName,
    );
  }
}

/// AuthService: signup, login, logout, and auth state management
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? currentUser;
  bool loading = true;

  /// Initialize auth state
  Future<void> init() async {
    loading = true;
    notifyListeners();

    // Immediately set currentUser if already signed in
    final user = _auth.currentUser;
    if (user != null) currentUser = AppUser.fromFirebase(user);

    // Listen for auth state changes
    _auth.authStateChanges().listen((user) {
      currentUser = user != null ? AppUser.fromFirebase(user) : null;
      loading = false;
      notifyListeners();
    });

    loading = false;
    notifyListeners();
  }

  /// Sign up with email & password
  Future<String?> signup({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        await credential.user!
            .updateDisplayName(displayName ?? email.split('@').first);
        currentUser = AppUser.fromFirebase(credential.user!);
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Signup failed';
    } catch (e) {
      return 'Unexpected error: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Login with email & password
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        currentUser = AppUser.fromFirebase(credential.user!);
      }

      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return e.message ?? 'Login failed';
      }
    } catch (e) {
      return 'Unexpected error: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      loading = true;
      notifyListeners();
      await _auth.signOut();
      currentUser = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Is user logged in?
  bool get isLoggedIn => currentUser != null;
}
