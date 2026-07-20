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
          mouseCursor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return SystemMouseCursors.forbidden;
            }
            return SystemMouseCursors.click;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return backgroundColor?.withOpacity(0.85);
            }
            return backgroundColor;
          }),
          foregroundColor: MaterialStateProperty.all(textColor),
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.hovered)) {
              return 6;
            }
            return 2;
          }),
          shadowColor: MaterialStateProperty.all(Colors.black26),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black.withOpacity(0.08);
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