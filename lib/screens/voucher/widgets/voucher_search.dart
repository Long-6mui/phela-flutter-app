import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class VoucherSearch extends StatelessWidget {
  const VoucherSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm voucher...",
          hintStyle: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 15,
          ),

          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.orange,
          ),

          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 20,
            ),
          ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }
}