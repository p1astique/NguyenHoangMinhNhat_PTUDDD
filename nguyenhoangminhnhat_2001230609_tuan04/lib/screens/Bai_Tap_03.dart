import 'package:flutter/material.dart';

class BaiTap03 extends StatefulWidget {
  const BaiTap03({super.key});

  @override
  State<BaiTap03> createState() => _BaiTap03State();
}

class _BaiTap03State extends State<BaiTap03> {
  String selectedMood = 'Chưa chọn';
  String selectedEmoji = '🤔';

  void selectMood(String mood, String emoji) {
    setState(() {
      selectedMood = mood;
      selectedEmoji = emoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tâm trạng hôm nay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Text(
              'Hôm nay bạn cảm thấy thế nào?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Hãy chọn trạng thái phù hợp với bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            // Hàng chọn tâm trạng
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                moodButton('Vui vẻ', '😄'),
                moodButton('Bình thường', '😐'),
                moodButton('Buồn', '😢'),
                moodButton('Tức giận', '😡'),
                moodButton('Mệt mỏi', '😴'),
              ],
            ),

            const SizedBox(height: 50),

            // Hiển thị tâm trạng đã chọn
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.pink,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Trạng thái của bạn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    selectedEmoji,
                    style: const TextStyle(
                      fontSize: 80,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    selectedMood,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Ghi chú về ngày hôm nay',
                hintText: 'Hôm nay của bạn thế nào?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_note),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Đã lưu trạng thái: $selectedMood $selectedEmoji',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text(
                  'Lưu trạng thái',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget moodButton(String mood, String emoji) {
    bool isSelected = selectedMood == mood;

    return GestureDetector(
      onTap: () {
        selectMood(mood, emoji);
      },
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.pink[100]
                  : Colors.grey[100],
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Colors.pink
                    : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            width: 60,
            child: Text(
              mood,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? Colors.pink
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}