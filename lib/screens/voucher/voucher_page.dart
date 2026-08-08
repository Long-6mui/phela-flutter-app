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
                Center(          
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 60, color: Color(0xFFC49A70)),
                      SizedBox(height: 16),
                      Text(
                        'Không có dữ liệu',
                        style: TextStyle(fontSize: 16, color: Color(0xFFC49A70)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherTabView extends StatefulWidget {
  const VoucherTabView({super.key});

  @override
  State<VoucherTabView> createState() => _VoucherTabViewState();
}

class _VoucherTabViewState extends State<VoucherTabView> {
  bool isOfferSelected = true; 

  // 1. Bảng chi tiết Ưu đãi Giao hàng
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

  // 2. Bảng nhập số điểm khi bấm nút "ĐỔI VOUCHER"
  void _showExchangePointsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
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
                    const Text('Đổi nốt nhạc', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                    IconButton(icon: const Icon(Icons.close, color: Colors.grey, size: 28), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),
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
                  decoration: InputDecoration(
                    hintText: 'Nhập số điểm muốn đổi...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD8C0A7))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD8C0A7))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFB57D52))),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                const Text('1 nốt nhạc = Voucher 1.000 VNĐ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFB57D52))),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB57D52),
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

  // 3. Bảng chi tiết khi bấm vào thẻ Voucher nâu
  void _showTicketDetailSheet(BuildContext context, String value) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
                              Text(".000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                              SizedBox(height: 2),
                              Text("VNĐ", style: TextStyle(fontSize: 14, color: Colors.white, height: 1.0)),
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
                      onPressed: () {},
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

  // ---------- GIAO DIỆN: ƯU ĐÃI ----------
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
              onPressed: () {},
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

        // Thẻ Ưu đãi (Có răng cưa nét đứt)
        _OfferTicketCard(
          onTap: () => _showOfferDetailsSheet(context),
        ),
      ],
    );
  }

  // ---------- GIAO DIỆN: ĐỔI NỐT NHẠC ----------
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

// ================= CÁC WIDGET THẺ VÉ (TICKET CARDS) =================

// 1. Thẻ Ưu đãi Giao hàng (Màu Be nhạt)
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
              // Kỹ thuật đục lỗ tạo nét đứt (Chèn hình tròn giả lập màu nền app đè lên ranh giới)
              Positioned(
                left: 102, // Đặt đè ngay tại điểm giao nhau giữa 2 phần
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
                              color: Color(0xFFE8DDCB), // Màu mô phỏng nền ứng dụng
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

// 2. Thẻ Đổi Nốt Nhạc (Màu Nâu)
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
                      color: Color(0xFFC08955), // Màu nâu chuẩn xác y hình image_9ece1b.png
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(right: -10, top: -10, child: Icon(Icons.eco, size: 80, color: Colors.white.withOpacity(0.06))),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, // CANH GIỮA HOÀN HẢO
                            children: [
                              Text(value, style: const TextStyle(fontSize: 46, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                              const SizedBox(width: 2),
                              const Column(
                                mainAxisSize: MainAxisSize.min, // ĐIỂM QUAN TRỌNG ĐỂ CANH GIỮA
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
              // Kỹ thuật đục lỗ tạo nét đứt (Chèn hình tròn giả lập màu nền app đè lên ranh giới)
              Positioned(
                left: 116, // Đặt đè ngay tại điểm giao nhau giữa 2 phần (120 - 4 = 116)
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
                              color: Color(0xFFE8DDCB), // Màu mô phỏng nền ứng dụng
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