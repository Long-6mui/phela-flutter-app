import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'widgets/member_reward_card.dart';
import 'widgets/voucher_card.dart';
import 'widgets/voucher_search.dart';
import 'widgets/voucher_tab.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,

      appBar: AppBar(
        backgroundColor: AppColors.lightBeige,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ưu đãi",
          style: TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            //------------------------------------------------
            // Search
            //------------------------------------------------

            const VoucherSearch(),

            const SizedBox(height: 22),

            //------------------------------------------------
            // Member Dashboard
            //------------------------------------------------

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _InfoItem(
                    icon: Icons.local_offer,
                    title: "03",
                    subtitle: "Voucher",
                    color: Colors.red,
                  ),

                  _InfoItem(
                    icon: Icons.eco,
                    title: "235",
                    subtitle: "Lá",
                    color: Colors.green,
                  ),

                  _InfoItem(
                    icon: Icons.workspace_premium,
                    title: "Đồng",
                    subtitle: "Hạng",
                    color: AppColors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            //------------------------------------------------
            // Tabs
            //------------------------------------------------

            Row(
              children: [

                Expanded(
                  child: VoucherTab(
                    text: "Khả dụng",
                    selected: selectedTab == 0,
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: VoucherTab(
                    text: "Đã dùng",
                    selected: selectedTab == 1,
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: VoucherTab(
                    text: "Hết hạn",
                    selected: selectedTab == 2,
                    onTap: () {
                      setState(() {
                        selectedTab = 2;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            //------------------------------------------------
            // Title
            //------------------------------------------------

            const Row(
              children: [

                Icon(
                  Icons.card_giftcard,
                  color: AppColors.orange,
                ),

                SizedBox(width: 10),

                Text(
                  "Voucher của bạn",
                  style: TextStyle(
                    color: AppColors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            //------------------------------------------------
            // Voucher List
            //------------------------------------------------

            const VoucherCard(
              title: "Voucher Sinh Nhật",
              description: "Giảm 30% toàn bộ đồ uống",
              expire: "31/12/2026",
              badge: "30%",
              badgeColor: Colors.red,
            ),

            const VoucherCard(
              title: "Miễn phí Freesize",
              description: "Áp dụng cho tất cả đồ uống",
              expire: "25/12/2026",
              badge: "FREE",
              badgeColor: Colors.green,
            ),

            const VoucherCard(
              title: "Mua 2 Tặng 1",
              description: "Áp dụng tại toàn bộ cửa hàng",
              expire: "20/11/2026",
              badge: "2+1",
              badgeColor: AppColors.orange,
            ),

            const SizedBox(height: 28),

            //------------------------------------------------
            // Reward Card
            //------------------------------------------------

            const MemberRewardCard(),

            const SizedBox(height: 28),

            //------------------------------------------------
            // Terms
            //------------------------------------------------

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [

                      Icon(
                        Icons.info_outline,
                        color: AppColors.orange,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "Điều khoản sử dụng",
                        style: TextStyle(
                          color: AppColors.brown,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _rule(
                    "Voucher chỉ áp dụng một lần cho mỗi hóa đơn.",
                  ),

                  _rule(
                    "Không áp dụng cùng các chương trình ưu đãi khác.",
                  ),

                  _rule(
                    "Voucher hết hạn sẽ tự động bị hủy.",
                  ),

                  _rule(
                    "Xuất trình mã QR thành viên trước khi thanh toán.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  static Widget _rule(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textGrey,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CircleAvatar(
          radius: 22,
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}