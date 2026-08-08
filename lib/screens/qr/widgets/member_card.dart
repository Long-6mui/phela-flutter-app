import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Đưa mã này cho nhân viên",
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
          
          const SizedBox(height: 24),
          
          // ---------------- MÃ QR TO VÀ CÓ LOGO ----------------
          SizedBox(
            width: 260, // Kích thước to ra
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: "21091",
                  version: QrVersions.auto,
                  // Mức độ H (High) bắt buộc phải có để mã QR vẫn quét được khi bị logo che ở giữa
                  errorCorrectionLevel: QrErrorCorrectLevel.H, 
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                  size: 260, // Kích thước to ra
                  padding: EdgeInsets.zero,
                ),
                
                // Vẽ Logo ở giữa
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB5A475), // Màu rêu/vàng giống trong hình
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4), // Viền trắng xung quanh
                  ),
                  child: const Center(
                    // Nếu bạn có ảnh logo thật, đổi đoạn này thành: Image.asset('assets/images/logo.png')
                    child: Icon(
                      Icons.music_note, 
                      color: Colors.black87, 
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // -----------------------------------------------------

          const SizedBox(height: 24),
          const Text(
            "hoặc đọc mã thành viên của bạn",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          
          // Mã số thành viên
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8D8), // Màu nền be nhạt
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "21091",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB57D52), // Màu chữ nâu
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Đường kẻ đứt khúc
          Row(
            children: List.generate(
              40,
              (index) => Expanded(
                child: Container(
                  color: index.isEven ? Colors.grey.shade300 : Colors.transparent,
                  height: 1,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Số nốt nhạc
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Số nốt nhạc tích lũy",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 6),
              Icon(Icons.info, size: 18, color: Color(0xFFB57D52).withOpacity(0.8)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "0",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB57D52),
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.music_note, color: Color(0xFFB57D52), size: 22), 
            ],
          )
        ],
      ),
    );
  }
}