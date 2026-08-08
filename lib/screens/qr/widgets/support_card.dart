import 'package:flutter/material.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dòng chữ phía trên
        const Text(
          'Bạn cần hỗ trợ hãy liên hệ hotline',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Dòng chứa Icon và số điện thoại
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.phone_in_talk_outlined, // Icon điện thoại đang gọi/rung
              color: Color(0xFFB57D52), // Màu nâu Phê La
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              '1900 3013',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Color(0xFFB57D52),
              ),
            ),
          ],
        ),
      ],
    );
  }
}