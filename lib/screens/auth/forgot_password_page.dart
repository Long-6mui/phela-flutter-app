import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: AppColors.brown)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.key_outlined, size: 64, color: AppColors.brown),
              const SizedBox(height: 16),
              const Text("Quên Mật Khẩu", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.brown)),
              const SizedBox(height: 8),
              const Text("Nhập email đăng ký để nhận hướng dẫn đặt lại mật khẩu mới.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey, height: 1.4)),
              const SizedBox(height: 32),
              const AppTextField(label: "Email của bạn", hintText: "name@example.com", icon: Icons.email_outlined),
              const SizedBox(height: 24),
              AppButton(
                text: "Gửi mã xác nhận",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã gửi liên kết khôi phục vào Email!")));
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