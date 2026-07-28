import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SupportCard extends StatelessWidget {

  const SupportCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(

        children: [

          const Icon(
            Icons.support_agent,
            color: AppColors.orange,
          ),

          const SizedBox(width:15),

          const Expanded(
            child: Text(
              "Cần hỗ trợ? Liên hệ ngay với Phê La",
            ),
          ),

          ElevatedButton(

            onPressed: () {},

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brown,
            ),

            child: const Text("Liên hệ"),
          )

        ],
      ),

    );

  }
}