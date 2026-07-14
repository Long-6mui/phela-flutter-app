import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.orange, width: 2),
                      color: AppColors.brown.withOpacity(0.5),
                    ),
                    child: const Icon(Icons.local_cafe, size: 60, color: AppColors.orange),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "PHÊ LA",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 4.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "NỐT HƯƠNG ĐẶC SẢN",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.orange,
                      letterSpacing: 3.0,
                    ),
                  ),
                ],
              ),
              const Text(
                "Đánh thức mọi giác quan với dòng trà Ô Long đặc sản từ nông trường Đà Lạt.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
              ),
              AppButton(
                text: "Bắt đầu trải nghiệm",
                backgroundColor: AppColors.orange,
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}