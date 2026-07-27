import 'package:flutter/material.dart';

import 'main_page.dart';

const _brand = Color(0xFFBF8248);
const _softBrand = Color(0xFFF2E3D4);

class _OrderEntry {
  final String name;
  final int price;
  final String? imagePath;
  final String badge;

  const _OrderEntry(
    this.name,
    this.price, {
    this.imagePath,
    this.badge = '',
  });

  DrinkItem toDrinkItem() {
    return DrinkItem(
      name: name,
      price: _money(price),
      badge: badge,
      imagePath: imagePath ?? '',
      description:
          'Thức uống đặc sản Phê La với hương vị hài hòa, thơm dịu và dễ thưởng thức.',
    );
  }
}

class _OrderGroup {
  final String title;
  final List<_OrderEntry> items;
  final bool isCombo;

  const _OrderGroup(this.title, this.items, {this.isCombo = false});
}

const _groups = <_OrderGroup>[
  _OrderGroup(
    'Combo',
    [
      _OrderEntry(
        'Combo Chill Độc Quyền 123K',
        123000,
        imagePath: 'assets/images/banners/banner_phe_la.jpg',
      ),
      _OrderEntry(
        'Combo Chill Đôi Phin Giấy',
        148000,
        imagePath: 'assets/images/banners/banner_phe_la_2.jpg',
      ),
      _OrderEntry(
        'Combo Chill Đôi Phê Truffle',
        132000,
        imagePath: 'assets/images/banners/banner_phe_la3.jpg',
      ),
      _OrderEntry(
        'Combo Chill Phê La',
        149000,
        imagePath: 'assets/images/banners/banner_phe_la_4.jpg',
      ),
    ],
    isCombo: true,
  ),
  _OrderGroup(
    'HCM - Bánh Ngọt',
    [
      _OrderEntry('HCM - Bông Lan Trứng Muối', 50000),
    ],
  ),
  _OrderGroup(
    'Cà Phê',
    [
      _OrderEntry(
        'Phan Xi Păng Phê Phin Đặc Sản - đá xay',
        74000,
        imagePath:
            'assets/images/coffees/Phan-Xi-Pang-Phe-Phin-Dac-San-da-xay-scaled.jpg',
        badge: 'MỚI',
      ),
      _OrderEntry(
        'Đà Lạt (phiên bản mới) - cà phê',
        54000,
        imagePath: 'assets/images/coffees/Da-Lat-phien-ban-moi-Moi-scaled.jpg',
      ),
      _OrderEntry(
        'Phê Ô Long Bưởi Cam Vàng - cà phê',
        54000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/Phe-O-Long-Buoi-Cam-Vang-Moi-scaled.jpg',
      ),
      _OrderEntry(
        'Phê Cappu (hạt Ethi) - Nóng',
        59000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/8.-Phe-Cappu-hat-Colom-Ethi-Da-scaled.jpg',
      ),
      _OrderEntry(
        'Phê Ame (hạt Ethi) - Nóng',
        50000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/6.-Phe-Ame-hat-Colom-Ethi-scaled.jpg',
      ),
      _OrderEntry(
        'Phê Nâu - cà phê',
        39000,
        imagePath: 'assets/images/coffees/Phe-Nau.jpg',
      ),
      _OrderEntry(
        'Phê Đen - cà phê',
        39000,
        imagePath: 'assets/images/coffees/Phe-Den.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Syphon',
    [
      _OrderEntry(
        'Mật Nhãn - Ô Long Long Nhãn Sữa',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/syphon/Mat-Nhan-O-Long-Long-Nhan-Sua-Size-La-scaled.jpg',
      ),
      _OrderEntry(
        'Ô Long Nhài Sữa - trà sữa (size Phê)',
        54000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/syphon/O-Long-Nhai-Sua-size-La.jpg',
      ),
      _OrderEntry(
        'Ô Long Sữa Phê La - trà sữa (size Phê)',
        54000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/syphon/O-Long-Sua-Phe-La-size-La.jpg',
      ),
      _OrderEntry(
        'Phong Lan - trà sữa',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/syphon/Phong-Lan-size-La.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Gọi thêm',
    [
      _OrderEntry(
        'Thạch Trà Chanh Vàng',
        15000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/topping/14489.jpg',
      ),
      _OrderEntry(
        'Thạch Xíu Vani',
        15000,
        imagePath: 'assets/images/coffees/Thach-Xiu-Vani.jpg',
      ),
      _OrderEntry(
        'Thạch Trà Đào Hồng',
        15000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/topping/Resize-AppFood-KV-OLongDaoHong-2-09-scaled.jpg',
      ),
      _OrderEntry(
        'Thạch Ô Long Matcha',
        15000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/topping/Thach-O-Long-Matcha-MOI-scaled.jpg',
      ),
      _OrderEntry(
        'Trân Châu Phong Lan',
        10000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/topping/3.-Tran-Chau-Phong-Lan-scaled.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'French Press',
    [
      _OrderEntry(
        'Ô Long Đào Hồng',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/French Press/Resize-AppFood-KV-OLongDaoHong-2-03-scaled.jpg',
      ),
      _OrderEntry(
        'Lụa Đào - Phiên bản Đông Chill yêu thích',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/French Press/Ver-03-Lua-Dao-Phien-ban-Dong-Chill-yeu-thich-size-LAAA.jpg',
      ),
      _OrderEntry(
        'Trà Vỏ Cà Phê',
        54000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/French Press/8-Tra-Vo-Ca-Phe.jpg',
      ),
      _OrderEntry(
        'Gấm - Ô Long Vải Chanh Vàng',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/French Press/Gam-phien-ban-moi-scaled.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Moka Pot',
    [
      _OrderEntry(
        'Tấm - trà sữa (size Phê)',
        54000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/moka pot/3-Tam.jpg',
      ),
      _OrderEntry(
        'Tấm - trà sữa - SIZE LAAA',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/moka pot/3-Tam.jpg',
      ),
      _OrderEntry(
        'Khói B’Lao - trà sữa',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/moka pot/4-Khoi-B_Lao.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Cold Brew',
    [
      _OrderEntry(
        'Sữa Chua Bông Bưởi',
        64000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/Cold brew/Sua-Chua-Bong-Buoi-menu-scaled.jpg',
      ),
      _OrderEntry(
        'Bông Bưởi Cold Brew',
        64000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/Cold brew/Bong-Buoi-scaled.jpg',
      ),
      _OrderEntry(
        'Si Mơ Cold Brew Ô Long Mơ Đào',
        69000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/Cold brew/Si-Mo-Cold-Brew-O-Long-Mo-Dao.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Ô Long Matcha',
    [
      _OrderEntry(
        'Matcha Phan Xi Păng - đá xay',
        64000,
        imagePath:
            'assets/images/coffees/Matcha-Phan-Xi-Pang-da-xay-MOI-scaled.jpg',
      ),
      _OrderEntry(
        'Matcha Coco Latte - sữa',
        69000,
        imagePath: 'assets/images/coffees/matcha_latte.jpg',
      ),
    ],
  ),
  _OrderGroup(
    'Plus - Lon/ Chai tiện lợi',
    [
      _OrderEntry(
        'Plus - Mật Nhãn (Ô Long Long Nhãn)',
        108000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/chai tiện lợi/Plus-Mat-Nhan-O-Long-Long-Nhan.jpg',
      ),
      _OrderEntry(
        'Plus - Matcha Coco Latte',
        108000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/chai tiện lợi/Plus-Matcha-Coco-Latte.jpg',
      ),
      _OrderEntry(
        'Plus - Khói B’Lao',
        108000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/chai tiện lợi/Plus-KhoiBlao.jpg',
      ),
      _OrderEntry(
        'Plus - Phong Lan',
        108000,
        imagePath:
            'assets/images/quoc anh/hình ảnh phê la/chai tiện lợi/PHONG-LAN-PLUS.jpg',
      ),
    ],
  ),
];

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _searchController = TextEditingController();
  final _contentController = ScrollController();
  final _categoryController = ScrollController();
  final List<GlobalKey> _sectionKeys =
      List.generate(_groups.length, (_) => GlobalKey());
  final List<GlobalKey> _categoryKeys =
      List.generate(_groups.length, (_) => GlobalKey());
  String _selectedCategory = 'Combo';
  bool _showSearch = false;
  bool _isJumpingToCategory = false;

  @override
  void dispose() {
    _searchController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  List<_OrderGroup> get _visibleGroups {
    final query = _searchController.text.trim().toLowerCase();
    return _groups
        .map(
          (group) => _OrderGroup(
            group.title,
            group.items
                .where((item) => item.name.toLowerCase().contains(query))
                .toList(),
            isCombo: group.isCombo,
          ),
        )
        .where((group) => group.items.isNotEmpty)
        .toList();
  }

  Future<void> _scrollToCategory(int index) async {
    setState(() {
      _selectedCategory = _groups[index].title;
      _isJumpingToCategory = true;
      _searchController.clear();
      _showSearch = false;
    });

    await Future<void>.delayed(Duration.zero);
    final sectionContext = _sectionKeys[index].currentContext;
    if (sectionContext != null) {
      await Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
        alignment: 0,
      );
    }
    if (mounted) {
      setState(() => _isJumpingToCategory = false);
    }
  }

  void _updateActiveCategory() {
    if (_isJumpingToCategory || _searchController.text.isNotEmpty) return;

    var activeIndex = 0;
    var closestTop = double.negativeInfinity;
    for (var index = 0; index < _sectionKeys.length; index++) {
      final sectionContext = _sectionKeys[index].currentContext;
      if (sectionContext == null) continue;
      final box = sectionContext.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top <= 300 && top > closestTop) {
        closestTop = top;
        activeIndex = index;
      }
    }

    final nextCategory = _groups[activeIndex].title;
    if (nextCategory == _selectedCategory) return;
    setState(() => _selectedCategory = nextCategory);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chipContext = _categoryKeys[activeIndex].currentContext;
      if (chipContext != null) {
        Scrollable.ensureVisible(
          chipContext,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleGroups = _visibleGroups;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _OrderHeader(
              showSearch: _showSearch,
              controller: _searchController,
              onSearchTap: () {
                setState(() => _showSearch = !_showSearch);
              },
              onChanged: (_) => setState(() {}),
            ),
            _CategoryBar(
              controller: _categoryController,
              itemKeys: _categoryKeys,
              selectedCategory: _selectedCategory,
              onSelected: _scrollToCategory,
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E8BE),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/backgrounds/coffee_background.jpg',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.38,
                  ),
                ),
                child: visibleGroups.isEmpty
                    ? const _NoProductFound()
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification ||
                              notification is ScrollEndNotification) {
                            _updateActiveCategory();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          controller: _contentController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(18, 26, 18, 130),
                          child: Column(
                            children: [
                              for (var index = 0;
                                  index < visibleGroups.length;
                                  index++)
                                _OrderSection(
                                  key: _sectionKeys[
                                      _groups.indexWhere((group) =>
                                          group.title ==
                                          visibleGroups[index].title)],
                                  group: visibleGroups[index],
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final bool showSearch;
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  final ValueChanged<String> onChanged;

  const _OrderHeader({
    required this.showSearch,
    required this.controller,
    required this.onSearchTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Đặt hàng',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Material(
                color: _softBrand,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Tìm món',
                  onPressed: onSearchTap,
                  icon: Icon(
                    showSearch ? Icons.close_rounded : Icons.search_rounded,
                    color: _brand,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          if (showSearch) ...[
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm tên món...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: const Color(0xFFF8F4EF),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final ScrollController controller;
  final List<GlobalKey> itemKeys;
  final String selectedCategory;
  final ValueChanged<int> onSelected;

  const _CategoryBar({
    required this.controller,
    required this.itemKeys,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      color: Colors.white,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        itemCount: _groups.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final title = _groups[index].title;
          final selected = title == selectedCategory;
          return Material(
            key: itemKeys[index],
            color: selected ? _brand : Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selected ? _brand : const Color(0xFFE8D7C3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderSection extends StatelessWidget {
  final _OrderGroup group;

  const _OrderSection({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          if (group.isCombo)
            SizedBox(
              height: 305,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: group.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return _ComboCard(item: group.items[index]);
                },
              ),
            )
          else
            ...group.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProductRow(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

class _ComboCard extends StatelessWidget {
  final _OrderEntry item;

  const _ComboCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openProductOptionSheet(context, item.toDrinkItem()),
        child: SizedBox(
          width: 185,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 184,
                width: double.infinity,
                child: _OrderImage(path: item.imagePath),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: _RoundAddButton(
                          onTap: () => openProductOptionSheet(
                            context,
                            item.toDrinkItem(),
                          ),
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
    );
  }
}

class _ProductRow extends StatelessWidget {
  final _OrderEntry item;

  const _ProductRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final drink = item.toDrinkItem();
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openProductOptionSheet(context, drink),
        child: SizedBox(
          height: 132,
          child: Row(
            children: [
              SizedBox(
                width: 126,
                height: double.infinity,
                child: _OrderImage(path: item.imagePath),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _money(item.price),
                              style: const TextStyle(
                                color: _brand,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          _RoundAddButton(
                            onTap: () =>
                                openProductOptionSheet(context, drink),
                          ),
                        ],
                      ),
                    ],
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

class _OrderImage extends StatelessWidget {
  final String? path;

  const _OrderImage({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path == null || path!.isEmpty) {
      return const _PheLaPlaceholder();
    }
    return Image.asset(
      path!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const _PheLaPlaceholder(),
    );
  }
}

class _PheLaPlaceholder extends StatelessWidget {
  const _PheLaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE3C39E),
      child: Center(
        child: Text(
          'Phê·La',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
        ),
      ),
    );
  }
}

class _RoundAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RoundAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _softBrand,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.add_rounded, color: _brand, size: 26),
        ),
      ),
    );
  }
}

class _NoProductFound extends StatelessWidget {
  const _NoProductFound();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Không tìm thấy món phù hợp.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

String _money(int value) {
  return value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );
}
