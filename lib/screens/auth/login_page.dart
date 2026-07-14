import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: AppColors.lightBeige,
=======
      backgroundColor: const Color.fromARGB(255, 229, 10, 10),
>>>>>>> 56ebe6ad04ed382b90dacd2ccb7cec332965ac75
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
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.main),
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