import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import 'auth_storage.dart';

class UserProfileService {
  static const _defaultProfile = UserProfile(
    fullName: 'Khách hàng Phê La',
    email: 'user.phela@gmail.com',
    phone: '0909370523',
    birthDate: '25/10/2006',
    gender: Gender.male,
    avatarBytes: null,
  );

  static final ValueNotifier<UserProfile> profileNotifier = ValueNotifier(_defaultProfile);

  static UserProfile get profile => profileNotifier.value;

  static Future<void> initializeProfile() async {
    final profile = await AuthStorage.getCurrentUserProfile();
    if (profile != null) {
      profileNotifier.value = profile;
    }
  }

  static Future<void> setCurrentProfile(UserProfile profile) async {
    profileNotifier.value = profile;
    await AuthStorage.updateCurrentUserProfile(profile);
  }

  static Future<void> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? birthDate,
    Gender? gender,
    Uint8List? avatarBytes,
  }) async {
    final updatedProfile = profileNotifier.value.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      birthDate: birthDate,
      gender: gender,
      avatarBytes: avatarBytes,
    );

    profileNotifier.value = updatedProfile;
    await AuthStorage.updateCurrentUserProfile(updatedProfile);
  }

  static Future<void> clearProfile() async {
    profileNotifier.value = _defaultProfile;
    await AuthStorage.clearSession();
  }
}
