import 'package:flutter/material.dart';
import '../screens/splash/splash_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/auth/forgot_password_page.dart';
import '../screens/auth/change_password_page.dart';
import '../screens/auth/debug_clear_db.dart';
import '../screens/profile/profile_page.dart';
import '../screens/profile/edit_profile_page.dart';
import '../screens/profile/edit_address_page.dart';
import '../screens/profile/saved_addresses_page.dart';
import '../screens/profile/add_address_page.dart';
import '../screens/profile/about_page.dart'; 
import '../screens/main/main_page.dart';
import '../screens/store/store_list_page.dart';
import '../screens/profile/explore_app_page.dart';
import '../screens/profile/order_history_page.dart'; // <-- Thêm import cho Lịch sử đặt hàng

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String debugClearDb = '/debug-clear-db';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String savedAddresses = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
  static const String editAddress = '/profile/addresses/edit';
  static const String exploreApp = '/explore-app';
  static const String about = '/about'; 
  static const String main = '/main';
  static const String store = '/store';
  static const String orderHistory = '/order-history';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      changePassword: (context) => const ChangePasswordPage(),
      debugClearDb: (context) => const DebugClearDB(),
      profile: (context) => const ProfilePage(),
      editProfile: (context) => const EditProfilePage(),
      savedAddresses: (context) => const SavedAddressesPage(),
      addAddress: (context) => const AddAddressPage(),
      editAddress: (context) => const EditAddressPage(),
      exploreApp: (context) => const ExploreAppPage(),
      about: (context) => const AboutPage(), 
      main: (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        final initialIndex = args is int ? args : 0;
        return MainPage(initialIndex: initialIndex);
      },
      store: (context) => const StoreListPage(),
      orderHistory: (context) => const OrderHistoryPage(), 
    };
  }
}