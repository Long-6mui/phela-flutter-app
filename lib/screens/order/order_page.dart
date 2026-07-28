import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.lightBeige,
      body: Center(
        child: Text(
          "Đặt hàng",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.brown,
          ),
        ),
      ),
    );
  }
}