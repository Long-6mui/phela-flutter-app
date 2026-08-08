import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
              // HEADER GIỮ NGUYÊN
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
                          'VỀ CHÚNG TÔI',
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'CÂU CHUYỆN PHÊ LA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8A5B3E), // Nâu đậm hơn
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Nốt hương đặc sản giữa lòng Đà Lạt.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5A4D43), // Tối hơn cho dễ đọc
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ==========================================
                      // VỊ TRÍ ẢNH 1 
                      // ==========================================
                      _DecoratedImage(
                        imagePath: 'assets/images/banners/Update-web.jpg', // THÊM LINK ẢNH 1 VÀO ĐÂY
                        height: 350,
                      ),
                      const SizedBox(height: 24),

                      _InspirationCard(
                        title: 'Cảm hứng',
                        content:
                            '"Bắt đầu từ tình yêu thuần khiết với những nốt hương đặc sản của nông sản Việt, Phê La ra đời như một lời khẳng định về giá trị của sự nguyên bản và tinh thần thủ công tỉ mỉ."',
                      ),
                      const SizedBox(height: 32),

                      _VisionCard(
                        title: 'Tầm nhìn',
                        icon: Icons.remove_red_eye_outlined,
                        content:
                            'Trở thành biểu tượng của phong cách sống hiện đại nhưng đậm chất truyền thống, nơi mỗi tách trà, ly cà phê đều kể một câu chuyện về vùng đất và con người.',
                      ),
                      const SizedBox(height: 32),

                      _MissionCard(
                        title: 'Sứ mệnh',
                        icon: Icons.star_border_rounded,
                        content:
                            'Chúng tôi cam kết gìn giữ và nâng tầm giá trị nông sản Việt bằng phương pháp pha chế thủ công hiện đại. Phê La không chỉ bán đồ uống, chúng tôi trao gửi sự chân thành và niềm tự hào dân tộc.',
                      ),
                      const SizedBox(height: 24),

                      // ==========================================
                      // VỊ TRÍ ẢNH 2 
                      // ==========================================
                      _DecoratedImage(
                        imagePath: 'assets/images/banners/491960477_1087788390038220_2515465350308592691_n.jpg', // THÊM LINK ẢNH 2 VÀO ĐÂY
                        height: 300,
                      ),
                      const SizedBox(height: 24),

                      _SpecialtyNotesCard(),
                      const SizedBox(height: 24),

                      // ==========================================
                      // VỊ TRÍ ẢNH 3 
                      // ==========================================
                      _DecoratedImage(
                        imagePath: 'assets/images/banners/326386567_2808509185946106_3255994807608296453_n.jpg', // THÊM LINK ẢNH 3 VÀO ĐÂY
                        height: 450,
                      ),
                      const SizedBox(height: 40),
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

// Widget khung ảnh đã tích hợp sẵn tính năng đọc đường dẫn và bo góc
class _DecoratedImage extends StatelessWidget {
  final String imagePath;
  final double height;

  const _DecoratedImage({
    required this.imagePath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: imagePath.isEmpty
          ? Center(
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: Colors.grey.shade500,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: Colors.grey.shade500,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  final String title;
  final String content;

  const _InspirationCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EBD8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2F1D), // Chữ nâu đen đậm, sáng và rõ
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: Color(0xFF3E3228), // Đậm hơn để dễ đọc trên nền sáng
            ),
          ),
        ],
      ),
    );
  }
}

class _VisionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _VisionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF4A2F1D),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 28, color: const Color(0xFF4A2F1D)),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2F1D),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF3E3228),
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

class _MissionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _MissionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E5D0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFEBC194),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF6B4226)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2F1D),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF3E3228),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialtyNotesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF914B2B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Nốt Hương Đặc Sản',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Chữ trắng sáng hoàn toàn
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Khám phá sự đa dạng của các nốt hương hoa, quả mọng và socola ẩn sâu trong từng búp trà, hạt cà.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.white, // Trắng hoàn toàn
            ),
          ),
          SizedBox(height: 20),
          _BulletPointText('Hoa Nhài Đất'),
          SizedBox(height: 8),
          _BulletPointText('Cam Chanh Thanh Khiết'),
          SizedBox(height: 8),
          _BulletPointText('Socola Đậm Đà'),
        ],
      ),
    );
  }
}

class _BulletPointText extends StatelessWidget {
  final String text;

  const _BulletPointText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '• ',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Chữ trắng hoàn toàn
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}