import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      appBar: AppBar(
        title: const Text("Đổi Mật Khẩu", style: TextStyle(color: AppColors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.brown),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const AppTextField(label: "Mật khẩu hiện tại", hintText: "••••••••", icon: Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),
              const AppTextField(label: "Mật khẩu mới", hintText: "••••••••", icon: Icons.lock_reset, isPassword: true),
              const SizedBox(height: 16),
              const AppTextField(label: "Xác nhận mật khẩu mới", hintText: "••••••••", icon: Icons.check_circle_outline, isPassword: true),
              const SizedBox(height: 32),
              AppButton(
                text: "Cập Nhật Mật Khẩu",
                backgroundColor: AppColors.orange,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đổi mật khẩu thành công!")));
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