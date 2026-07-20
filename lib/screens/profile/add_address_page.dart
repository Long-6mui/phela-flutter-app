import 'package:flutter/material.dart';
import '../../models/address.dart';
import '../../services/address_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'Thêm địa chỉ',
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
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Tên người nhận',
                      hintText: 'Nhập tên người nhận',
                      icon: Icons.person_outline,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Địa chỉ',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.brown),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: '',
                      hintText: 'Nhập địa chỉ',
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Ghi chú khác',
                      hintText: 'Thêm ghi chú',
                      icon: Icons.note_alt_outlined,
                      controller: _noteController,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Lưu',
                      onPressed: () {
                        AddressService.addAddress(
                          Address(
                            recipientName: _nameController.text.isEmpty ? 'Khách hàng Phê La' : _nameController.text,
                            phone: _phoneController.text.isEmpty ? '0909370523' : _phoneController.text,
                            address: _addressController.text.isEmpty ? 'Chưa có địa chỉ' : _addressController.text,
                            note: _noteController.text,
                          ),
                        );
                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
