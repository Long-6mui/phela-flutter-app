import 'dart:async';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ExploreAppPage extends StatefulWidget {
  const ExploreAppPage({super.key});

  @override
  State<ExploreAppPage> createState() => _ExploreAppPageState();
}

class _ExploreAppPageState extends State<ExploreAppPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Đặt món nhanh chóng',
      'description':
          'Đặt Phê La mọi lúc – Chill Phê La mọi nơi.\nGiao diện thân thiện, thao tác đơn giản, dễ dùng với mọi Đồng Chill.',
      'imagePath': 'assets/images/backgrounds/test 1.jpg', // <-- THÊM LINK ẢNH VÀO ĐÂY
    },
    {
      'title': 'Thanh toán dễ dàng',
      'description':
          'Đa dạng hình thức thanh toán, tiện lợi và linh hoạt từ Ví điện tử, Ngân hàng, mã QR,...',
      'imagePath': 'assets/images/backgrounds/test 2.jpg', // <-- THÊM LINK ẢNH VÀO ĐÂY
    },
    {
      'title': 'Ưu đãi độc quyền',
      'description':
          'Phê La chill đãi Đồng Chill hàng loạt E-voucher độc quyền & cập nhật sớm nhất về thông tin sản phẩm mới.',
      'imagePath': 'assets/images/backgrounds/test 3.jpg', // <-- THÊM LINK ẢNH VÀO ĐÂY
    },
    {
      'title': 'Đặt trước, ghé lấy ngay',
      'description':
          'Không cần xếp hàng chờ đợi. Chỉ cần lên đơn qua ứng dụng, ghé trạm Phê La gần nhất và nhận ngay ly nước yêu thích của bạn.',
      'imagePath': 'assets/images/backgrounds/test 4.jpg', // <-- THÊM LINK ẢNH VÀO ĐÂY
    },
  ];

  @override
  void initState() {
    super.initState();
    // Tự động chuyển trang sau mỗi 5 giây
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/backgrounds/coffee_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Khám phá ứng dụng',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 42),
                  ],
                ),
              ),

              // MAIN CONTENT
              Expanded(
                child: Stack(
                  children: [
                    // LỚP 1: PAGEVIEW (Cuộn ảnh và chữ)
                    PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // KHUNG ẢNH
                              Container(
                                height: 320,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: _pages[index]['imagePath']!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.asset(
                                          _pages[index]['imagePath']!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 64,
                                          color: Colors.black26,
                                        ),
                                      ),
                              ),

                              // KHOẢNG TRỐNG GIÀNH RIÊNG CHO INDICATOR (Nằm ở lớp thứ 2)
                              // Khoảng trống = Khoảng cách trên(32) + Độ dày nút(6) + Khoảng cách dưới(32) = 70
                              const SizedBox(height: 70),

                              // TIÊU ĐỀ VÀ MÔ TẢ (Khóa chiều cao để ảnh không bị nảy lên xuống)
                              SizedBox(
                                height: 160,
                                child: Column(
                                  children: [
                                    Text(
                                      _pages[index]['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _pages[index]['description']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // LỚP 2: INDICATOR ĐỨNG YÊN (Nằm đè lên trên)
                    IgnorePointer( // Không cản trở thao tác vuốt của người dùng
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 350), // Bằng đúng chiều cao ảnh
                            const SizedBox(height: 32), // Khoảng cách từ ảnh tới Indicator
                            
                            // DẢI NÚT CHUYỂN TRANG
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _pages.length,
                                (buildIndex) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 6,
                                  width: _currentPage == buildIndex ? 24 : 12,
                                  decoration: BoxDecoration(
                                    color: _currentPage == buildIndex
                                        ? const Color(0xFF5A3825) // Màu nâu đậm nổi bật khi kích hoạt
                                        : Colors.white, // Màu trắng sáng không chìm vào nền
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32), // Khoảng cách từ Indicator tới chữ
                            const SizedBox(height: 160), // Bằng đúng chiều cao khung chữ
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}