import 'package:flutter/material.dart';

class BaiTap03 extends StatefulWidget {
  const BaiTap03({super.key});

  @override
  State<BaiTap03> createState() => _BaiTap03State();
}

class _BaiTap03State extends State<BaiTap03> {
  static const Color momoPink = Color(0xFFD82B8B);
  static const Color lightPink = Color(0xFFFFD8EA);

  final List<Map<String, dynamic>> gifts = [
    {
      'icon': Icons.local_movies_outlined,
      'brand': 'CGV',
      'title': 'CGV -',
      'description': 'Đồng giá 79K khi mua vé CGV 2D trên M...',
      'date': 'HSD: 28/02/2025',
      'action': 'Dùng ngay',
      'favorite': false,
      'color': Colors.red,
    },
    {
      'icon': Icons.phone_android,
      'brand': 'Mua Sim\nchính chủ',
      'title': 'Giảm 100K',
      'description': 'Cho đơn từ 0đ',
      'date': 'HSD: 28/02/2025',
      'action': 'Dùng ngay',
      'favorite': true,
      'color': momoPink,
    },
    {
      'icon': Icons.account_balance,
      'brand': 'Ngân hàng\nQuốc Tế VIB',
      'title': 'Tặng 100k',
      'description': 'Khi mở thẻ VIB Online Plus 2in1 (*)',
      'date': 'HSD: 31/03/2025',
      'action': 'Quà hiện vật',
      'favorite': false,
      'color': Colors.lightBlue,
    },
    {
      'icon': Icons.beach_access_outlined,
      'brand': 'Thanh toán\nBảo hiểm',
      'title': 'Hoàn 15K',
      'description': 'Cho hóa đơn từ 3.000.000đ',
      'date': 'Hết hạn sau 5 ngày',
      'action': 'Dùng ngay',
      'favorite': false,
      'color': Colors.lightBlue,
    },
    {
      'icon': Icons.storefront_outlined,
      'brand': 'Phí không\ndừng',
      'title': 'Giảm 10K',
      'description': 'Cho đơn từ 100K',
      'date': '',
      'action': 'Thu thập',
      'favorite': false,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER HỒNG
            // ==========================================
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFD5E7),
                    Color(0xFFFFE8F1),
                  ],
                ),
              ),
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.arrow_back,
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Quà của Vinh (7)',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _circleButton(
                    icon: Icons.support_agent_outlined,
                    onTap: () {},
                  ),

                  const SizedBox(width: 5),

                  _circleButton(
                    icon: Icons.close,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ==========================================
            // FILTER
            // ==========================================
            Container(
              height: 55,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(
                      icon: Icons.filter_alt_outlined,
                    ),

                    const SizedBox(width: 8),

                    _filterChip(
                      text: 'Sắp xếp',
                      trailingIcon: Icons.sort,
                    ),

                    const SizedBox(width: 8),

                    _filterChip(
                      text: 'Dịch vụ',
                      trailingIcon:
                          Icons.keyboard_arrow_down,
                    ),

                    const SizedBox(width: 8),

                    _filterChip(
                      text: 'Gần tôi',
                    ),

                    const SizedBox(width: 8),

                    _filterChip(
                      text: 'Yêu thích',
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // NỘI DUNG CUỘN
            // ==========================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  10,
                  10,
                  15,
                ),
                children: [
                  // ====================================
                  // XU + THẺ QUÀ
                  // ====================================
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEE),
                            border: Border.all(
                              color:
                                  const Color(0xFFF4C869),
                            ),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration:
                                    const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Color(0xFFFFC928),
                                ),
                                child: const Center(
                                  child: Text(
                                    'm',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đang có',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '1.955 Xu',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.chevron_right,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Container(
                          height: 50,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2478E8),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '🎁',
                                style: TextStyle(
                                  fontSize: 27,
                                ),
                              ),

                              SizedBox(width: 7),

                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bỏ túi ngay',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      '4 thẻ quà',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    Colors.white,
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color:
                                      Color(0xFF2478E8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ====================================
                  // DANH SÁCH QUÀ
                  // ====================================
                  ...List.generate(
                    gifts.length,
                    (index) {
                      return _giftCard(
                        index,
                        gifts[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // CARD QUÀ
  // ==================================================
  Widget _giftCard(
    int index,
    Map<String, dynamic> gift,
  ) {
    return Container(
      height: 92,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          // ==========================
          // LOGO / THƯƠNG HIỆU
          // ==========================
          Container(
            width: 105,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  gift['icon'],
                  size: 27,
                  color: gift['color'],
                ),

                const SizedBox(height: 4),

                Text(
                  gift['brand'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),

          // ==========================
          // THÔNG TIN
          // ==========================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                7,
                7,
                6,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gift['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gifts[index]['favorite'] =
                                !gifts[index]
                                    ['favorite'];
                          });
                        },
                        child: Icon(
                          gift['favorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 19,
                          color: gift['favorite']
                              ? momoPink
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    gift['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                    ),
                  ),

                  if ((gift['date'] as String)
                      .isNotEmpty)
                    Text(
                      gift['date'],
                      style: TextStyle(
                        fontSize: 9.5,
                        color: gift['date']
                                .toString()
                                .contains('Hết hạn')
                            ? Colors.orange
                            : Colors.black54,
                      ),
                    ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: gift['action'] == 'Thu thập'
                        ? Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: momoPink,
                              ),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Thu thập',
                              style: TextStyle(
                                color: momoPink,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          )
                        : Text(
                            gift['action'],
                            style: TextStyle(
                              color: gift['action'] ==
                                      'Quà hiện vật'
                                  ? Colors.grey
                                  : momoPink,
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // FILTER CHIP
  // ==================================================
  Widget _filterChip({
    String? text,
    IconData? icon,
    IconData? trailingIcon,
  }) {
    return Container(
      height: 34,
      padding: EdgeInsets.symmetric(
        horizontal: text == null ? 10 : 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 18,
              color: Colors.black54,
            ),

          if (text != null)
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(
              trailingIcon,
              size: 15,
              color: Colors.black54,
            ),
          ],
        ],
      ),
    );
  }

  // ==================================================
  // BUTTON HEADER
  // ==================================================
  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.black54,
        ),
      ),
    );
  }
}