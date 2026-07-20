import 'dart:typed_data';

enum Gender { male, female }

class UserProfile {
  final String fullName;
  final String email;
  final String phone;
  final String birthDate;
  final Gender gender;
  final Uint8List? avatarBytes;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.gender,
    this.avatarBytes,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? birthDate,
    Gender? gender,
    Uint8List? avatarBytes,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      avatarBytes: avatarBytes ?? this.avatarBytes,
    );
  }
}
