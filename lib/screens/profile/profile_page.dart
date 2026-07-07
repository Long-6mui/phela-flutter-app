import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            const CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Người dùng PHÊ LA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'user@gmail.com',
              style: TextStyle(color: AppColors.textGrey),
            ),

            const SizedBox(height: 32),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Thông tin cá nhân'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}