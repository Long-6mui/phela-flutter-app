import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.brown,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ButtonStyle(
          mouseCursor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return SystemMouseCursors.forbidden;
            }
            return SystemMouseCursors.click;
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered)) {
              return backgroundColor?.withValues(alpha: 0.85);
            }
            return backgroundColor;
          }),
          foregroundColor: WidgetStateProperty.all(textColor),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (states.contains(WidgetState.hovered)) {
              return 6;
            }
            return 2;
          }),
          shadowColor: WidgetStateProperty.all(Colors.black26),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.black.withValues(alpha: 0.08);
            }
            return null;
          }),
        ),
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
      ),
    );
  }
}