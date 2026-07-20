import 'package:flutter/material.dart';
import '../../models/address.dart';
import '../../services/address_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_button.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late Address address;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _noteController;
  bool _isDefault = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Address) {
      address = args;
      _nameController = TextEditingController(text: address.recipientName);
      _phoneController = TextEditingController(text: address.phone);
      _addressController = TextEditingController(text: address.address);
      _noteController = TextEditingController(text: address.note);
      _isDefault = address.isDefault;
    } else {
      throw Exception('Address argument is required for EditAddressPage');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    final updatedAddress = address.copyWith(
      recipientName: _nameController.text.trim().isEmpty ? address.recipientName : _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? address.phone : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty ? address.address : _addressController.text.trim(),
      note: _noteController.text.trim(),
      isDefault: _isDefault,
    );
    AddressService.updateAddress(address.id, updatedAddress);
    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void _deleteAddress() {
    AddressService.deleteAddress(address.id);
    if (context.mounted) {
      Navigator.pop(context, true);
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
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.brown),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Sửa địa chỉ',
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
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      value: _isDefault,
                      onChanged: (value) => setState(() => _isDefault = value ?? false),
                      title: const Text('Đặt làm địa chỉ mặc định', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.brown)),
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.brown,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Hoàn tất',
                      onPressed: _saveAddress,
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Xóa địa chỉ', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: _deleteAddress,
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
