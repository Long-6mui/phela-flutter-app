import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LeafProgress extends StatelessWidget {

  final int current;
  final int target;

  const LeafProgress({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {

    final percent = current / target;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Tiến độ đổi thưởng",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 15),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.orange,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "$current / $target Lá",
            style: const TextStyle(
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}