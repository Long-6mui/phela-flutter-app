import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/address_service.dart';
import '../../services/auth_storage.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/backgrounds/coffee_background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              ValueListenableBuilder(
                valueListenable: UserProfileService.profileNotifier,
                builder: (context, profile, child) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF5C3A28), Color(0xFF3E271B)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: AppColors.lightBeige,
                          backgroundImage: profile.avatarBytes != null
                              ? MemoryImage(profile.avatarBytes!)
                              : null,
                          child: profile.avatarBytes == null
                              ? Text(
                                  profile.initials,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brown,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                profile.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'THÀNH VIÊN BẠC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Tài khoản'),
              const SizedBox(height: 12),
              _buildSectionCard(context, [
                _buildMenuItem(
                  context,
                  Icons.person_outline,
                  'Thông tin cá nhân',
                  () => Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
                _buildMenuItem(
                  context,
                  Icons.bookmark_outline,
                  'Địa chỉ đã lưu',
                  () => Navigator.pushNamed(context, AppRoutes.savedAddresses),
                ),
                _buildMenuItem(
                  context,
                  Icons.security,
                  'Đổi mật khẩu',
                  () => Navigator.pushNamed(context, AppRoutes.changePassword),
                ),
              ]),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Tiện ích'),
              const SizedBox(height: 12),
              _buildSectionCard(context, [
                _buildMenuItem(
                  context,
                  Icons.receipt_long,
                  'Lịch sử đặt hàng',
                  () {},
                ),
                _buildMenuItem(
                  context,
                  Icons.storefront,
                  'Cửa hàng',
                  () => Navigator.pushNamed(
                    context,
                    AppRoutes.main,
                    arguments: 1,
                  ),
                ),
              ]),
              const SizedBox(height: 18),
              const _SectionHeader(title: 'Khác'),
              const SizedBox(height: 12),
              _buildSectionCard(context, [
                _buildMenuItem(
                  context,
                  Icons.info_outline,
                  'Về chúng tôi',
                  () {},
                ),
                _buildMenuItem(
                  context,
                  Icons.explore,
                  'Khám phá ứng dụng',
                  () => Navigator.pushNamed(
                    context,
                    AppRoutes.main,
                    arguments: 0,
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.brown),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.08),
                    ),
                  ),
                  onPressed: () async {
                    await AddressService.clearAddresses();
                    await UserProfileService.clearProfile();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                  child: const Text(
                    'ĐĂNG XUẤT',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1)
              const Divider(height: 1, color: Color(0xFFF1F1F1)),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? trailing,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            decoration: BoxDecoration(
              color: isHovered ? const Color(0xFFFFF4EA) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                hoverColor: AppColors.orange.withOpacity(0.08),
                splashColor: AppColors.orange.withOpacity(0.15),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.orange, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isHovered
                                ? const Color(0xFF8B4F2F)
                                : AppColors.brown,
                          ),
                        ),
                      ),
                      if (trailing != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightBeige,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trailing,
                            style: const TextStyle(
                              color: AppColors.brown,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.brown,
      ),
    );
  }
}
