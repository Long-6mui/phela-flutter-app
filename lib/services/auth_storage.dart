import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/user_profile.dart';

class AuthStorage {
  static const String _loggedInKey = 'is_logged_in';
  static const String _activeUserEmailKey = 'active_user_email';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> saveLoginStatus({required bool isLoggedIn}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLoggedIn);
  }

  static Future<void> saveSessionForUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_activeUserEmailKey, email.trim().toLowerCase());
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_activeUserEmailKey);
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeUserEmailKey)?.toLowerCase();
  }

  static Future<bool> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final existing = await DatabaseHelper.instance.getUserByEmail(email);
      if (existing != null) {
        return false;
      }

      final profile = UserProfile(
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        birthDate: '',
        gender: Gender.male,
      );

      // Debug logging
      print('===== REGISTER DEBUG =====');
      print('Email: ${email.trim()}');
      print('Password length: ${password.length}');
      print('Password: "$password"');
      print('==========================');

      final result = await DatabaseHelper.instance.insertUser(profile, password);
      return result > 0;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<UserProfile?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();
      
      final user = await DatabaseHelper.instance.getUserByEmail(normalizedEmail);
      if (user == null) {
        return null;
      }

      final storedPassword = user['password'] as String?;
      final storedEmail = user['email'] as String?;
      
      // Debug logging
      print('===== LOGIN DEBUG =====');
      print('Input email: $normalizedEmail');
      print('Stored email: $storedEmail');
      print('Input password length: ${password.length}');
      print('Stored password length: ${storedPassword?.length}');
      print('Input password: "$password"');
      print('Stored password: "$storedPassword"');
      print('Password match: ${storedPassword == password}');
      print('=======================');
      
      if (storedPassword != password || storedEmail == null) {
        return null;
      }

      await saveSessionForUser(storedEmail);
      return _profileFromDbMap(user);
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  static Future<UserProfile?> getCurrentUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final activeEmail = prefs.getString(_activeUserEmailKey)?.toLowerCase();
    if (activeEmail == null || activeEmail.isEmpty) {
      return null;
    }

    final user = await DatabaseHelper.instance.getUserByEmail(activeEmail);
    if (user == null) {
      return null;
    }

    return _profileFromDbMap(user);
  }

  static Future<bool> isPhoneUsedByOther(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final activeEmail = prefs.getString(_activeUserEmailKey)?.toLowerCase();
    final normalizedPhone = phone.trim();
    if (normalizedPhone.isEmpty) {
      return false;
    }

    final user = await DatabaseHelper.instance.getUserByPhone(normalizedPhone);
    if (user == null) {
      return false;
    }

    final existingEmail = user['email']?.toString().toLowerCase();
    return existingEmail != null && existingEmail != activeEmail;
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final activeEmail = prefs.getString(_activeUserEmailKey)?.toLowerCase();
    if (activeEmail == null || activeEmail.isEmpty) {
      return false;
    }

    final currentUser = await DatabaseHelper.instance.getUserByEmail(activeEmail);
    if (currentUser == null) {
      return false;
    }

    final storedPassword = currentUser['password'] as String?;
    if (storedPassword == null || storedPassword != currentPassword) {
      return false;
    }

    final profile = _profileFromDbMap(currentUser);
    final updateResult = await DatabaseHelper.instance.updateUserByEmail(activeEmail, profile, newPassword);
    return updateResult > 0;
  }

  static Future<void> updateCurrentUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final activeEmail = prefs.getString(_activeUserEmailKey)?.toLowerCase();
    if (activeEmail == null || activeEmail.isEmpty) {
      return;
    }

    final currentUser = await DatabaseHelper.instance.getUserByEmail(activeEmail);
    if (currentUser == null) {
      return;
    }

    final storedPassword = currentUser['password'] as String? ?? '';
    await DatabaseHelper.instance.updateUserByEmail(activeEmail, profile, storedPassword);
  }

  static UserProfile _profileFromDbMap(Map<String, dynamic> user) {
    return UserProfile(
      fullName: user['fullName']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      birthDate: user['birthDate']?.toString() ?? '',
      gender: Gender.values.firstWhere(
        (gender) => gender.name == (user['gender']?.toString() ?? Gender.male.name),
        orElse: () => Gender.male,
      ),
      avatarBytes: _decodeAvatar(user['avatarBytes']?.toString()),
    );
  }

  static Uint8List? _decodeAvatar(String? encodedBytes) {
    if (encodedBytes == null || encodedBytes.isEmpty) {
      return null;
    }
    return base64Decode(encodedBytes);
  }
}
