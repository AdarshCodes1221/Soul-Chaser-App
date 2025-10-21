import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String email;
  final String? displayName;

  const AppUser(this.email, {this.displayName});


  factory AppUser.withDisplayName(String email, String name) {
    return AppUser(email, displayName: name);
  }
}

class AuthService with ChangeNotifier {
  static const _usersKey = 'sc_users_v1';
  static const _currentKey = 'sc_current_user_v1';
  late SharedPreferences _sp;
  bool loading = true;
  AppUser? currentUser;

  // Initialize auth service
  Future<void> init() async {
    try {
      _sp = await SharedPreferences.getInstance();
      final userData = _sp.getString(_currentKey);

      if (userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        currentUser = AppUser(
          userJson['email'],
          displayName: userJson['displayName'],
        );
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _loadUsers() {
    final raw = _sp.getString(_usersKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveUsers(Map<String, dynamic> users) async {
    await _sp.setString(_usersKey, jsonEncode(users));
  }

  String _hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  Future<String?> signup({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final users = _loadUsers();
      final key = email.trim().toLowerCase();

      if (users.containsKey(key)) {
        return 'Account already exists for this email';
      }

      users[key] = {
        'passwordHash': _hash(password),
        'displayName': displayName ?? email.split('@').first,
      };

      await _saveUsers(users);
      currentUser = AppUser.withDisplayName(key, displayName ?? email.split('@').first);
      await _sp.setString(_currentKey, jsonEncode({
        'email': key,
        'displayName': displayName ?? email.split('@').first,
      }));

      return null;
    } catch (e) {
      debugPrint('Signup error: $e');
      return 'An error occurred during signup';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final users = _loadUsers();
      final key = email.trim().toLowerCase();

      if (!users.containsKey(key)) return 'No account found for this email';
      if (users[key]['passwordHash'] != _hash(password)) {
        return 'Incorrect password';
      }

      currentUser = AppUser(
        key,
        displayName: users[key]['displayName'],
      );

      await _sp.setString(_currentKey, jsonEncode({
        'email': key,
        'displayName': users[key]['displayName'],
      }));

      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return 'An error occurred during login';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      loading = true;
      notifyListeners();
      currentUser = null;
      await _sp.remove(_currentKey);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}