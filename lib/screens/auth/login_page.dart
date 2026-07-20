import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_storage.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Đăng Nhập", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.brown)),
                const SizedBox(height: 8),
                const Text("Chào mừng bạn quay trở lại với Phê La", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                const SizedBox(height: 36),
                const AppTextField(label: "Email", hintText: "name@example.com", icon: Icons.email_outlined),
                const SizedBox(height: 16),
                const AppTextField(label: "Mật khẩu", hintText: "••••••••", icon: Icons.lock_outline, isPassword: true),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text("Quên mật khẩu?", style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: "Đăng Nhập",
                  onPressed: () async {
                    await AuthStorage.saveLoginStatus(isLoggedIn: true);
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.main);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? ", style: TextStyle(color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: const Text("Đăng ký ngay", style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}