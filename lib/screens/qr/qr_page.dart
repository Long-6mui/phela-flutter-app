import 'package:flutter/material.dart';
import 'widgets/member_card.dart';
import 'widgets/support_card.dart';

class QRPage extends StatelessWidget {
  // Đã bỏ const ở đây để không bị lỗi gọi hàm
  QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Lớp ảnh nền dưới cùng
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/coffee_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 2. Lớp phủ mờ (overlay)
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.18)),
          ),
          // 3. Nội dung chính
          SafeArea(
            child: Column(
              children: const [
                SizedBox(height: 20),
                MemberCard(), 
                Spacer(),
                SupportCard(), 
                // Khoảng trống bù trừ cho thanh Navigation Bar
                SizedBox(height: 100), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}