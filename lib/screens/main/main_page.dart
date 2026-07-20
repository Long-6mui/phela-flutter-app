import 'dart:async';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    Center(child: Text('Đặt hàng')),
    Center(child: Text('Ưu đãi')),
    Center(child: Text('Khác')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F2E2C),
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(
          Icons.qr_code_2,
          color: Color(0xFFD4A36A),
          size: 34,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 12,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 74,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.storefront, 'Trang chủ', 0),
                _buildNavItem(Icons.shopping_bag_outlined, 'Đặt hàng', 1),
                const SizedBox(width: 48),
                _buildNavItem(Icons.confirmation_num_outlined, 'Ưu đãi', 2),
                _buildNavItem(Icons.grid_view_rounded, 'Khác', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFC08A55) : Colors.black87,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFC08A55) : Colors.black87,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E5C9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 105),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Header(),
              _BannerSlider(),
              _DeliveryBox(),
              _SectionTitle(title: 'Món bán chạy 🔥', showMore: false),
              _ProductList(),
              _SectionTitle(title: 'Dành cho bạn', showMore: false),
              _SmallProductList(),
              _SectionTitle(title: 'Món ngon phải thử ✨', showMore: false),
              _HorizontalProductList(),
              _SectionTitle(title: 'Sự kiện', showMore: true),
              _NewsList(),
              _SectionTitle(title: 'Tin tức', showMore: true),
              _NewsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Happy Chill Day 🌤️',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Lê Tấn Hoàng Long',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFC49A78),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _RoundIcon(
            icon: Icons.confirmation_num_outlined,
            text: '1',
          ),
          SizedBox(width: 12),
          _RoundIcon(
            icon: Icons.notifications_none,
            hasDot: true,
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final String? text;
  final bool hasDot;

  const _RoundIcon({
    required this.icon,
    this.text,
    this.hasDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFB88455), size: 24),
              if (text != null) ...[
                const SizedBox(width: 6),
                Text(
                  text!,
                  style: const TextStyle(
                    color: Color(0xFFB88455),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (hasDot)
          Positioned(
            top: 5,
            right: 7,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _BannerSlider extends StatefulWidget {
  const _BannerSlider();

  @override
  State<_BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<_BannerSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int currentPage = 0;

  final List<String> banners = const [
    'assets/images/banners/banner_phe_la.jpg',
    'assets/images/banners/banner_phe_la_2.jpg',
    'assets/images/banners/banner_phe_la3.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      int nextPage = currentPage + 1;

      if (nextPage >= banners.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      height: 190,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    banners[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) {
                final bool isActive = currentPage == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFB88455)
                        : const Color(0xFFD8C0A7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryBox extends StatelessWidget {
  const _DeliveryBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFF5E6D6),
            child: Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFFB88455),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Giao hàng tận nơi ›\n',
                    style: TextStyle(
                      color: Color(0xFFB88455),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: '41 Tản Đà, Phường 10, Quận 5, Hồ Chí Minh',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;

  const _SectionTitle({
    required this.title,
    required this.showMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          if (showMore)
            const Text(
              'Xem thêm →',
              style: TextStyle(
                color: Color(0xFFB88455),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 248,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _ProductCard(
            name: 'Phan Xi Păng Phê Phin Đặc Sản',
            price: '75,000',
            badge: 'MỚI',
            color1: Color(0xFF9EDDF5),
            color2: Color(0xFFD8943C),
          ),
          _ProductCard(
            name: 'COMBO CHILL 01',
            price: '79,000',
            badge: 'COMBO',
            color1: Color(0xFF315238),
            color2: Color(0xFFE8C08D),
          ),
          _ProductCard(
            name: 'Ô Long Nhài Sữa',
            price: '69,000',
            badge: 'SIZE L',
            color1: Color(0xFFDED3BF),
            color2: Color(0xFFF7F0E5),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String badge;
  final Color color1;
  final Color color2;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.badge,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.local_cafe,
                    size: 72,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE96732),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                height: 1.2,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFB88455),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFF3E2D1),
                  child: Icon(
                    Icons.add,
                    color: Color(0xFFB88455),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallProductList extends StatelessWidget {
  const _SmallProductList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _SmallProductCard(
            name: 'Ô Long Nhài Sữa - trà sữa',
            price: '69,000',
          ),
          _SmallProductCard(
            name: 'Matcha Latte Đặc Sản',
            price: '65,000',
          ),
        ],
      ),
    );
  }
}

class _SmallProductCard extends StatelessWidget {
  final String name;
  final String price;

  const _SmallProductCard({
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 178,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 96,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE8D8BF),
                  Color(0xFFEEECE3),
                ],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.local_drink,
                size: 58,
                color: Color(0xFFC08A55),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                height: 1.2,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFB88455),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFF3E2D1),
                  child: Icon(
                    Icons.add,
                    color: Color(0xFFB88455),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  const _HorizontalProductList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _HorizontalProductCard(title: 'Combo Chill Đổi Phê Truffle'),
          _HorizontalProductCard(title: 'Trà Xanh Đà Lạt'),
        ],
      ),
    );
  }
}

class _HorizontalProductCard extends StatelessWidget {
  final String title;

  const _HorizontalProductCard({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8C5942),
                  Color(0xFFE4B782),
                ],
              ),
            ),
            child: const Icon(
              Icons.coffee,
              color: Colors.white,
              size: 48,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Color(0xFFF3E2D1),
              child: Icon(
                Icons.add,
                color: Color(0xFFB88455),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 246,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: const [
          _NewsCard(
            title: '01/07 này, Phê La tiếp tục đón chốn chill thứ 5 tại Đà Nẵng 🎈',
            color1: Color(0xFFDAD2B6),
            color2: Color(0xFF8DBB75),
          ),
          _NewsCard(
            title: 'PHAN XI PĂNG PHÊ PHIN ĐẶC SẢN 🎶🐐',
            color1: Color(0xFF9EDDF5),
            color2: Color(0xFFD8943C),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;

  const _NewsCard({
    required this.title,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 285,
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [color1, color2],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.storefront,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}