import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_storage.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: UserProfileService.profileNotifier,
              builder: (context, profile, child) {
                return Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
                  decoration: const BoxDecoration(
                    color: AppColors.brown,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.orange,
                        backgroundImage: profile.avatarBytes != null ? MemoryImage(profile.avatarBytes!) : null,
                        child: profile.avatarBytes == null
                            ? Text(profile.initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.fullName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(profile.email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(12)),
                            child: const Text("THÀNH VIÊN BẠC", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuItem(Icons.person_outline, "Chỉnh sửa thông tin cá nhân", () => Navigator.pushNamed(context, AppRoutes.editProfile)),
                  _buildMenuItem(Icons.bookmark_outline, "Địa chỉ đã lưu", () => Navigator.pushNamed(context, AppRoutes.savedAddresses)),
                  _buildMenuItem(Icons.receipt_long, "Lịch sử đơn hàng", () {}),
              _buildMenuItem(Icons.card_giftcard, "Ưu đãi của tôi", () {}, trailing: "3"),
              _buildMenuItem(Icons.security, "Đổi mật khẩu", () => Navigator.pushNamed(context, AppRoutes.changePassword)),
              _buildMenuItem(Icons.headset_mic_outlined, "Hỗ trợ & CSKH", () {}),
              const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: ButtonStyle(
                        mouseCursor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return SystemMouseCursors.forbidden;
                          }
                          return SystemMouseCursors.click;
                        }),
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.red.shade700;
                          }
                          return Colors.red;
                        }),
                        side: MaterialStateProperty.resolveWith<BorderSide?>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return const BorderSide(color: Colors.redAccent);
                          }
                          return const BorderSide(color: Colors.red);
                        }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.red.withOpacity(0.08);
                          }
                          return null;
                        }),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text("ĐĂNG XUẤT", style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await AuthStorage.saveLoginStatus(isLoggedIn: false);
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {String? trailing}) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isHovered ? const Color(0xFFFFF4EA) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isHovered ? 0.08 : 0.03),
                  blurRadius: isHovered ? 14 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                hoverColor: AppColors.orange.withOpacity(0.08),
                splashColor: AppColors.orange.withOpacity(0.15),
                onTap: onTap,
                child: ListTile(
                  leading: Icon(icon, color: isHovered ? AppColors.orange : AppColors.orange),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isHovered ? const Color(0xFF8B4F2F) : AppColors.brown,
                      fontSize: 15,
                    ),
                  ),
                  trailing: trailing != null
                      ? CircleAvatar(radius: 12, backgroundColor: Colors.red.shade100, child: Text(trailing, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)))
                      : Icon(Icons.arrow_forward_ios, size: 16, color: isHovered ? AppColors.orange : AppColors.textGrey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}