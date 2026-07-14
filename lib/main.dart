import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const PheLaApp());
}

class PheLaApp extends StatelessWidget {
  const PheLaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phê La - Nốt Hương Đặc Sản',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBeige,
        primaryColor: AppColors.brown,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brown),
        fontFamily: 'Roboto', // Bạn có thể thêm font chữ riêng của Phê La vào pubspec.yaml sau
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}