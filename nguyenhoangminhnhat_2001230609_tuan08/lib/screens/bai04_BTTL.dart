
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/vocabulary.dart';
import '../services/vocabulary_file_service.dart';
import '../services/notification_service.dart';

class Bai04BTTL extends StatefulWidget {
  const Bai04BTTL({super.key});

  @override
  State<Bai04BTTL> createState() => _Bai04BTTLState();
}

class _Bai04BTTLState extends State<Bai04BTTL> {
  final fileService = VocabularyFileService();
  final notifications = NotificationService.instance;

  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final answerController = TextEditingController();

  List<Vocabulary> words = [];
  Set<int> pendingIds = {};

  int page = 0;
  int studyIndex = 0;
  int studyCorrect = 0;
  int studyWrong = 0;

  int quizIndex = 0;
  int quizCorrect = 0;
  int quizWrong = 0;
  List<bool> quizPairsAreCorrect = [];

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    try {
      final data = await fileService.load();
      if (!mounted) return;
      setState(() {
        words = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      message('Không thể đọc dữ liệu: $e');
    }
  }

  void message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> selectPage(int selected) async {
    Navigator.of(context).pop();

    if (selected == 3) {
      try {
        pendingIds = await notifications.pendingNotificationIds();
      } catch (e) {
        message('Không thể đọc lịch nhắc: $e');
      }
    }

    if (!mounted) return;
    setState(() => page = selected);
  }

  Future<void> saveWord() async {
    if (saving) return;

    final word = wordController.text.trim();
    final meaning = meaningController.text.trim();

    if (word.isEmpty || meaning.isEmpty) {
      message('Vui lòng nhập từ và nghĩa của từ');
      return;
    }

    setState(() => saving = true);

    final reminderTime = DateTime.now().add(
      const Duration(minutes: 10),
    );

    final id = DateTime.now()
        .microsecondsSinceEpoch
        .remainder(1000000000) + 10000;

    final item = Vocabulary(
      word: word,
      meaning: meaning,
      notificationId: id,
      reminderTime: reminderTime,
    );

    bool scheduled = false;

    try {
      await notifications.requestPermissions();

      await notifications.scheduleReminder(
        id: id,
        delay: const Duration(minutes: 10),
        title: 'Đến giờ ôn tập từ vựng',
        body: 'Hãy ôn lại từ "$word" - $meaning',
        channelId: 'vocabulary_reminder_channel',
      );
      scheduled = true;

      final updated = [...words, item];
      await fileService.save(updated);

      if (!mounted) return;
      setState(() {
        words = updated;
        wordController.clear();
        meaningController.clear();
      });

      try {
        await notifications.showVocabularyNotification(
          id: id + 1,
          title: 'Đã lưu từ vựng',
          body: 'Đã lưu "$word". Hãy ôn tập sau 10 phút!',
        );
      } catch (_) {
        // Dữ liệu và lịch nhắc đã được lưu thành công.
      }

      message('Đã lưu và lên lịch nhắc học sau 10 phút');
    } catch (e) {
      if (scheduled) {
        try {
          await notifications.cancelReminder(id);
        } catch (_) {}
      }
      message('Không thể lưu hoặc đặt lịch: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  String normalize(String text) {
    return text.trim().toLowerCase().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
  }

  Future<void> checkStudy() async {
    if (words.isEmpty) return;

    final item = words[studyIndex % words.length];
    final correct = normalize(answerController.text) ==
        normalize(item.meaning);

    setState(() {
      if (correct) {
        studyCorrect++;
      } else {
        studyWrong++;
      }
    });

    message(
      correct
          ? 'Chính xác!'
          : 'Sai rồi! Đáp án: ${item.meaning}',
    );

    if (!correct && studyWrong % 3 == 0) {
      try {
        await notifications.requestPermissions();
        await notifications.showVocabularyNotification(
          id: 200000000 + studyWrong,
          title: 'Nhắc ôn tập từ vựng',
          body: 'Bạn đã trả lời sai $studyWrong từ. Hãy ôn lại nhé!',
        );
      } catch (e) {
        message('Không thể gửi thông báo: $e');
      }
    }

    if (!mounted) return;
    setState(() {
      studyIndex = (studyIndex + 1) % words.length;
      answerController.clear();
    });
  }

  void startQuiz() {
    final random = Random();
    quizPairsAreCorrect = List.generate(
      words.length,
      (index) => words.length == 1 || random.nextBool(),
    );

    setState(() {
      quizIndex = 0;
      quizCorrect = 0;
      quizWrong = 0;
      page = 2;
    });
  }

  String quizMeaning() {
    if (words.isEmpty) return '';

    final index = quizIndex;
    if (quizPairsAreCorrect[index]) {
      return words[index].meaning;
    }

    // Lấy nghĩa của một từ khác để tạo câu sai.
    return words[(index + 1) % words.length].meaning;
  }

  Future<void> answerQuiz(bool answerIsCorrect) async {
    final actual = quizPairsAreCorrect[quizIndex];

    if (answerIsCorrect == actual) {
      quizCorrect++;
    } else {
      quizWrong++;
    }

    if (quizIndex + 1 == words.length) {
      final total = quizCorrect + quizWrong;
      final percent = total == 0
          ? 0.0
          : quizCorrect * 100 / total;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Kết thúc bài kiểm tra'),
          content: Text(
            'Tổng số câu: $total\n'
            'Đúng: $quizCorrect\n'
            'Sai: $quizWrong\n'
            'Tỷ lệ đúng: ${percent.toStringAsFixed(1)}%',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() => page = 0);
              },
              child: const Text('Thoát'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                startQuiz();
              },
              child: const Text('Làm lại'),
            ),
          ],
        ),
      );
    } else {
      setState(() => quizIndex++);
    }
  }

  Widget counter(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: wordController,
          decoration: const InputDecoration(
            labelText: 'Từ',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: meaningController,
          decoration: const InputDecoration(
            labelText: 'Nghĩa',
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: saving ? null : saveWord,
            child: Text(
              saving
                  ? 'Đang lưu...'
                  : 'Lưu & Nhắc học sau 10 phút',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text('Đã lưu ${words.length} từ vựng'),
        ),
      ],
    );
  }

  Widget studyPage() {
    if (words.isEmpty) {
      return const Center(
        child: Text('Chưa có từ vựng. Hãy thêm từ ở Trang chính.'),
      );
    }

    final item = words[studyIndex % words.length];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              counter('✓ Đúng', studyCorrect, Colors.green),
              counter('✗ Sai', studyWrong, Colors.orange),
            ],
          ),
          const SizedBox(height: 30),
          Card(
            color: Colors.blue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    item.word,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập nghĩa tiếng Việt',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => checkStudy(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: checkStudy,
                    child: const Text('Check'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quizPage() {
    if (words.isEmpty) {
      return const Center(
        child: Text('Chưa có từ vựng để kiểm tra.'),
      );
    }

    if (quizPairsAreCorrect.length != words.length) {
      return Center(
        child: ElevatedButton(
          onPressed: startQuiz,
          child: const Text('Bắt đầu kiểm tra'),
        ),
      );
    }

    final item = words[quizIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              counter('✓ Đúng', quizCorrect, Colors.green),
              counter('✗ Sai', quizWrong, Colors.orange),
            ],
          ),
          const Spacer(),
          Text(
            'Câu ${quizIndex + 1}/${words.length}',
          ),
          const SizedBox(height: 20),
          Text(
            item.word,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            quizMeaning(),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text('Từ và nghĩa trên có khớp nhau không?'),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => answerQuiz(true),
                child: const Text('✓ Đúng'),
              ),
              ElevatedButton(
                onPressed: () => answerQuiz(false),
                child: const Text('✗ Sai'),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget remindersPage() {
    final now = DateTime.now();
    final pending = words.where((item) {
      return item.reminderTime.isAfter(now) &&
          pendingIds.contains(item.notificationId);
    }).toList();

    pending.sort(
      (a, b) => a.reminderTime.compareTo(b.reminderTime),
    );

    if (pending.isEmpty) {
      return const Center(
        child: Text('Không có lịch nhắc đang chờ'),
      );
    }

    return ListView.builder(
      itemCount: pending.length,
      itemBuilder: (context, index) {
        final item = pending[index];
        final date = item.reminderTime;

        final timeText =
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year} '
            '${date.hour.toString().padLeft(2, '0')}:'
            '${date.minute.toString().padLeft(2, '0')}';

        return ListTile(
          leading: const Icon(Icons.notifications_none),
          title: Text(item.word),
          subtitle: Text('${item.meaning}\n$timeText'),
          isThreeLine: true,
          trailing: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: () async {
              try {
                await notifications.cancelReminder(
                  item.notificationId,
                );
                if (!mounted) return;
                setState(() {
                  pendingIds.remove(item.notificationId);
                });
                message('Đã hủy lịch nhắc');
              } catch (e) {
                message('Không thể hủy lịch: $e');
              }
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    wordController.dispose();
    meaningController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const titles = [
      'Ứng dụng học từ vựng',
      'Ôn tập từ mới',
      'Trắc nghiệm Đúng / Sai',
      'Lịch nhắc',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[page]),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Trợ lý học từ vựng'),
              accountEmail: Text('Bài 04 - BTTL'),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.menu_book),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chính'),
              onTap: () => selectPage(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Học từ'),
              onTap: () => selectPage(1),
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Kiểm tra từ'),
              onTap: () {
                Navigator.pop(context);
                startQuiz();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Lịch nhắc'),
              onTap: () => selectPage(3),
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : switch (page) {
              0 => homePage(),
              1 => studyPage(),
              2 => quizPage(),
              _ => remindersPage(),
            },
    );
  }
}
