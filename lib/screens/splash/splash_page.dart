import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/auth_storage.dart';
import '../../services/address_service.dart';
import '../../services/user_profile_service.dart';
import '../../database/database_helper.dart';
import '../auth/login_page.dart';
import '../main/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      // Initialize database to avoid lag on first login
      await DatabaseHelper.instance.database;

      final loggedIn = await AuthStorage.isLoggedIn();
      if (loggedIn) {
        await UserProfileService.initializeProfile();
        await AddressService.initializeAddresses();
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 900),
          pageBuilder: (context, animation, secondaryAnimation) {
            return loggedIn ? const MainPage() : const LoginPage();
          },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final fadeAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              final scaleAnimation = Tween<double>(
                begin: 0.94,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              );

              final slideAnimation = Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              );

              return FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash/splash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}