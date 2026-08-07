import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../services/auth_storage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đủ thông tin.')));
      }
      return;
    }

    if (newPassword.length < 6) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu mới phải có ít nhất 6 ký tự.')));
      }
      return;
    }

    if (newPassword != confirmPassword) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu xác nhận không khớp.')));
      }
      return;
    }

    setState(() => _isLoading = true);
    final success = await AuthStorage.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công.')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu hiện tại không đúng hoặc cập nhật thất bại.')));
    }
  }

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
              AppTextField(
                label: "Mật khẩu hiện tại",
                hintText: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _currentPasswordController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: "Mật khẩu mới",
                hintText: "••••••••",
                icon: Icons.lock_reset,
                isPassword: true,
                controller: _newPasswordController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: "Xác nhận mật khẩu mới",
                hintText: "••••••••",
                icon: Icons.check_circle_outline,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: _isLoading ? 'Đang cập nhật...' : "Cập Nhật Mật Khẩu",
                backgroundColor: AppColors.orange,
                onPressed: _isLoading ? null : () {
                  _changePassword();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
