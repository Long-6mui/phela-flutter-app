import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

import 'screens/splash/splash_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/auth/forgot_password_page.dart';
import 'screens/auth/change_password_page.dart';
import 'screens/main/main_page.dart';
import 'screens/profile/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> appRoutes = {
      AppRoutes.splash: (context) => const SplashPage(),
      AppRoutes.login: (context) => const LoginPage(),
      AppRoutes.register: (context) => const RegisterPage(),
      AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
      AppRoutes.changePassword: (context) => const ChangePasswordPage(),
      AppRoutes.main: (context) => const MainPage(),
      AppRoutes.profile: (context) => const ProfilePage(),
    };

    return MaterialApp(
      title: 'Phe La App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}