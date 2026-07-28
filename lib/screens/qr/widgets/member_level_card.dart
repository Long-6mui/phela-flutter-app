import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class MemberLevelCard extends StatelessWidget {
  const MemberLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xffC98948),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Hạng thành viên",
                  style: TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "ĐỒNG",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brown,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Tích thêm 265 Lá để lên hạng Bạc",
                  style: TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}