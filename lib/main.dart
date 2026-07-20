import 'dart:ui';

import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const PheLaApp());
}

class PheLaApp extends StatelessWidget {
  const PheLaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phe La App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      scrollBehavior: const AppScrollBehavior(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
      PointerDeviceKind.stylus,
    };
  }
}