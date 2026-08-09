import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../routes/app_routes.dart';
import '../../models/address.dart';
import '../../services/user_profile_service.dart';
import '../profile/profile_page.dart';
import '../profile/saved_addresses_page.dart';
import 'notification_page.dart';
import 'order_page.dart';
import '../order/order_confirmation_page.dart';
import '../voucher/voucher_page.dart'; // <-- Import màn hình Voucher
import '../qr/qr_page.dart'; // <-- Import màn hình QR

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  // Đã gỡ từ khóa const ở List và thay thế trang Ưu đãi
  final List<Widget> pages = [
    const HomePage(),
    const OrderPage(onOpenProduct: _openOrderProduct),
    const VoucherPage(), // <-- Màn hình Ưu đãi đã được tích hợp
    const ProfilePage(),
    QRPage(),
  ];

  void _openOrderConfirmation([CartState? selectedCart]) {
    final cart = selectedCart ?? CartController.cartNotifier.value;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(
          items: cart.items
              .map(
                (line) => OrderConfirmationItem(
                  name: line.item.name,
                  imagePath: line.item.imagePath,
                  unitPrice: _parsePrice(line.item.price),
                  quantity: line.quantity,
                  option: line.option,
                ),
              )
              .toList(growable: false),
          subtotal: cart.totalPrice,
          onConfirmed: CartController.clearCart,
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _CartSheet(
        onOrderPressed: () {
          final cart = CartController.cartNotifier.value;
          Navigator.pop(sheetContext);
          _openOrderConfirmation(cart);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Thay thế pages[currentIndex] bằng khối này để không bị đơ app:
          IndexedStack(index: currentIndex, children: pages),

          // Thêm điều kiện && currentIndex != 4
          if (currentIndex != 3 && currentIndex != 4)
            Positioned(
              left: 0,
              right: 0,
              // Kéo nền giỏ hàng xuống sau BottomAppBar để lấp kín vùng
              // quanh nút QR, đồng thời tăng chiều cao để mép trên cao hơn.
              bottom: 68,
              child: _CartOrderBar(
                onCartPressed: _showCart,
                onOrderPressed: _openOrderConfirmation,
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F2E2C),
        shape: const CircleBorder(),
        onPressed: () {
          // Xóa Navigator.push và thay bằng setState
          setState(() {
            currentIndex = 4;
          });
        },
        child: const Icon(
          Icons.qr_code_2,
          color: Color.fromARGB(255, 180, 146, 106),
          size: 34,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
      PointerDeviceKind.stylus,
    };
  }
}

class _AppBackground extends StatelessWidget {
  final Widget child;

  const _AppBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        child,
      ],
    );
  }
}

class CartState {
  final int totalQuantity;
  final int totalPrice;
  final List<CartLine> items;

  const CartState({
    required this.totalQuantity,
    required this.totalPrice,
    this.items = const [],
  });

  CartState copyWith({
    int? totalQuantity,
    int? totalPrice,
    List<CartLine>? items,
  }) {
    return CartState(
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
      items: items ?? this.items,
    );
  }
}

class CartLine {
  final DrinkItem item;
  final int quantity;
  final String option;

  const CartLine({
    required this.item,
    required this.quantity,
    required this.option,
  });
}

class CartController {
  static final ValueNotifier<CartState> cartNotifier = ValueNotifier(
    const CartState(totalQuantity: 0, totalPrice: 0),
  );

  static void addItem(DrinkItem item, int quantity, {String option = ''}) {
    final current = cartNotifier.value;
    final itemPrice = _parsePrice(item.price);
    final updatedItems = List<CartLine>.from(current.items);
    final existingIndex = updatedItems.indexWhere(
      (line) => line.item.name == item.name && line.option == option,
    );

    if (existingIndex >= 0) {
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = CartLine(
        item: item,
        quantity: existing.quantity + quantity,
        option: option,
      );
    } else {
      updatedItems.add(
        CartLine(item: item, quantity: quantity, option: option),
      );
    }

    cartNotifier.value = current.copyWith(
      totalQuantity: current.totalQuantity + quantity,
      totalPrice: current.totalPrice + itemPrice * quantity,
      items: List.unmodifiable(updatedItems),
    );
  }

  static void clearCart() {
    cartNotifier.value = const CartState(totalQuantity: 0, totalPrice: 0);
  }

  static void changeQuantity(int index, int change) {
    final current = cartNotifier.value;
    if (index < 0 || index >= current.items.length || change == 0) return;

    final updatedItems = List<CartLine>.from(current.items);
    final line = updatedItems[index];
    final newQuantity = line.quantity + change;
    final itemPrice = _parsePrice(line.item.price);

    if (newQuantity <= 0) {
      updatedItems.removeAt(index);
    } else {
      updatedItems[index] = CartLine(
        item: line.item,
        quantity: newQuantity,
        option: line.option,
      );
    }

    cartNotifier.value = CartState(
      totalQuantity: current.totalQuantity + change,
      totalPrice: current.totalPrice + itemPrice * change,
      items: List.unmodifiable(updatedItems),
    );
  }
}

class DrinkItem {
  final String name;
  final String price;
  final String badge;
  final String imagePath;
  final String description;

  const DrinkItem({
    required this.name,
    required this.price,
    required this.badge,
    required this.imagePath,
    this.description =
        'Trà Ô Long Đặc Sản đậm đà cùng hương vị hài hòa, thơm nhẹ và dễ uống.',
  });
}

class InfoCardData {
  final String title;
  final String imagePath;
  final String content;

  const InfoCardData({
    required this.title,
    required this.imagePath,
    required this.content,
  });
}

const List<DrinkItem> bestSellerItems = [
  DrinkItem(
    name: 'Phan Xi Păng Phê Phin Đặc Sản',
    price: '75,000',
    badge: 'MỚI',
    imagePath:
        'assets/images/coffees/Phan-Xi-Pang-Phe-Phin-Dac-San-da-xay-scaled.jpg',
    description:
        'Cà phê phin đặc sản kết hợp vị béo nhẹ, thơm đậm và hậu vị dễ chịu.',
  ),
  DrinkItem(
    name: 'Phan Xi Păng Long Nhãn Đá Xay',
    price: '79,000',
    badge: 'HOT',
    imagePath: 'assets/images/coffees/Phan-Xi-Pang-Long-Nhan-da-xay-scaled.jpg',
    description:
        'Đá xay mát lạnh cùng long nhãn thơm ngọt, phù hợp cho ngày cần giải nhiệt.',
  ),
  DrinkItem(
    name: 'Phê Ame Hạt Colom Ethiopia',
    price: '65,000',
    badge: 'BEST',
    imagePath: 'assets/images/coffees/Phe-Ame-hat-Colom-Ethi-scaled.jpg',
    description:
        'Hương cà phê tinh tế, hậu vị rõ và phù hợp với người thích vị đậm vừa.',
  ),
  DrinkItem(
    name: 'Phê Đen',
    price: '49,000',
    badge: 'CLASSIC',
    imagePath: 'assets/images/coffees/Phe-Den.jpg',
    description: 'Cà phê đen truyền thống, vị rõ, hậu đậm và dễ uống mỗi ngày.',
  ),
  DrinkItem(
    name: 'Phê Nâu',
    price: '55,000',
    badge: 'HOT',
    imagePath: 'assets/images/coffees/Phe-Nau.jpg',
    description: 'Cà phê sữa nâu thơm béo, cân bằng giữa vị cà phê và vị sữa.',
  ),
  DrinkItem(
    name: 'Phê Ô Long Bưởi Chanh Vàng',
    price: '69,000',
    badge: 'MỚI',
    imagePath:
        'assets/images/coffees/Phe-O-Long-Buoi-Chanh-vang-Moi-scaled.jpg',
    description:
        'Ô Long kết hợp bưởi và chanh vàng, vị thanh mát, chua nhẹ và thơm.',
  ),
  DrinkItem(
    name: 'Phê Xỉu Vani',
    price: '59,000',
    badge: 'NEW',
    imagePath: 'assets/images/coffees/Phe-Xiu-Vani.jpg',
    description:
        'Cà phê sữa nhẹ cùng hương vani ngọt dịu, dễ uống và thơm béo.',
  ),
  DrinkItem(
    name: 'Đà Lạt Phiên Bản Mới',
    price: '69,000',
    badge: 'MỚI',
    imagePath: 'assets/images/coffees/Da-Lat-phien-ban-moi-Moi-scaled.jpg',
    description:
        'Hương vị Đà Lạt mới mẻ, thanh nhẹ, thơm và phù hợp cho ngày chill.',
  ),
];

const List<DrinkItem> recommendItems = [
  DrinkItem(
    name: 'Phê Ame Hạt Colom Ethiopia',
    price: '65,000',
    badge: 'BEST',
    imagePath: 'assets/images/coffees/Phe-Ame-hat-Colom-Ethi-scaled.jpg',
  ),
  DrinkItem(
    name: 'Phê Đen',
    price: '49,000',
    badge: 'CLASSIC',
    imagePath: 'assets/images/coffees/Phe-Den.jpg',
  ),
  DrinkItem(
    name: 'Phê Xỉu Vani',
    price: '59,000',
    badge: 'NEW',
    imagePath: 'assets/images/coffees/Phe-Xiu-Vani.jpg',
  ),
];

const List<DrinkItem> mustTryItems = [
  DrinkItem(
    name: 'Matcha Latte',
    price: '65,000',
    badge: 'MATCHA',
    imagePath: 'assets/images/coffees/matcha_latte.jpg',
    description:
        'Matcha latte thơm nhẹ, béo vừa, hậu vị trà xanh rõ và dễ uống.',
  ),
  DrinkItem(
    name: 'Matcha Phan Xi Păng Đá Xay',
    price: '79,000',
    badge: 'MỚI',
    imagePath:
        'assets/images/coffees/Matcha-Phan-Xi-Pang-da-xay-MOI-scaled.jpg',
    description:
        'Matcha đá xay mát lạnh, vị trà xanh nổi bật cùng lớp kem béo nhẹ.',
  ),
  DrinkItem(
    name: 'Thạch Trà Chanh Vàng',
    price: '59,000',
    badge: 'HOT',
    imagePath: 'assets/images/coffees/Thach-Tra-Chanh-Vang-scaled.jpg',
    description:
        'Trà chanh vàng thanh mát kết hợp thạch giòn, phù hợp ngày nóng.',
  ),
  DrinkItem(
    name: 'Thạch Xỉu Vani',
    price: '59,000',
    badge: 'NEW',
    imagePath: 'assets/images/coffees/Thach-Xiu-Vani.jpg',
    description: 'Xỉu vani béo thơm kết hợp thạch mềm, vị ngọt dịu và dễ uống.',
  ),
];

const List<DrinkItem> orderItems = [
  ...bestSellerItems,
  ...mustTryItems,
  DrinkItem(
    name: 'Trà Vỏ Cà Phê',
    price: '59,000',
    badge: 'MỚI',
    imagePath: 'assets/images/news/8-Tra-Vo-Ca-Phe.jpg',
  ),
  DrinkItem(
    name: 'Gấm Phiên Bản Mới',
    price: '69,000',
    badge: 'NEW',
    imagePath: 'assets/images/news/Gam-phien-ban-moi-scaled.jpg',
  ),
  DrinkItem(
    name: 'Ô Long Đào Hồng',
    price: '69,000',
    badge: 'HOT',
    imagePath:
        'assets/images/news/Resize-AppFood-KV-OLongDaoHong-2-03-scaled.jpg',
  ),
  DrinkItem(
    name: 'Lúa Đào Đông Chill',
    price: '75,000',
    badge: 'SIZE L',
    imagePath:
        'assets/images/news/Ver-03-Lua-Dao-Phien-ban-Dong-Chill-yeu-thich-size-LAAA.jpg',
  ),
];

const List<InfoCardData> eventItems = [
  InfoCardData(
    title: 'Không gian chill mới cùng Phê La',
    imagePath: 'assets/images/events/event1.jpg',
    content:
        'Phê La mang đến một không gian chill mới dành cho những ngày cần thư giãn, gặp gỡ bạn bè và thưởng thức đồ uống đặc sản.\n\nGhé Phê La để tận hưởng không khí nhẹ nhàng, lưu lại những khoảnh khắc đẹp và chọn cho mình một ly nước yêu thích nhé.',
  ),
  InfoCardData(
    title: 'Ngày hội Phê La dành cho khách hàng',
    imagePath: 'assets/images/events/event2.jpg',
    content:
        'Ngày hội Phê La là dịp để khách hàng cùng trải nghiệm không gian mới, thưởng thức đồ uống đặc sản và tận hưởng nhiều hoạt động thú vị.\n\nHẹn bạn ghé Phê La để cùng chill, cùng trò chuyện và lưu giữ những khoảnh khắc đáng nhớ.',
  ),
  InfoCardData(
    title: 'Một hướng đặc sản trong mùa mới',
    imagePath: 'assets/images/events/event3.jpg',
    content:
        'Phê La tiếp tục kể câu chuyện về hương vị đặc sản qua những không gian và trải nghiệm mới.\n\nMỗi điểm đến là một cảm giác khác nhau, nhưng vẫn giữ tinh thần nguyên bản, thủ công và gần gũi.',
  ),
  InfoCardData(
    title: 'Trải nghiệm cà phê cùng Phê La',
    imagePath: 'assets/images/events/envent4.jpg',
    content:
        'Một trải nghiệm cà phê nhẹ nhàng, gần gũi và phù hợp cho những ngày bạn muốn tìm một nơi để dừng lại.\n\nPhê La hứa hẹn mang đến không gian thư thái cùng những lựa chọn đồ uống dễ uống, đậm vị và đáng thử.',
  ),
  InfoCardData(
    title: 'Ô Long và những lựa chọn theo mùa',
    imagePath: 'assets/images/events/event5.jpg',
    content:
        'Những lựa chọn theo mùa tại Phê La mang đến cảm giác tươi mới, thanh mát và dễ thưởng thức.\n\nĐặc biệt, các món Ô Long luôn giữ được hương thơm đặc trưng, phù hợp với nhiều khẩu vị.',
  ),
  InfoCardData(
    title: 'Phê La Đà Lạt trong bộ sưu tập mới',
    imagePath: 'assets/images/events/event8.jpg',
    content:
        'Bộ sưu tập mới lấy cảm hứng từ Đà Lạt mang đến cảm giác nhẹ nhàng, mát lành và đầy chất chill.\n\nĐây là lựa chọn phù hợp cho những ai yêu thích hương vị thanh, thơm và dễ uống.',
  ),
  InfoCardData(
    title: 'Chill cùng Phê La trong ngày cuối tuần',
    imagePath: 'assets/images/events/event9.jpg',
    content:
        'Cuối tuần là thời điểm lý tưởng để ghé Phê La, chọn một ly nước yêu thích và tận hưởng nhịp sống chậm lại.\n\nKhông gian ấm áp cùng hương vị đặc sản sẽ giúp bạn có một buổi chill trọn vẹn hơn.',
  ),
];

const List<InfoCardData> newsItems = [
  InfoCardData(
    title:
        'Phê La Đặng Tiến Đông trở lại, hẹn bạn “Nguệch Ngoạc Chill Chill” 🎶🎈',
    imagePath: 'assets/images/news/Dang_Tien_dong.jpg',
    content:
        'Phê La Đặng Tiến Đông chính thức trở lại với không gian mới mẻ, gần gũi và nhiều góc chill dành cho bạn.\n\nGhé Phê La để thưởng thức đồ uống yêu thích, gặp gỡ bạn bè và tận hưởng một ngày thật thư giãn nhé.\n\n📍 14 Đặng Tiến Đông, Phường Đống Đa, Hà Nội.',
  ),
  InfoCardData(
    title: 'Phê La xin chào Đông Chill Hai Bà Trưng',
    imagePath: 'assets/images/news/news1.jpg',
    content:
        'Phê La Hai Bà Trưng mang đến một không gian mới dành cho những ai yêu thích hương vị đặc sản và cảm giác chill nhẹ nhàng.\n\nĐây là điểm hẹn phù hợp để bạn ghé qua, gọi một ly nước yêu thích và tận hưởng nhịp sống thành phố.',
  ),
  InfoCardData(
    title: '01/07 này, Phê La tiếp tục đón chốn chill thứ 5 tại Đà Nẵng 🎈',
    imagePath: 'assets/images/news/Sự Kiện Aeon Mall Đà Nẵng.png',
    content:
        'Chính thức có mặt tại Aeon Mall đầu tiên tại Đà Nẵng, Phê La Aeon Mall Thanh Khê hứa hẹn sẽ là chốn chill thư thả giữa TTTM nhộn nhịp.\n\nĐừng bỏ lỡ cơ hội ghé thăm không gian mới, nhâm nhi Thức Uống Đặc Sản mát lạnh và lưu lại những khoảnh khắc cùng bạn bè tại Phê La nhé🎶\n\n📍 Tầng 1, TTTM Aeon Mall Thanh Khê, số 46 Điện Biên Phủ, Phường Thanh Khê, Thành phố Đà Nẵng, Việt Nam.',
  ),
  InfoCardData(
    title:
        '25/06 này, Phê La Nghệ An đón chốn chill thứ 02 tại Nguyễn Thị Minh Khai 🎶',
    imagePath: 'assets/images/news/Sự Kiện Nghệ An.png',
    content:
        'Phê La Nghệ An tiếp tục mở thêm một chốn chill mới dành cho những ai yêu thích không gian nhẹ nhàng và đồ uống đặc sản.\n\nHãy ghé Phê La để tận hưởng một ngày thư giãn, chọn món nước yêu thích và lưu lại những khoảnh khắc cùng bạn bè.\n\n📍 Nguyễn Thị Minh Khai, Phường Thành Vinh, Tỉnh Nghệ An.',
  ),
  InfoCardData(
    title:
        '28/06 này, có hẹn với đông chill tại Phê La thứ 04 tại Đà Nẵng nhé 🎶',
    imagePath: 'assets/images/news/Sự kiện Ngô Quyền Đà Nẵng.png',
    content:
        'Phê La tiếp tục mở rộng không gian chill tại Đà Nẵng với điểm đến mới dành cho những ngày cần thư giãn.\n\nHãy ghé Phê La để thưởng thức đồ uống đặc sản, tận hưởng không gian ấm áp và lưu lại những khoảnh khắc thật vui cùng bạn bè.',
  ),
  InfoCardData(
    title: 'Phê La xin chào Đông Chill Vincom Plaza 3/2 TP. Hồ Chí Minh 🎶',
    imagePath: 'assets/images/news/Vincom_plaza.jpg',
    content:
        'Phê La Vincom Plaza 3/2 mang đến không gian mới dành cho những tín đồ yêu thích đồ uống đặc sản.\n\nĐây là điểm hẹn phù hợp để gặp gỡ bạn bè, nghỉ chân sau giờ học hoặc làm việc và tận hưởng một ly nước thật chill.',
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6E5C9),
      body: _AppBackground(
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const _AppScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 105),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Header(),
                  _BannerSlider(),
                  _DeliveryBox(),
                  _WhiteSection(
                    title: 'Món bán chạy 🔥',
                    showMore: false,
                    child: _ProductList(),
                  ),
                  _SectionTitle(title: 'Dành cho bạn', showMore: false),
                  _SmallProductList(),
                  _SectionTitle(title: 'Món ngon phải thử ✨', showMore: false),
                  _HorizontalProductList(),
                  _WhiteContentBlock(
                    children: [
                      _SectionTitle(title: 'Sự kiện', showMore: true),
                      _EventList(),
                      SizedBox(height: 12),
                      _SectionTitle(title: 'Tin tức', showMore: true),
                      _DrinkNewsList(),
                    ],
                  ),
                ],
              ),
            ),
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
    return ValueListenableBuilder(
      valueListenable: UserProfileService.profileNotifier,
      builder: (context, profile, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Happy Chill Day 🌤️',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFFC49A78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const _RoundIcon(
                icon: Icons.confirmation_num_outlined,
                text: '1',
              ),
              const SizedBox(width: 12),
              _RoundIcon(
                icon: Icons.notifications_none,
                hasDot: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final String? text;
  final bool hasDot;
  final VoidCallback? onTap;

  const _RoundIcon({
    required this.icon,
    this.text,
    this.hasDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
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
              physics: const BouncingScrollPhysics(),
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
                    errorBuilder: (context, error, stackTrace) {
                      return const _ImageErrorBox();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
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
            }),
          ),
        ],
      ),
    );
  }
}

enum _OrderMethod { delivery, pickup }

class _DeliveryBox extends StatefulWidget {
  const _DeliveryBox();

  @override
  State<_DeliveryBox> createState() => _DeliveryBoxState();
}

class _DeliveryBoxState extends State<_DeliveryBox> {
  static const _fakeDeliveryAddress =
      '123 Đường Hương Trà, Phường Bình An, TP. Hồ Chí Minh';
  static const _fakePickupAddress = 'Phê La - 88 Đại lộ Mây Trắng';

  _OrderMethod _selectedMethod = _OrderMethod.delivery;
  String _selectedDeliveryAddress = _fakeDeliveryAddress;

  String get _title {
    return _selectedMethod == _OrderMethod.delivery
        ? 'Giao hàng tận nơi'
        : 'Đến lấy tại';
  }

  String get _address {
    return _selectedMethod == _OrderMethod.delivery
        ? _selectedDeliveryAddress
        : _fakePickupAddress;
  }

  IconData get _icon {
    return _selectedMethod == _OrderMethod.delivery
        ? Icons.local_shipping_outlined
        : Icons.local_mall_outlined;
  }

  Future<void> _showOrderMethodSheet() async {
    final selected = await showModalBottomSheet<_OrderMethod>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _OrderMethodSheet(
          selectedMethod: _selectedMethod,
          deliveryAddress: _selectedDeliveryAddress,
          onEditDelivery: () {
            Navigator.pop(sheetContext);
            _selectSavedAddress();
          },
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedMethod = selected;
      });
    }
  }

  Future<void> _selectSavedAddress() async {
    final selected = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (_) => const SavedAddressesPage(selectionMode: true),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedMethod = _OrderMethod.delivery;
        _selectedDeliveryAddress = selected.address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: _showOrderMethodSheet,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFF5E6D6),
                  child: Icon(_icon, color: const Color(0xFFB88455)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$_title ›\n',
                          style: const TextStyle(
                            color: Color(0xFFB88455),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: _address,
                          style: const TextStyle(
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
          ),
        ),
      ),
    );
  }
}

class _OrderMethodSheet extends StatelessWidget {
  final _OrderMethod selectedMethod;
  final String deliveryAddress;
  final VoidCallback onEditDelivery;

  const _OrderMethodSheet({
    required this.selectedMethod,
    required this.deliveryAddress,
    required this.onEditDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        22 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Phương thức đặt hàng',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Đóng',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF777777),
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _OrderMethodOption(
            title: 'Giao hàng tận nơi',
            address: deliveryAddress,
            icon: Icons.local_shipping_outlined,
            isSelected: selectedMethod == _OrderMethod.delivery,
            onTap: () => Navigator.pop(context, _OrderMethod.delivery),
            onEdit: onEditDelivery,
          ),
          const SizedBox(height: 10),
          _OrderMethodOption(
            title: 'Đến lấy tại',
            address: _DeliveryBoxState._fakePickupAddress,
            icon: Icons.local_mall_outlined,
            isSelected: selectedMethod == _OrderMethod.pickup,
            onTap: () => Navigator.pop(context, _OrderMethod.pickup),
            onEdit: () => Navigator.pushNamed(context, AppRoutes.store),
          ),
        ],
      ),
    );
  }
}

class _OrderMethodOption extends StatelessWidget {
  final String title;
  final String address;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _OrderMethodOption({
    required this.title,
    required this.address,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFFB88455) : Colors.black87;

    return Material(
      color: isSelected ? const Color(0xFFF1DFCC) : Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFF1DFCC)
                  : const Color(0xFFE5E5E5),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: isSelected
                    ? Colors.white70
                    : const Color(0xFFF7F7F7),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      address,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Chỉnh sửa',
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFFB88455),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;

  const _SectionTitle({required this.title, required this.showMore});

  void _openSeeMorePage(BuildContext context) {
    final bool isEventPage = title == 'Sự kiện';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return InfoListPage(
            title: title,
            items: isEventPage ? eventItems : newsItems,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
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
            InkWell(
              onTap: () => _openSeeMorePage(context),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Text(
                  'Xem thêm →',
                  style: TextStyle(
                    color: Color(0xFFB88455),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WhiteSection extends StatelessWidget {
  final String title;
  final bool showMore;
  final Widget child;

  const _WhiteSection({
    required this.title,
    required this.showMore,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.only(top: 20, bottom: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title, showMore: showMore),
          child,
        ],
      ),
    );
  }
}

class _WhiteContentBlock extends StatelessWidget {
  final List<Widget> children;

  const _WhiteContentBlock({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      padding: const EdgeInsets.only(top: 20, bottom: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 272,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: bestSellerItems.length,
        itemBuilder: (context, index) {
          return _ProductCard(item: bestSellerItems[index]);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final DrinkItem item;

  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAD7),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 142,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const _ImageErrorBox();
                    },
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
                      item.badge,
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
              item.name,
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
                    item.price,
                    style: const TextStyle(
                      color: Color(0xFFB88455),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _AddButton(item: item),
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
      height: 238,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recommendItems.length,
        itemBuilder: (context, index) {
          return _SmallProductCard(item: recommendItems[index]);
        },
      ),
    );
  }
}

class _SmallProductCard extends StatelessWidget {
  final DrinkItem item;

  const _SmallProductCard({required this.item});

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
          SizedBox(
            height: 112,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const _ImageErrorBox();
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC0A05D),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, height: 1.2),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.price,
                    style: const TextStyle(
                      color: Color(0xFFB88455),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _AddButton(item: item),
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
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: mustTryItems.length,
        itemBuilder: (context, index) {
          return _HorizontalProductCard(item: mustTryItems[index]);
        },
      ),
    );
  }
}

class _HorizontalProductCard extends StatelessWidget {
  final DrinkItem item;

  const _HorizontalProductCard({required this.item});

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
          SizedBox(
            width: 108,
            height: double.infinity,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const _ImageErrorBox();
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _AddButton(item: item),
          ),
        ],
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: eventItems.length,
        itemBuilder: (context, index) {
          return _ImageNewsCard(data: eventItems[index]);
        },
      ),
    );
  }
}

class _DrinkNewsList extends StatelessWidget {
  const _DrinkNewsList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          return _ImageNewsCard(data: newsItems[index]);
        },
      ),
    );
  }
}

class _ImageNewsCard extends StatelessWidget {
  final InfoCardData data;

  const _ImageNewsCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openInfoDetailSheet(context, data),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 285,
        margin: const EdgeInsets.only(right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 136,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                data.imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _ImageErrorBox();
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
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
      ),
    );
  }
}

class _ImageErrorBox extends StatelessWidget {
  const _ImageErrorBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8D8BF),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 52,
          color: Color(0xFFB88455),
        ),
      ),
    );
  }
}

class _CartOrderBar extends StatelessWidget {
  final VoidCallback onCartPressed;
  final VoidCallback onOrderPressed;

  const _CartOrderBar({
    required this.onCartPressed,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CartState>(
      valueListenable: CartController.cartNotifier,
      builder: (context, cart, child) {
        if (cart.totalQuantity <= 0) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 106,
          padding: const EdgeInsets.fromLTRB(26, 10, 26, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onCartPressed,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 34,
                        color: Color(0xFFC08043),
                      ),
                      Positioned(
                        top: -9,
                        right: -9,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.totalQuantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  '${_formatMoney(cart.totalPrice)}đ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFC08043),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                height: 44,
                width: 140,
                child: ElevatedButton(
                  onPressed: onOrderPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC08043),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'ĐẶT HÀNG',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartSheet extends StatelessWidget {
  final VoidCallback onOrderPressed;

  const _CartSheet({required this.onOrderPressed});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CartState>(
      valueListenable: CartController.cartNotifier,
      builder: (context, cart, child) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.72,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 9),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 13, 12, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Giỏ hàng',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        size: 31,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: cart.items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text('Giỏ hàng đang trống'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 24),
                        itemBuilder: (context, index) => _CartSheetItem(
                          line: cart.items[index],
                          index: index,
                        ),
                      ),
              ),
              Container(
                color: const Color(0xFFC4874B),
                padding: EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  14 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${cart.totalQuantity} sản phẩm',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${_formatMoney(cart.totalPrice)}đ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 178,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: cart.items.isEmpty ? null : onOrderPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF11110E),
                          foregroundColor: const Color(0xFFD8A46F),
                          disabledBackgroundColor: Colors.black38,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'ĐẶT HÀNG',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
}

class _CartSheetItem extends StatelessWidget {
  final CartLine line;
  final int index;

  const _CartSheetItem({required this.line, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: 86,
            height: 86,
            child: Image.asset(
              line.item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFE8D2B8),
                child: Icon(Icons.local_cafe, color: Color(0xFFC08043)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      line.item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFC08043),
                    size: 28,
                  ),
                ],
              ),
              if (line.option.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  '• ${line.option}',
                  style: const TextStyle(fontSize: 15, height: 1.35),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_formatMoney(_parsePrice(line.item.price))}đ',
                      style: const TextStyle(
                        color: Color(0xFFC08043),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _CartQuantityButton(
                    icon: Icons.remove,
                    onPressed: () => CartController.changeQuantity(index, -1),
                  ),
                  SizedBox(
                    width: 34,
                    child: Text(
                      '${line.quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  _CartQuantityButton(
                    icon: Icons.add,
                    onPressed: () => CartController.changeQuantity(index, 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartQuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CartQuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFC4874B),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class InfoListPage extends StatelessWidget {
  final String title;
  final List<InfoCardData> items;

  const InfoListPage({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6E5C9),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight + 92,
              color: Colors.white,
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 18,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(
                          Icons.arrow_back,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _LargeInfoCard(data: items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargeInfoCard extends StatelessWidget {
  final InfoCardData data;

  const _LargeInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openInfoDetailSheet(context, data),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              data.imagePath,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(height: 250, child: _ImageErrorBox());
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openInfoDetailSheet(BuildContext context, InfoCardData data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (context) {
      return _InfoDetailSheet(data: data);
    },
  );
}

class _InfoDetailSheet extends StatelessWidget {
  final InfoCardData data;

  const _InfoDetailSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    data.imagePath,
                    width: double.infinity,
                    height: 330,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 330,
                        child: _ImageErrorBox(),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
                    child: Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 44),
                    child: Text(
                      data.content,
                      style: const TextStyle(
                        fontSize: 21,
                        height: 1.45,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(26),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.82),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openProductOptionSheet(BuildContext context, DrinkItem item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (context) {
      return _ProductOptionSheet(item: item);
    },
  );
}

void _openOrderProduct(BuildContext context, OrderProductData product) {
  _openProductOptionSheet(
    context,
    DrinkItem(
      name: product.name,
      price: _formatMoney(product.price),
      badge: product.badge,
      imagePath: product.imagePath,
      description: product.description,
    ),
  );
}

int _parsePrice(String price) {
  return int.tryParse(price.replaceAll(',', '').replaceAll('đ', '').trim()) ??
      0;
}

String _formatMoney(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}

class _AddButton extends StatelessWidget {
  final DrinkItem item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openProductOptionSheet(context, item),
      borderRadius: BorderRadius.circular(20),
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: Color(0xFFF3E2D1),
        child: Icon(Icons.add, color: Color(0xFFB88455)),
      ),
    );
  }
}

class _ProductOptionSheet extends StatefulWidget {
  final DrinkItem item;

  const _ProductOptionSheet({required this.item});

  @override
  State<_ProductOptionSheet> createState() => _ProductOptionSheetState();
}

class _ProductOptionSheetState extends State<_ProductOptionSheet> {
  int quantity = 1;

  String selectedSugar = '30% Đường';
  String selectedTea = 'Giữ nguyên trà';
  String selectedIce = '70% đá';

  final List<String> sugarOptions = const [
    '0% đường & 30% sữa đặc',
    '30% Đường',
    '50% Đường',
    '70% Đường',
    '100% Đường',
    '120% Đường',
  ];

  final List<String> teaOptions = const [
    'Tăng trà',
    'Giữ nguyên trà',
    'Giảm trà',
  ];

  final List<String> iceOptions = const [
    '0% đá',
    '30% đá',
    '50% đá',
    '70% đá',
    '100% đá',
    'Nóng',
  ];

  int get totalPrice {
    return _parsePrice(widget.item.price) * quantity;
  }

  void decreaseQuantity() {
    if (quantity <= 1) return;
    setState(() {
      quantity--;
    });
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void chooseProduct() {
    CartController.addItem(
      widget.item,
      quantity,
      option: '$selectedSugar\n• $selectedTea\n• $selectedIce',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductSheetImage(item: widget.item),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 25,
                            height: 1.22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.description,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.35,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _OptionSection(
                    title: 'Đường',
                    options: sugarOptions,
                    selectedValue: selectedSugar,
                    onChanged: (value) {
                      setState(() {
                        selectedSugar = value;
                      });
                    },
                  ),
                  _OptionSection(
                    title: 'Trà',
                    options: teaOptions,
                    selectedValue: selectedTea,
                    onChanged: (value) {
                      setState(() {
                        selectedTea = value;
                      });
                    },
                  ),
                  _OptionSection(
                    title: 'Đá',
                    options: iceOptions,
                    selectedValue: selectedIce,
                    onChanged: (value) {
                      setState(() {
                        selectedIce = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Lưu ý chọn món',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 14),
                        _NoteChip(title: 'Đá chung'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomChooseBar(
                quantity: quantity,
                totalPrice: totalPrice,
                onMinus: decreaseQuantity,
                onPlus: increaseQuantity,
                onChoose: chooseProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductSheetImage extends StatelessWidget {
  final DrinkItem item;

  const _ProductSheetImage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 360,
          width: double.infinity,
          child: Image.asset(
            item.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const _ImageErrorBox();
            },
          ),
        ),
        Positioned(
          top: 18,
          right: 18,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _OptionSection({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0EBDD), width: 6)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...options.map((option) {
              final bool isSelected = option == selectedValue;

              return InkWell(
                onTap: () => onChanged(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEFEFEF)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFC08A55),
                            width: 1.4,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFC08A55),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NoteChip extends StatelessWidget {
  final String title;

  const _NoteChip({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2CDB6)),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BottomChooseBar extends StatelessWidget {
  final int quantity;
  final int totalPrice;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onChoose;

  const _BottomChooseBar({
    required this.quantity,
    required this.totalPrice,
    required this.onMinus,
    required this.onPlus,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF1DFCC),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onMinus,
            borderRadius: BorderRadius.circular(30),
            child: const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFFC08043),
              child: Icon(Icons.remove, color: Colors.white, size: 30),
            ),
          ),
          SizedBox(
            width: 46,
            child: Center(
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onPlus,
            borderRadius: BorderRadius.circular(30),
            child: const CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFFC08043),
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: onChoose,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC08043),
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'CHỌN - ${_formatMoney(totalPrice)}Đ',
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
