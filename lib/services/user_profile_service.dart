import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserProfileService {
  static final ValueNotifier<UserProfile> profileNotifier = ValueNotifier(
    const UserProfile(
      fullName: 'Khách hàng Phê La',
      email: 'user.phela@gmail.com',
      phone: '0909370523',
      birthDate: '25/10/2006',
      gender: Gender.male,
      avatarBytes: null,
    ),
  );

  static UserProfile get profile => profileNotifier.value;

  static void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? birthDate,
    Gender? gender,
    Uint8List? avatarBytes,
  }) {
    profileNotifier.value = profileNotifier.value.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      birthDate: birthDate,
      gender: gender,
      avatarBytes: avatarBytes,
    );
  }
}
