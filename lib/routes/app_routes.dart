import 'package:flutter/material.dart';
import '../screens/splash/splash_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/change_password_page.dart';
import '../screens/profile/profile_page.dart';
import '../screens/main/main_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String profile = '/profile';
  static const String main = '/main';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      changePassword: (context) => const ChangePasswordPage(),
      profile: (context) => const ProfilePage(),
      main: (context) => const MainPage(),
    };
  }
}