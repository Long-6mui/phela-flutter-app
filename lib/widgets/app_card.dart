import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadow.dart';

class AppCard extends StatelessWidget {

  final Widget child;

  final EdgeInsets padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
        boxShadow: AppShadow.card,
      ),
      child: child,
    );
  }
}