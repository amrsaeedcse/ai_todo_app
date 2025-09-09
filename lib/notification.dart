import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);

  // اطلب الـ permission
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  tz.initializeTimeZones();
}

Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'todo_channel',
    'Todo Reminders',
    description: 'Notifications for todo reminders',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

Future<void> scheduleTodoReminders({
  required DateTime finishTime,
  required String taskName,
}) async {
  final oneHourBefore = finishTime.subtract(const Duration(hours: 1));
  final halfHourBefore = finishTime.subtract(const Duration(minutes: 30));
  final tenMinutesBefore = finishTime.subtract(const Duration(minutes: 10));
  final status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    return;
  }
  // قبل ساعة
  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    "⏰ Reminder: $taskName",
    "The task is in 1 hour! 🔔",
    tz.TZDateTime.from(oneHourBefore, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_channel',
        'Todo Reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  // قبل نص ساعة
  await flutterLocalNotificationsPlugin.zonedSchedule(
    2,
    "⏰ Reminder: $taskName",
    "The task is in 30 minutes! 🔔",
    tz.TZDateTime.from(halfHourBefore, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_channel',
        'Todo Reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  // قبل 10 دقايق
  await flutterLocalNotificationsPlugin.zonedSchedule(
    3,
    "⏰ Reminder: $taskName",
    "The task is in 10 minutes! 🔔",
    tz.TZDateTime.from(tenMinutesBefore, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'todo_channel',
        'Todo Reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<bool> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  return status == PermissionStatus.granted;
}
