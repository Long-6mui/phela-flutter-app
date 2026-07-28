import 'package:flutter/material.dart';

class AppShadow {
  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .05),
      blurRadius: 15,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .18),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}