import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../models/address.dart';
import '../../services/address_service.dart';
import '../../theme/app_colors.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

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
                      'Địa chỉ đã lưu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.brown, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Địa chỉ đã lưu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brown),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, AppRoutes.addAddress);
                        if (result == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã thêm địa chỉ mới.')),
                          );
                        }
                      },
                      child: const Text('Thêm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<List<Address>>(
                valueListenable: AddressService.addressesNotifier,
                builder: (context, addresses, child) {
                  if (addresses.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            'Không có dữ liệu',
                            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: addresses.map((address) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${address.recipientName} • ${address.phone}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brown),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    address.address,
                                    style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5),
                                  ),
                                  if (address.note.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      address.note,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (address.isDefault)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightBeige,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Mặc định',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.brown),
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.editAddress,
                                      arguments: address,
                                    );
                                    if (result == true && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Đã cập nhật địa chỉ.')),
                                      );
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.edit_outlined, color: AppColors.orange),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
