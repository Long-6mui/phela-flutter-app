import 'package:flutter/material.dart';

const _brandBrown = Color(0xFFB87B43);
const _iconBackground = Color(0xFFF7EFE8);

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const _notifications = <_NotificationData>[
    _NotificationData(
      title: '🖐️ Tranh thủ Happy Chill Day - X2 Nốt Nhạc',
      content:
          'X2 nốt nhạc khi tích điểm và đặt hàng qua ứng dụng Phê La 🎶\n\n'
          'Đồng Chill nhanh rủ hội bạn cùng lên đơn để Tổ Trưởng tiếp sức '
          'những buổi họp đầu tuần nha',
      time: '27/07/2026 09:18',
    ),
    _NotificationData(
      title: '⏰ NGÀY CUỐI CÙNG TỔ TRƯỞNG CHILL ĐÃI COMBO MUA 02 TẶNG 01',
      content:
          'Tặng 01 Trà Sữa bất kỳ (tối đa 54K) khi Đồng Chill đặt từ 02 '
          'Trà Sữa size La bất kỳ.\n\n'
          'Mời Đồng Chill lên App Phê La chill quà ngay nhaa 🖐️',
      time: '26/07/2026 11:38',
    ),
    _NotificationData(
      title:
          '🖐️ Chill thứ 7, nạp năng lượng cùng Combo Mua 02 Tặng 01 trên App Phê La',
      content:
          'Tặng 01 Trà sữa size Phê khi mua Combo 02 size La trên App, '
          'Đồng Chill rủ hội bạn thử ngay nha 🎶',
      time: '25/07/2026 11:07',
    ),
    _NotificationData(
      title: 'Đồng Chill ơi, tặng bạn 01 Trà Sữa bất kỳ (tối đa 54K) 🎶',
      content:
          'Thứ 06, Tổ Trưởng mở tiệc chill đãi Đồng Chill. Đặt ngay trên '
          'ứng dụng Phê La để nhận ưu đãi nhé!',
      time: '24/07/2026 10:26',
    ),
    _NotificationData(
      title: 'Happy Chill Day đã trở lại rồi đây',
      content:
          'Tích điểm, đặt món và tận hưởng những ưu đãi dành riêng cho '
          'Đồng Chill trên ứng dụng Phê La.',
      time: '23/07/2026 09:05',
      isUnread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFD8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: IconButton(
          tooltip: 'Quay lại',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/backgrounds/coffee_background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
            physics: const BouncingScrollPhysics(),
            itemCount: _notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _NotificationCard(data: _notifications[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationData {
  final String title;
  final String content;
  final String time;
  final bool isUnread;

  const _NotificationData({
    required this.title,
    required this.content,
    required this.time,
    this.isUnread = true,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationData data;

  const _NotificationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BellBadge(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: _brandBrown,
                        fontSize: 18,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        height: 1.42,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.time,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (data.isUnread)
          const Positioned(
            top: 11,
            right: 11,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFEE1C2E),
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 9, height: 9),
            ),
          ),
      ],
    );
  }
}

class _BellBadge extends StatelessWidget {
  const _BellBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: _iconBackground,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.notifications_none_rounded,
        color: _brandBrown,
        size: 29,
      ),
    );
  }
}
