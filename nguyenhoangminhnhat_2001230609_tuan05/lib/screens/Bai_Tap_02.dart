import 'package:flutter/material.dart';

class BaiTap02 extends StatefulWidget {
  const BaiTap02({super.key});

  @override
  State<BaiTap02> createState() => _BaiTap02State();
}

class _BaiTap02State extends State<BaiTap02> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Chuyển tiền',
      'icon': Icons.monetization_on_outlined,
      'color': Colors.pink,
    },
    {
      'title': 'Thanh toán\nhóa đơn',
      'icon': Icons.receipt_long_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'Nạp tiền điện\nthoại',
      'icon': Icons.phone_android,
      'color': Colors.blue,
    },
    {
      'title': 'Mua mã thẻ di\nđộng',
      'icon': Icons.phone_iphone,
      'color': Colors.deepOrange,
    },
    {
      'title': 'Heo Đất MoMo',
      'icon': Icons.savings_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Đi bộ cùng\nMoMo',
      'icon': Icons.directions_walk,
      'color': Colors.teal,
    },
    {
      'title': 'Thanh toán\nquốc tế',
      'icon': Icons.language,
      'color': Colors.blue,
    },
    {
      'title': 'Quản lý chi\ntiêu',
      'icon': Icons.receipt_outlined,
      'color': Colors.teal,
    },
    {
      'title': 'Quỹ nhóm',
      'icon': Icons.groups_outlined,
      'color': Colors.pink,
    },
    {
      'title': 'Chứng Khoán',
      'icon': Icons.layers_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'Vietlott SMS',
      'icon': Icons.confirmation_number_outlined,
      'color': Colors.red,
    },
    {
      'title': 'Xem thêm\ndịch vụ',
      'icon': Icons.grid_view_rounded,
      'color': Colors.grey,
    },
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {
      'title': 'Vay Nhanh',
      'icon': Icons.request_quote_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Mua vé xem ...',
      'icon': Icons.videocam_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'Túi Thần Tài',
      'icon': Icons.redeem_outlined,
      'color': Colors.deepOrange,
    },
    {
      'title': 'Ví Trả Sau',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.pink,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 18, 12, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================
              // 12 DỊCH VỤ - 4 CỘT x 3 HÀNG
              // =========================================
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final item = _services[index];

                  return _serviceItem(
                    title: item['title'],
                    icon: item['icon'],
                    color: item['color'],
                  );
                },
              ),

              const SizedBox(height: 10),

              // =========================================
              // SỰ KIỆN
              // =========================================
              const Text(
                'Sự kiện đang diễn ra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Banner sự kiện
              Container(
                width: double.infinity,
                height: 92,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD84D),
                      Color(0xFFFFF29A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 12,
                      top: 10,
                      bottom: 10,
                      child: Container(
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.celebration,
                          color: Colors.yellow,
                          size: 45,
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 95,
                      top: 12,
                      child: Text(
                        'Tích Lì Xì càng nhiều',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 95,
                      top: 31,
                      child: Text(
                        'Thưởng cuối càng lớn',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 95,
                      top: 48,
                      child: Text(
                        'Đến 50 triệu',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 10,
                      bottom: 9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'CHƠI NGAY',
                          style: TextStyle(
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

              const SizedBox(height: 18),

              // =========================================
              // MOMO ĐỀ XUẤT
              // =========================================
              const Text(
                'MoMo đề xuất',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _suggestions.map((item) {
                  return Expanded(
                    child: _suggestionItem(
                      title: item['title'],
                      icon: item['icon'],
                      color: item['color'],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // =========================================
              // BANNER AI
              // =========================================
              Container(
                width: double.infinity,
                height: 58,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFE448),
                      Color(0xFFFFF8C8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.deepOrange,
                      size: 28,
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2025 nhờ ai mà nở hoa?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Gieo quẻ với AI, tìm quý nhân của bạn',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.pink,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Gieo ngay',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // =========================================
              // PHẦN CUỐI HÌNH MẪU
              // =========================================
              const Text(
                'Có thể bạn quan tâm',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                height: 4,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFD82B8B),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      // =========================================
      // BOTTOM NAVIGATION
      // =========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD82B8B),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'MoMo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            label: 'Ưu đãi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_scanner,
              size: 31,
            ),
            label: 'Quét mã QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử GD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }

  // =============================================
  // ITEM DỊCH VỤ
  // =============================================
  Widget _serviceItem({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: color,
            size: 27,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 10.5,
            height: 1.15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // =============================================
  // ITEM MOMO ĐỀ XUẤT
  // =============================================
  Widget _suggestionItem({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 31,
        ),

        const SizedBox(height: 6),

        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}