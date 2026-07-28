import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'widgets/member_card.dart';
import 'widgets/reward_card.dart';
import 'widgets/member_level_card.dart';
import 'widgets/leaf_progress.dart';
import 'widgets/quick_action.dart';

class QRPage extends StatelessWidget {
  const QRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBeige,

      appBar: AppBar(
        backgroundColor: AppColors.lightBeige,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.brown,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mã thành viên",
          style: TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [

            //----------------------------------------
            // Greeting
            //----------------------------------------

            const Text(
              "Xin chào 👋",
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Quốc Anh",
              style: TextStyle(
                color: AppColors.brown,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -.5,
              ),
            ),

            const SizedBox(height: 24),

            //----------------------------------------
            // QR Card
            //----------------------------------------

            const MemberCard(),

            const SizedBox(height: 18),

            //----------------------------------------
            // Reward
            //----------------------------------------

            const RewardCard(),

            const SizedBox(height: 18),

            //----------------------------------------
            // Member Level
            //----------------------------------------

            const MemberLevelCard(),

            const SizedBox(height: 18),

            //----------------------------------------
            // Progress
            //----------------------------------------

            const LeafProgress(
              current: 235,
              target: 250,
            ),

            const SizedBox(height: 30),

            //----------------------------------------
            // Quick Action
            //----------------------------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [

                QuickAction(
                  icon: Icons.history,
                  title: "Lịch sử",
                ),

                QuickAction(
                  icon: Icons.storefront,
                  title: "Cửa hàng",
                ),

                QuickAction(
                  icon: Icons.help_outline,
                  title: "Hướng dẫn",
                ),

                QuickAction(
                  icon: Icons.card_giftcard,
                  title: "Đổi quà",
                ),
              ],
            ),

            const SizedBox(height: 38),

            //----------------------------------------
            // Hotline
            //----------------------------------------

            const Center(
              child: Text(
                "Hotline: 1900 xxxx",
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}