import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_storage.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                GestureDetector(
                  onLongPress: () => Navigator.pushNamed(context, AppRoutes.debugClearDb),
                  child: const Text("Chào mừng bạn quay trở lại với Phê La", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                ),
                const SizedBox(height: 36),
                AppTextField(
                  label: "Email",
                  hintText: "name@example.com",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: "Mật khẩu",
                  hintText: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text("Quên mật khẩu?", style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const SizedBox(
                        height: 50,
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
                            ),
                          ),
                        ),
                      )
                    : AppButton(
                        text: "Đăng Nhập",
                        onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Vui lòng nhập đầy đủ email và mật khẩu.")),
                          );
                          return;
                        }

                        if (!email.contains('@') || !email.contains('.')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email không hợp lệ (ví dụ: abc@example.com).")),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        try {
                            final profile = await AuthStorage.loginUser(email: email, password: password);
                            if (profile != null) {
                              await UserProfileService.setCurrentProfile(profile);
                              await AuthStorage.saveLoginStatus(isLoggedIn: true);
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(context, AppRoutes.main);
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Email hoặc mật khẩu không đúng.")),
                                );
                              }
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
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
