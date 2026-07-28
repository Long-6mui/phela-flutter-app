import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class VoucherTab extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const VoucherTab({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 46,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.brown
                  : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: selected
                    ? AppColors.brown
                    : Colors.grey.shade300,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.brown.withValues(alpha: .25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : AppColors.textGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}