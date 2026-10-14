import 'package:flutter/material.dart';

class BaiTap04 extends StatefulWidget {
  const BaiTap04({super.key});

  @override
  State<BaiTap04> createState() => _BaiTap04State();
}

class _BaiTap04State extends State<BaiTap04> {
  static const Color appColor = Color(0xFFFFC400);

  // 0 = giới thiệu
  // 1 = cửa hàng
  // 2 = giỏ hàng
  int _currentPage = 0;

  // ==========================================
  // DANH SÁCH SẢN PHẨM
  // ==========================================
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Điện thoại 01',
      'description':
          'Điện thoại mới của hãng SamSung với công nghệ hiện đại',
      'price': 1200.0,

      // TODO: tải ảnh và bỏ vào:
      // assets/images/dien_thoai_01.jpg
      'image': 'assets/images/dien_thoai_01.jpg',
    },
    {
      'name': 'Điện thoại 04',
      'description':
          'Điện thoại thông minh với thiết kế đẹp và hiện đại',
      'price': 602.2,

      // TODO: tải ảnh và bỏ vào:
      // assets/images/dien_thoai_04.jpg
      'image': 'assets/images/dien_thoai_04.jpg',
    },
    {
      'name': 'Điện thoại 07',
      'description':
          'Điện thoại cao cấp với nhiều tính năng nổi bật',
      'price': 2000.0,

      // TODO: tải ảnh và bỏ vào:
      // assets/images/dien_thoai_07.jpg
      'image': 'assets/images/dien_thoai_07.jpg',
    },
  ];

  final List<Map<String, dynamic>> _cart = [];

  // ==========================================
  // THÊM SẢN PHẨM
  // ==========================================
  void _confirmAddProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Xác nhận',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn vừa thêm sản phẩm vào Giỏ hàng',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Không',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cart.add(product);
                });

                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // XÓA SẢN PHẨM
  // ==========================================
  void _confirmRemoveProduct(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Xác nhận',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Không',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cart.removeAt(index);
                });

                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // THANH TOÁN
  // ==========================================
  void _payment() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bạn chưa có sản phẩm nào trong giỏ hàng!!!',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Thanh toán',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Bạn đã thanh toán xong giỏ hàng',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                setState(() {
                  _cart.clear();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage == 0) {
      return _buildIntroPage();
    }

    if (_currentPage == 2) {
      return _buildCartPage();
    }

    return _buildStorePage();
  }

  // ============================================================
  // MÀN HÌNH 1 - GIỚI THIỆU
  // ============================================================
  Widget _buildIntroPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // =================================================
              // TODO: ẢNH LOGO HUIT
              // Tải ảnh và lưu:
              // assets/images/logo_huit.png
              // =================================================
              Image.asset(
                'assets/images/logo_huit.png',
                width: 110,
                height: 110,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 25),

              const Text(
                'Cửa hàng điện thoại',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                '140 Lê Trọng Tấn, Tân Phú, TP Hồ Chí Minh',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: 58,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: const StadiumBorder(),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MÀN HÌNH 2 - CỬA HÀNG
  // ============================================================
  Widget _buildStorePage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: appColor,
        foregroundColor: Colors.black54,
        elevation: 0,
        title: const Text(
          'Cửa hàng điện thoại',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentPage = 2;
              });
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                ),

                if (_cart.isNotEmpty)
                  Positioned(
                    right: -7,
                    top: -7,
                    child: Container(
                      width: 17,
                      height: 17,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      drawer: _buildDrawer(),

      body: Column(
        children: [
          // Dòng tiêu đề
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            color: const Color(0xFFE6E6E6),
            child: const Text(
              'Chọn sản phẩm bạn muốn sử dụng',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ====================================================
          // DANH SÁCH SẢN PHẨM CUỘN NGANG
          // ====================================================
          SizedBox(
            height: 335,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: _products.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _buildProductCard(
                  _products[index],
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            color: const Color(0xFFE6E6E6),
            child: const Text(
              'Sản phẩm được lựa chọn nhiều nhất',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================
  Widget _buildProductCard(
    Map<String, dynamic> product,
  ) {
    return Container(
      width: 205,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =================================================
          // TODO: ẢNH ĐIỆN THOẠI
          // Đường dẫn lấy từ product['image']
          // =================================================
          Center(
            child: Image.asset(
              product['image'],
              width: 145,
              height: 145,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product['name'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            product['description'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: Text(
                  '${product['price']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ),

              SizedBox(
                width: 38,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    _confirmAddProduct(product);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor:
                        const Color(0xFF00D6C7),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================
  Widget _buildDrawer() {
    return Drawer(
      width: 270,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(
              16,
              45,
              16,
              15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =============================================
                // TODO: LOGO HUIT
                // assets/images/logo_huit.png
                // =============================================
                Image.asset(
                  'assets/images/logo_huit.png',
                  width: 62,
                  height: 62,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Võ Văn Vinh',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'vinhvv@huit.edu.vn',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: const Color(0xFF2196E3),
              child: Column(
                children: [
                  _drawerItem(
                    icon: Icons.shopping_bag,
                    title: 'Cửa hàng',
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        _currentPage = 1;
                      });
                    },
                  ),

                  _drawerItem(
                    icon: Icons.shopping_cart,
                    title: 'Giỏ hàng',
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        _currentPage = 2;
                      });
                    },
                  ),

                  _drawerItem(
                    icon: Icons.exit_to_app,
                    title: 'Thoát',
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        _currentPage = 0;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: Colors.black87,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      onTap: onTap,
    );
  }

  // ============================================================
  // MÀN HÌNH GIỎ HÀNG
  // ============================================================
  Widget _buildCartPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor: appColor,
        foregroundColor: Colors.black54,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            setState(() {
              _currentPage = 1;
            });
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        title: const Text(
          'Giỏ hàng của bạn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            color: const Color(0xFFE6E6E6),
            child: const Text(
              'Giỏ hàng của bạn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
          ),

          Expanded(
            child: _cart.isEmpty
                ? const Center(
                    child: Text(
                      'Bạn chưa có sản phẩm nào vô giỏ hàng!!!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final product = _cart[index];

                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    product['name'],
                                    style:
                                        const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 2,
                                  ),

                                  Text(
                                    '${product['price']}',
                                    style:
                                        const TextStyle(
                                      fontSize: 11,
                                      color:
                                          Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                _confirmRemoveProduct(
                                  index,
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              bottom: 22,
            ),
            child: SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: _payment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor:
                      const Color(0xFF00BFAF),
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 22,
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 10,
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