import 'package:flutter/material.dart';
import '../models/De_Tai.dart';

class DeTaiItem extends StatelessWidget {
  final DeTai deTai;

  const DeTaiItem({
    super.key,
    required this.deTai,
  });

  static const TextStyle _textStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(
            'Bạn chọn ${deTai.tenDeTai}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        color: const Color.fromARGB(
          255,
          200,
          197,
          177,
        ),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.home),

            title: Text(
              deTai.maDeTai,
              style: _textStyle,
            ),

            subtitle: Text(
              deTai.tenDeTai,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            trailing: const Icon(
              Icons.arrow_forward,
            ),

            onTap: () {
              _showDialog(context);
            },
          ),

          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Chuyên ngành: ${deTai.chuyenNganh}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Text(
              deTai.noiDung,
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Giáo viên: ${deTai.tenGiangVien}',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}