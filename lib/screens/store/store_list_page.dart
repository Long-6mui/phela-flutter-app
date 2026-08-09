import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class StoreListPage extends StatefulWidget {
  final bool selectionMode;

  const StoreListPage({super.key, this.selectionMode = false});

  static final List<StoreLocation> stores = [
    const StoreLocation(
      name: 'Phê La - 125 Hồ Tùng Mậu',
      phone: '19003013',
      address:
          '125 Hồ Tùng Mậu, Phường Bến Nghé, Quận 1, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/9a2893e7-d4d7-4688-ab9c-b4802a676325 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 115 Trương Định',
      phone: '19003013',
      address:
          '115 Trương Định, Phường Võ Thị Sáu, Quận 3, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/83ae566c-fcd5-44fb-b2e1-b54a84d6e710 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 129 Phan Xích Long',
      phone: '19003013',
      address: '129 Phan Xích Long, Phường 7, Phú Nhuận, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/468528e7-2d2b-416c-8634-38c0a61c8b67 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 289 Đinh Bộ Lĩnh',
      phone: '19003013',
      address: '289 Đinh Bộ Lĩnh, Phường 26, Bình Thạnh, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/2659290a-b39e-424d-a9f2-dee6518ac334 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 89 Xuân Thủy',
      phone: '19003013',
      address:
          '89 Xuân Thuỷ, Khu phố 2, Phường Thảo Điền, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/af6ada42-ce85-4d80-9441-86a6d062820d (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La Chợ Bến Thành',
      phone: '19003013',
      address:
          '1-3 Phan Chu Trinh, Phường Bến Thành, Quận 1, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/bbe4370c-7b41-4beb-ba38-3ca80163863c (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 193/71 Nam Kỳ Khởi Nghĩa',
      phone: '19003013',
      address:
          '193/71 Nam Kỳ Khởi Nghĩa, Phường 7, Quận 3, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/be3012d1-1b28-4419-b30f-286fed42ab40 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 24 Nguyễn Đình Chiểu',
      phone: '19003013',
      address:
          '24 Nguyễn Đình Chiểu, Phường Đa Kao, Quận 1, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/e4560701-ecf7-4ad7-9560-66f48fd52fdf (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 175B Cao Thắng',
      phone: '19003013',
      address: '175B Cao Thắng, Phường 12, Quận 10, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/eedbab49-2b55-450c-89a0-9f24bc7d8a95 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
    const StoreLocation(
      name: 'Phê La - 35 Mạc Đĩnh Chi',
      phone: '19003013',
      address: '35 Mạc Đĩnh Chi, Phường Đa Kao, Quận 1, Thành phố Hồ Chí Minh',
      openingHours: '07:30 - 22:00',
      imagePath:
          'assets/images/stores/9a2893e7-d4d7-4688-ab9c-b4802a676325 (1).jpg', // Thêm đường dẫn ảnh vào đây
    ),
  ];

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<StoreLocation> get _filteredStores {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return StoreListPage.stores;
    }
    return StoreListPage.stores.where((store) {
      return store.name.toLowerCase().contains(query) ||
          store.phone.contains(query) ||
          store.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/backgrounds/coffee_background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
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
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Danh sách cửa hàng',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const SizedBox(width: 42, height: 42),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm cửa hàng',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.brown,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F4EF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredStores.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy cửa hàng',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.brown,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: _filteredStores.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final store = _filteredStores[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: widget.selectionMode
                                ? () => Navigator.pop(context, store)
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.96),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEDE1D8),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(22),
                                      ),
                                    ),
                                    // Hiển thị ảnh nếu đường dẫn không rỗng, ngược lại hiện icon placeholder
                                    child:
                                        (store.imagePath != null &&
                                            store.imagePath!.isNotEmpty)
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(22),
                                                ),
                                            child: Image.asset(
                                              store.imagePath!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              cacheWidth: 600,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.photo,
                                              size: 48,
                                              color: AppColors.brown,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          store.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.brown,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              size: 18,
                                              color: AppColors.orange,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                store.phone,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                              color: AppColors.orange,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                store.address,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.textGrey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 18,
                                              color: AppColors.orange,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              store.openingHours,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.textGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreLocation {
  final String name;
  final String phone;
  final String address;
  final String openingHours;
  final String? imagePath;

  const StoreLocation({
    required this.name,
    required this.phone,
    required this.address,
    required this.openingHours,
    this.imagePath,
  });
}
