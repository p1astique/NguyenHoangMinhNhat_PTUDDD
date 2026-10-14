import 'package:flutter/material.dart';

import '../models/De_Tai.dart';
import '../widgets/De_Tai_Item.dart';

class ViDu02 extends StatefulWidget {
  const ViDu02({super.key});

  @override
  State<ViDu02> createState() => _ViDu02State();
}

class _ViDu02State extends State<ViDu02> {
  static const List<DeTai> dsDeTai = [
    DeTai(
      maDeTai: 'DT01',
      tenDeTai:
          'Khai thác tập hữu ích cao trên CSDL giao dịch',
      tenGiangVien: 'ThS. Vũ Văn Vinh',
      noiDung:
          'Khai phá tập HUI, tìm hiểu và vận dụng các kỹ thuật '
          'tỉa hiệu quả để giảm bớt không gian tìm kiếm',
      chuyenNganh: 'CNPM',
    ),

    DeTai(
      maDeTai: 'DT03',
      tenDeTai:
          'Phát hiện tấn công và ngăn ngừa phát tán mã độc '
          'trong hệ thống mạng',
      tenGiangVien: 'ThS. Vũ Văn Vinh',
      noiDung:
          'Khai phá topKHUI, kết hợp với việc tăng ngưỡng sớm '
          'để có được minUtil lớn nhất, từ đó áp dụng các '
          'chiến lược tỉa và tăng ngưỡng.',
      chuyenNganh: 'CNPM',
    ),

    DeTai(
      maDeTai: 'DT02',
      tenDeTai:
          'Khai thác K tập hữu ích cao nhất (topKHUI)',
      tenGiangVien: 'TS. Vũ Đức Thịnh',
      noiDung:
          'Khai phá topKHUI, kết hợp với việc tăng ngưỡng sớm '
          'để có được minUtil lớn nhất, từ đó áp dụng các '
          'chiến lược tỉa và tăng ngưỡng.',
      chuyenNganh: 'MMT',
    ),

    DeTai(
      maDeTai: 'DT04',
      tenDeTai:
          'Xây dựng hệ thống thông tin hỗ trợ việc giảng dạy tại HUIT',
      tenGiangVien: 'ThS. Nguyễn Văn Lễ',
      noiDung:
          'Khai phá topKHUI, kết hợp với việc tăng ngưỡng sớm '
          'để có được minUtil lớn nhất, từ đó áp dụng các '
          'chiến lược tỉa và tăng ngưỡng.',
      chuyenNganh: 'HTTT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Demo'),
        backgroundColor: const Color.fromARGB(
          255,
          239,
          168,
          4,
        ),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ),

      body: ListView.builder(
        itemCount: dsDeTai.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          return DeTaiItem(
            deTai: dsDeTai[index],
          );
        },
      ),
    );
  }
}