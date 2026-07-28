import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String description;
  final String expire;
  final String badge;
  final Color badgeColor;

  const VoucherCard({
    super.key,
    required this.title,
    required this.description,
    required this.expire,
    required this.badge,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              //================ Left =================//

              Container(
                width: 105,
                height: 165,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      badgeColor,
                      badgeColor.withValues(alpha: .8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    bottomLeft: Radius.circular(26),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 40,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "ƯU ĐÃI",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //================ Fake dotted line =================//

              SizedBox(
                width: 16,
                height: 165,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    15,
                    (index) => Container(
                      width: 2,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),

              //================ Right =================//

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    18,
                    18,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.brown,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Còn 1 voucher",
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Colors.red,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              expire,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.brown,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.qr_code, size: 18),
                            label: const Text("Dùng"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //================ HOT =================//

          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "HOT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          //================ Lỗ vé =================//

          Positioned(
            left: 97,
            top: -9,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.lightBeige,
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: 97,
            bottom: -9,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.lightBeige,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}