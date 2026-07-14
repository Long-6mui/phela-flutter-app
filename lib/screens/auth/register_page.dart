import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              const AppTextField(label: "Họ và tên", hintText: "Nguyễn Văn A", icon: Icons.person_outline),
              const SizedBox(height: 16),
              const AppTextField(label: "Email", hintText: "name@example.com", icon: Icons.email_outlined),
              const SizedBox(height: 16),
              const AppTextField(label: "Số điện thoại", hintText: "0912345678", icon: Icons.phone_outlined),
              const SizedBox(height: 16),
              const AppTextField(label: "Mật khẩu", hintText: "Tối thiểu 6 ký tự", icon: Icons.lock_outline, isPassword: true),
              const SizedBox(height: 28),
              AppButton(
                text: "Tạo tài khoản",
                backgroundColor: AppColors.orange,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công! Vui lòng đăng nhập.")));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}