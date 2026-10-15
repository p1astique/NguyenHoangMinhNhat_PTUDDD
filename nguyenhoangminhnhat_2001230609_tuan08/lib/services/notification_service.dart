import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(settings: settings);
  }

  Future<void> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  NotificationDetails _details(String channelId, String channelName) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Thông báo nhắc nhở học tập',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> remindStudyNow() async {
    await _plugin.show(
      id: 100,
      title: 'Nhắc học ngoại ngữ',
      body: 'Bạn đã học 5 từ mới hôm nay chưa?',
      notificationDetails: _details('study_channel', 'Học ngoại ngữ'),
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required Duration delay,
    required String title,
    required String body,
    required String channelId,
  }) async {
    final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: _details(channelId, title),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Thông báo ngay khi người dùng thêm lịch công việc.
  Future<void> notifyTodoSaved({required int id, required String title}) async {
    await _plugin.show(
      id: id,
      title: 'Đã thêm lịch công việc',
      body: 'Đã lưu lịch cho công việc: $title',
      notificationDetails: _details(
        'todo_saved_channel',
        'Thông báo lưu công việc',
      ),
    );
  }

  // Đặt lịch nhắc công việc theo ngày giờ người dùng chọn.
  Future<void> scheduleTodoReminder({
    required int id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    final notificationTime = tz.TZDateTime.from(scheduledTime, tz.local);

    if (!notificationTime.isAfter(tz.TZDateTime.now(tz.local))) {
      throw ArgumentError('Thời gian nhắc phải ở tương lai');
    }

    await _plugin.zonedSchedule(
      id: id,
      title: 'Đến giờ thực hiện công việc',
      body: 'Đã đến giờ: $title',
      scheduledDate: notificationTime,
      notificationDetails: _details(
        'todo_reminder_channel',
        'Nhắc lịch công việc',
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Hủy thông báo đã lên lịch theo ID
  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id: id);
  }

  // Thông báo tức thì cho Bài 04.
  Future<void> showVocabularyNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details('vocabulary_channel', 'Học từ vựng'),
    );
  }

  // Lấy danh sách ID thông báo đang chờ.
  Future<Set<int>> pendingNotificationIds() async {
    final requests = await _plugin.pendingNotificationRequests();
    return requests.map((request) => request.id).toSet();
  }

  // Thông báo số lượng nhiệm vụ đã hoàn thành.
  Future<void> notifyCompletedTasks(int completedCount) async {
    await _plugin.show(
      id: 9000,
      title: 'Hoàn thành nhiệm vụ',
      body: 'Bạn đã hoàn thành $completedCount nhiệm vụ!',
      notificationDetails: _details(
        'homework_completed_channel',
        'Nhiệm vụ hoàn thành',
      ),
    );
  }
}
