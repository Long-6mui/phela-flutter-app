import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class QuickAction extends StatelessWidget {

  final IconData icon;
  final String title;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
              )
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.orange,
            size: 30,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        )
      ],
    );
  }
}