import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  Gender _selectedGender = UserProfileService.profile.gender;
  Uint8List? _avatarBytes = UserProfileService.profile.avatarBytes;

  @override
  void initState() {
    super.initState();
    final profile = UserProfileService.profile;
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _selectedGender = profile.gender;
    _avatarBytes = profile.avatarBytes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _avatarBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: AppColors.lightBeige),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Chỉnh sửa thông tin cá nhân',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.brown, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 22,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 56,
                                  backgroundColor: const Color(0xFFD9C5AB),
                                  backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
                                  child: _avatarBytes == null
                                      ? Text(
                                          UserProfileService.profile.initials,
                                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.brown),
                                        )
                                      : null,
                                ),
                                GestureDetector(
                                  onTap: _pickAvatar,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'THÔNG TIN CÁ NHÂN',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.brown),
                                ),
                                const SizedBox(height: 18),
                                _buildGenderRow(),
                                const SizedBox(height: 20),
                                AppTextField(
                                  label: 'Họ tên',
                                  hintText: 'Cảnh Phước Ngưởng Quang',
                                  icon: Icons.person_outline,
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  label: 'Email',
                                  hintText: 'user.phela@gmail.com',
                                  icon: Icons.email_outlined,
                                  controller: _emailController,
                                ),
                                const SizedBox(height: 16),
                                AppTextField(
                                  label: 'Số điện thoại',
                                  hintText: '0909370523',
                                  icon: Icons.phone_outlined,
                                  controller: _phoneController,
                                ),
                                const SizedBox(height: 24),
                                AppButton(
                                  text: 'Cập nhật tài khoản',
                                  onPressed: () {
                                    UserProfileService.updateProfile(
                                      fullName: _nameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      gender: _selectedGender,
                                      avatarBytes: _avatarBytes,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Thông tin cá nhân đã được cập nhật.')),
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = Gender.male),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _selectedGender == Gender.male ? AppColors.orange : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.brown.withValues(alpha: 0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.male,
                    color: _selectedGender == Gender.male ? AppColors.white : AppColors.brown,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Anh',
                    style: TextStyle(
                      color: _selectedGender == Gender.male ? AppColors.white : AppColors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = Gender.female),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _selectedGender == Gender.female ? AppColors.orange : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.brown.withValues(alpha: 0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.female,
                    color: _selectedGender == Gender.female ? AppColors.white : AppColors.brown,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Chị',
                    style: TextStyle(
                      color: _selectedGender == Gender.female ? AppColors.white : AppColors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
