import 'package:flutter/material.dart';

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ưu đãi của bạn',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xFFB57D52),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFB57D52),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Khả dụng'),
              Tab(text: 'Không khả dụng'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgrounds/coffee_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.18)),
            ),
            const TabBarView(
              children: [
                VoucherTabView(),       
                _UnavailableTabView(),  
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// TAB 1: KHẢ DỤNG (ƯU ĐÃI & ĐỔI NỐT NHẠC)
// =========================================================================
class VoucherTabView extends StatefulWidget {
  const VoucherTabView({super.key});

  @override
  State<VoucherTabView> createState() => _VoucherTabViewState();
}

class _VoucherTabViewState extends State<VoucherTabView> {
  bool isOfferSelected = true; 
  bool _isVoucherAdded = false; 

  // Hàm hiển thị thanh thông báo lỗi màu đỏ ở sát mép trên màn hình
  void _showErrorBanner(BuildContext context) {
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
        top: MediaQuery.of(context).padding.top, // Hiện ngay dưới thanh pin/wifi
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFD32F2F), // Màu đỏ lỗi chuẩn Material
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Không đủ điểm để đổi.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: removeOverlay,
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Tự động tắt sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      removeOverlay();
    });
  }

  void _showApplyVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Xác nhận nhập ưu đãi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sau khi xác nhận, voucher sẽ được tạo và lưu vào Ưu Đãi của bạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F1C1A), 
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('HUỶ BỎ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isVoucherAdded = true;
                          });
                          Navigator.pop(context); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB57D52),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('XÁC NHẬN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String value) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Đổi nốt nhạc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 12),
                Text(
                  'Đồng Chill có chắc chắn muốn đổi $value nốt nhạc để nhận ưu đãi trị giá $value,000đ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F1C1A), 
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('HUỶ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Chỉ đóng cái Dialog hỏi xác nhận
                          Navigator.pop(context); 
                          // Và hiện cái thông báo lỗi màu đỏ (Vì giả lập hiện tại là không đủ điểm)
                          _showErrorBanner(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB57D52),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('XÁC NHẬN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOfferDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chi tiết ưu đãi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Ưu đãi giao hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
              const SizedBox(height: 24),
              const Text('Mô tả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text(
                '• Áp dụng cho phương thức Giao Tận Nơi tại toàn bộ cửa hàng Phê La hiển thị trên ứng dụng\n'
                '• Ưu đãi 16,000 VNĐ cho phí giao hàng, áp dụng cho phương thức Giao Tận Nơi với tổng hóa đơn sản phẩm sau khi giảm trừ các ưu đãi khác từ 150,000 VNĐ trở lên',
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductOfferDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9), 
          padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chi tiết ưu đãi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text('Chill đãi từ Phê La - Specialty Tea & Coffee', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                      const SizedBox(height: 24),
                      const Text('Thời hạn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 4),
                      const Text('22/08/2026', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFB57D52))),
                      const SizedBox(height: 20),
                      const Text('Mô tả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      const Text(
                        'Tặng 01 Thức Uống Đặc Sản (thuộc nhóm Trà Sữa/ Cà Phê), tối đa 54,000VNĐ.\n\n'
                        'Tiếp nối câu chuyện Ô Long Đặc Sản, Phê La từng bước mở rộng và lan tỏa trải nghiệm Cà Phê Đặc Sản cùng hành trình Đặc Sản mới: Phê La - Specialty Tea & Coffee. Nhân dịp này, Phê La gửi tặng món quà nhỏ, mời bạn cùng chung vui.\n\n'
                        'Lưu ý:\n'
                        '- Áp dụng cho đơn hàng có giá trị thanh toán từ 120K (không bao gồm giá trị món tặng). Đồng Chill vui lòng chọn món tặng trong đơn hàng để áp dụng mã ưu đãi.\n'
                        '- Áp dụng khi đặt hàng qua Ứng dụng Phê La trên toàn hệ thống (trừ Phê La Hòn Thơm và Phê La Phan Xi Păng).\n\n'
                        'Mời Đồng Chill cùng Phê La khám phá hành trình Specialty Tea & Coffee mới nha 🎶',
                        style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                      const SizedBox(height: 40),
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

  void _showExchangePointsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Đổi nốt nhạc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Số nốt nhạc tích lũy', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    Row(
                      children: const [
                        Text('3', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                        SizedBox(width: 4),
                        Icon(Icons.music_note, color: Color(0xFFB57D52), size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true, 
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Nhập số điểm muốn đổi...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD8C0A7))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD8C0A7))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFB57D52))),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('1 nốt nhạc = Voucher 1.000 VNĐ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB57D52))),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC08955), 
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('ĐỒNG Ý', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTicketDetailSheet(BuildContext context, String value) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Đổi nốt nhạc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                        IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(color: const Color(0xFFC08955), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(value, style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                          const SizedBox(width: 4),
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(".000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                              SizedBox(height: 2),
                              Text("VNĐ", style: TextStyle(fontSize: 11, color: Colors.white, height: 1.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Đổi voucher $value.000đ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                    const SizedBox(height: 16),
                    const Text('Thời hạn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text('7 ngày tính từ ngày đổi Voucher', style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                    const SizedBox(height: 16),
                    const Text('Mô tả', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(
                      '• Giảm $value,000 VNĐ trên tổng giá trị hóa đơn\n'
                      '• Áp dụng khi trực tiếp mua hàng tại tất cả các cửa hàng trên hệ thống Phê La\n'
                      '• Áp dụng cho toàn bộ sản phẩm tại Phê La\n'
                      '• Không áp dụng cho các chương trình khuyến mãi song song\n'
                      '• Vui lòng xuất trình mã voucher cho thu ngân trước khi thanh toán.',
                      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8D8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Số nốt nhạc cần đổi', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        Row(
                          children: [
                            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                            const SizedBox(width: 4),
                            const Icon(Icons.music_note, color: Color(0xFFB57D52), size: 18),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showConfirmationDialog(context, value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB57D52),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('ĐỔI ƯU ĐÃI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOfferSelected ? const Color(0xFFB57D52) : Colors.white,
                    foregroundColor: isOfferSelected ? Colors.white : Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isOfferSelected ? Colors.transparent : Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => setState(() => isOfferSelected = true),
                  child: const Text('Ưu đãi', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isOfferSelected ? const Color(0xFFB57D52) : Colors.white,
                    foregroundColor: !isOfferSelected ? Colors.white : Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: !isOfferSelected ? Colors.transparent : Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => setState(() => isOfferSelected = false),
                  child: const Text('Đổi nốt nhạc', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isOfferSelected ? _buildOfferSection() : _buildExchangeSection(),
        )
      ],
    );
  }

  Widget _buildOfferSection() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập mã ưu đãi...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showApplyVoucherDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC49A70),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 0,
              ),
              child: const Text('ĐỔI MÃ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        const SizedBox(height: 24),
        const Text('Ưu đãi giao hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 12),

        _OfferTicketCard(
          onTap: () => _showOfferDetailsSheet(context),
        ),

        if (_isVoucherAdded) ...[
          const SizedBox(height: 12),
          const Text('Ưu đãi sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 12),
          _ProductOfferTicketCard(onTap: () => _showProductOfferDetailsSheet(context)), 
        ],
      ],
    );
  }

  Widget _buildExchangeSection() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE2C9A4).withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Số nốt nhạc khả dụng', style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Text('3', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                      SizedBox(width: 4),
                      Icon(Icons.music_note, color: Color(0xFFB57D52), size: 20),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showExchangePointsSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB57D52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 0,
                ),
                child: const Text('ĐỔI VOUCHER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        _TicketVoucherCard(
          title: 'Đổi voucher 45.000đ',
          value: '45',
          points: '45 nốt nhạc',
          onTap: () => _showTicketDetailSheet(context, '45'),
        ),
        _TicketVoucherCard(
          title: 'Đổi voucher 55.000đ',
          value: '55',
          points: '55 nốt nhạc',
          onTap: () => _showTicketDetailSheet(context, '55'),
        ),
        _TicketVoucherCard(
          title: 'Đổi voucher 10.000đ',
          value: '10',
          points: '10 nốt nhạc',
          onTap: () => _showTicketDetailSheet(context, '10'),
        ),
      ],
    );
  }
}

// =========================================================================
// TAB 2: KHÔNG KHẢ DỤNG
// =========================================================================
class _UnavailableTabView extends StatelessWidget {
  const _UnavailableTabView();

  void _showBirthdayDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Chi tiết ưu đãi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Chương trình tặng bánh sinh nhật', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
              const SizedBox(height: 24),
              const Text('Thời hạn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              const Text('10/09/2025', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFB57D52))),
              const SizedBox(height: 20),
              const Text('Mô tả', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text(
                'Happy Chill Birthday! Mừng Đồng Chill Huỳnh Quốc Anh thêm tuổi mới, Phê La dành tặng bạn 01 phần Bánh Ngọt bất kỳ, mã E-Voucher L8YPL8WX, được sử dụng từ 26/08/2025 đến 10/09/2025. Bạn vui lòng đưa mã E-Voucher cho thu ngân chúng mình trước khi gọi món, để liên hoan tiệc sinh nhật cùng Phê La. Thổi nến, cắt bánh, cùng Phê La đón tuổi mới thật chill nha!',
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const BouncingScrollPhysics(),
      children: [
        _BirthdayTicketCard(
          onTap: () => _showBirthdayDetailsSheet(context),
        ),
      ],
    );
  }
}

// ================= CÁC WIDGET THẺ VÉ (TICKET CARDS) =================

class _ProductOfferTicketCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ProductOfferTicketCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 135, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 106,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8D5C4), 
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(Icons.style_outlined, size: 48, color: Color(0xFFB57D52)), 
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chill đãi từ Phê La - Specialty Tea & Coffee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            'Tặng 01 Thức Uống Đặc Sản (thuộc nhóm Trà Sữa/ Cà Phê), tối đa 54,000VNĐ.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          const Text('HSD: 22/08/2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9BA674))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 102, 
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 8,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxHeight = constraints.constrainHeight();
                      const dashHeight = 8.0;
                      final dashCount = (boxHeight / (1.5 * dashHeight)).floor();
                      return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8DDCB), 
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirthdayTicketCard extends StatelessWidget {
  final VoidCallback onTap;

  const _BirthdayTicketCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 106,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8D5C4), 
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(Icons.discount_outlined, size: 48, color: Color(0xFFB57D52)), 
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chương trình tặng bánh sinh nhật', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            'Happy Chill Birthday! Mừng Đồng Chill Huỳnh Quốc Anh thêm tuổi mới, Phê La...',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          const Text('HSD: 10/09/2025', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9BA674))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 102, 
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 8,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxHeight = constraints.constrainHeight();
                      const dashHeight = 8.0;
                      final dashCount = (boxHeight / (1.5 * dashHeight)).floor();
                      return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8DDCB), 
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferTicketCard extends StatelessWidget {
  final VoidCallback onTap;

  const _OfferTicketCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 106,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8D5C4), 
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(Icons.delivery_dining, size: 48, color: Color(0xFFB57D52)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ưu đãi giao hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(
                            '• Áp dụng cho phương thức Giao Tận Nơi tại toàn bộ cửa hàng...',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 102, 
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 8,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxHeight = constraints.constrainHeight();
                      const dashHeight = 8.0;
                      final dashCount = (boxHeight / (1.5 * dashHeight)).floor();
                      return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8DDCB), 
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketVoucherCard extends StatelessWidget {
  final String title;
  final String value;
  final String points;
  final VoidCallback onTap;

  const _TicketVoucherCard({
    required this.title,
    required this.value,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC08955), 
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(right: -10, top: -10, child: Icon(Icons.eco, size: 80, color: Colors.white.withOpacity(0.06))),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(value, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                              const SizedBox(width: 2),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(".000", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                                  SizedBox(height: 2),
                                  Text("VNĐ", style: TextStyle(fontSize: 11, color: Colors.white, height: 1.0)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                          Text(points, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF9BA674))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 116, 
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 8,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxHeight = constraints.constrainHeight();
                      const dashHeight = 8.0;
                      final dashCount = (boxHeight / (1.5 * dashHeight)).floor();
                      return Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8DDCB), 
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}