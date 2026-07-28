import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../theme/app_colors.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xff4A3324),
            Color(0xff70503C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "PHÊ LA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(18),
            child: QrImageView(
              data: "USER_00001",
              size: 210,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Thành viên Đồng",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "0123 4567 890",
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
            ),
          )
        ],
      ),
    );
  }
}