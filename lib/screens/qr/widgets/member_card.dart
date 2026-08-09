import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:qr_flutter/qr_flutter.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  // 1. Hàm thực hiện Copy và hiện thông báo màu xanh ở trên cùng
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: "99343"));

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    bool isRemoved = false;

    void removeOverlay() {
      if (!isRemoved) {
        entry.remove();
        isRemoved = true;
      }
    }

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top, 
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFF4CB050), 
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Đã sao chép',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: removeOverlay,
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      removeOverlay();
    });
  }

  // 2. Hàm hiển thị Bảng Chính sách tích lũy điểm (Giống hình 2 & 3)
  void _showPolicySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bảng hiển thị cao hơn mức mặc định
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Lấy chiều cao màn hình để giới hạn chiều cao tối đa của popup
        final screenHeight = MediaQuery.of(context).size.height;
        
        return Container(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.9), // Tối đa 90% màn hình
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // --- PHẦN HEADER (Cố định, không cuộn) ---
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 24, right: 16, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Chính sách tích lũy điểm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                        IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // --- PHẦN NỘI DUNG CHÍNH (Có thể cuộn) ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tên gọi điểm: Nốt nhạc', style: TextStyle(fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                          children: [
                            TextSpan(text: 'Tỷ lệ quy đổi điểm tích lũy: '),
                            TextSpan(text: '20.000 đồng = 1 Nốt nhạc', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tỷ lệ quy đổi điểm là quy đổi từ số tiền tiêu dùng thực tế sang số điểm tích lũy, tỷ lệ quy đổi được áp dụng cho tất cả các hạng thẻ',
                        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      const Text('Lưu ý:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),
                      
                      // Các gạch đầu dòng
                      _buildBulletPoint('Điểm tích lũy không có thời hạn sử dụng, toàn bộ số điểm tích lũy của Khách hàng sẽ được bảo toàn không bị ảnh hưởng bởi quá trình xét hạng thành viên.'),
                      _buildBulletPoint('Những ưu đãi bạn nhận được thông qua chương trình Thành viên Phê La được dựa trên số điểm tích lũy;'),
                      _buildBulletPoint('Tất cả các danh mục sản phẩm tại cửa hàng Phê La đều được tính vào điểm tích lũy khi có phát sinh thanh toán trực tiếp tại cửa hàng;'),
                      _buildBulletPoint('Không áp dụng tích điểm khi khách hàng đặt hàng qua fanpage, hotline và các ứng dụng giao hàng hoặc bên thứ 3;'),
                      _buildBulletPoint('Xuất trình mã thanh toán trong ứng dụng trước khi thực hiện giao dịch tại cửa hàng để được tích lũy điểm. Phê La sẽ không hỗ trợ giảm giá và tích điểm khi khách hàng không xuất trình mã;'),
                      _buildBulletPoint('Tất cả sản phẩm đồ uống tặng hoặc quà tặng chỉ áp dụng tại cửa hàng, không áp dụng qua hình thức hotline hoặc trên fanpage.'),
                      
                      const SizedBox(height: 24),
                      // Dòng link "Xem thêm Hạng thành viên"
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                          children: [
                            TextSpan(text: 'Xem thêm '),
                            TextSpan(
                              text: 'Hạng thành viên', 
                              style: TextStyle(color: Color(0xFFB57D52), decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hỗ trợ vẽ từng dòng có dấu chấm tròn (Bullet Point)
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

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
          
          // ---------------- MÃ QR CÓ LOGO ----------------
          SizedBox(
            width: 260, 
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: "99343",
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.H, 
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                  size: 260, 
                  padding: EdgeInsets.zero,
                ),
                
                // Vẽ Logo ở giữa mã QR
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB5A475), 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Center(
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
          
          // ---------------- NÚT MÃ SỐ CÓ CHỨC NĂNG COPY ----------------
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _copyToClipboard(context), 
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8D8), 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "99343", // Đổi mã thành 99343 giống hình bạn gửi ở lần trước
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB57D52), 
                  ),
                ),
              ),
            ),
          ),
          // --------------------------------------------------------------
          
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
          
          // ---------------- SỐ NỐT NHẠC TÍCH LŨY & ICON INFO ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Số nốt nhạc tích lũy",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 6),
              // Gắn sự kiện khi bấm vào nút 'i' màu nâu
              GestureDetector(
                onTap: () => _showPolicySheet(context),
                child: Icon(Icons.info, size: 20, color: const Color(0xFFB57D52).withOpacity(0.8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "3",
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