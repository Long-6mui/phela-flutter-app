import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_storage.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: AppColors.brown)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Text("Đăng Ký", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.brown)),
              const SizedBox(height: 8),
              const Text("Trở thành thành viên Phê La để nhận ưu đãi", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 28),
              AppTextField(label: "Họ và tên", hintText: "Nguyễn Văn A", icon: Icons.person_outline, controller: _nameController),
              const SizedBox(height: 16),
              AppTextField(label: "Email", hintText: "name@example.com", icon: Icons.email_outlined, controller: _emailController),
              const SizedBox(height: 16),
              AppTextField(label: "Số điện thoại", hintText: "0912345678", icon: Icons.phone_outlined, controller: _phoneController),
              const SizedBox(height: 16),
              AppTextField(label: "Mật khẩu", hintText: "Tối thiểu 6 ký tự", icon: Icons.lock_outline, isPassword: true, controller: _passwordController),
              const SizedBox(height: 28),
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
                      text: "Tạo tài khoản",
                      backgroundColor: AppColors.orange,
                      onPressed: () async {
                        final fullName = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final phone = _phoneController.text.trim();
                        final password = _passwordController.text.trim();

                        if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin.")),
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

                          if (password.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Mật khẩu phải có ít nhất 6 ký tự.")),
                            );
                            return;
                          }

                          final registered = await AuthStorage.registerUser(
                            fullName: fullName,
                            email: email,
                            phone: phone,
                            password: password,
                          );

                          if (!registered) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Email này đã tồn tại.")),
                              );
                            }
                            return;
                          }

                          final profile = await AuthStorage.loginUser(email: email, password: password);
                          if (profile != null) {
                            await UserProfileService.setCurrentProfile(profile);
                            await AuthStorage.saveLoginStatus(isLoggedIn: true);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));
                              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Đăng ký thất bại, vui lòng thử lại.")),
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
            ],
          ),
        ),
      ),
    );
  }
}
