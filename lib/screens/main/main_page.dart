import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTabView(),
    const Center(child: Text("Màn hình Đặt Hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    const Center(child: Text("Màn hình Ưu Đãi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: AppColors.textGrey,
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.local_cafe_outlined), label: "Đặt hàng"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_outlined), label: "Ưu đãi"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Tài khoản"),
        ],
      ),
    );
  }
}

// Sub-widget hiển thị Trang Chủ
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,
      appBar: AppBar(
        backgroundColor: AppColors.brown,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.orange, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("GIAO ĐẾN", style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold)),
                  Text("125 Trần Hưng Đạo, Q.1, TP.HCM", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.orange.withOpacity(0.3), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.orange)),
              child: const Row(
                children: [
                  Icon(Icons.star, color: AppColors.orange, size: 14),
                  SizedBox(width: 4),
                  Text("120 P", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.brown, AppColors.orange]),
                borderRadius: BorderRadius.circular(20),
              ),
              // ĐÃ XÓA TỪ KHÓA 'const' Ở COLUMN DƯỚI ĐÂY:
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: const Text("MÓN MỚI RA MẮT", style: TextStyle(color: AppColors.brown, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  const Text("Ô LONG NHIỆT ĐỚI", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Đậm vị Ô Long, thơm nồng hương trái cây tự nhiên.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip("Tất Cả", true),
                  _buildChip("Trà Ô Long Đặc Sản", false),
                  _buildChip("Syphon / Moka Pot", false),
                  _buildChip("Cà Phê", false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Hương Vị Được Yêu Thích", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.brown)),
            const SizedBox(height: 12),
            // Product List
            _buildProductItem(context, "Phan Xi Păng", "Trà Ô Long đặc sản, kem sữa béo ngậy", "55.000đ", Icons.emoji_food_beverage),
            _buildProductItem(context, "Khói BLAO", "Ô Long rang đậm đà hương khói", "50.000đ", Icons.coffee),
            _buildProductItem(context, "Gấm (Ô Long Nhài)", "Sự kết hợp tinh tế giữa Ô Long và hoa nhài", "50.000đ", Icons.local_drink),
            _buildProductItem(context, "Cà Phê Trứng Hà Nội", "Vị cà phê đậm đà cùng lớp kem trứng thơm béo", "45.000đ", Icons.takeout_dining),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.brown : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.brown : Colors.black12),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _buildProductItem(BuildContext context, String name, String desc, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: AppColors.lightBeige, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.brown, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.brown)),
                Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange, fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: AppColors.brown, foregroundColor: Colors.white),
            icon: const Icon(Icons.add, size: 20),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm $name vào giỏ hàng!"))),
          ),
        ],
      ),
    );
  }
}