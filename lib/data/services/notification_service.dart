import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/special_hour_message.dart';

/// Saat-dakika eslesmesi anlarinda (10:10, 11:11, ..., 23:23, 00:00, 01:01,
/// 02:02 → toplam 17 zaman) gunluk tekrarlanan bildirim planlayicisi.
///
/// Android: flutter_local_notifications + zonedSchedule + matchDateTimeComponents.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'kiraz_special_hours';
  static const String _channelName = 'Özel Anlar';
  static const String _channelDesc =
      'Saat ve dakika eşleştiğinde gelen küçük hatırlatmalar (10:10, 11:11 gibi).';

  /// 10:10'dan 02:02'ye kadar gun icinde tekrarlanan eslesmeler.
  static const List<int> hoursThatMatchMinute = [
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2,
  ];

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    String tzName;
    try {
      tzName = await FlutterTimezone.getLocalTimezone();
    } on Exception {
      tzName = 'Europe/Istanbul';
    }
    tz.setLocalLocation(tz.getLocation(tzName));

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }

    _initialized = true;
  }

  /// Mevcut planlari iptal et + yeni mesaj icin 17 saat bildirimi planla.
  /// [message] bos ise hicbir bildirim planlanmaz (kullanici henuz metin yazmadi).
  static Future<void> scheduleAllSpecialHours(
      SpecialHourMessage message) async {
    if (!_initialized) {
      await init();
    }
    await _plugin.cancelAll();

    if (message.isEmpty) return;

    final notifTitle =
        message.title.isNotEmpty ? message.title : 'Kiraz 🍒';
    final notifBody = message.body;

    for (final h in hoursThatMatchMinute) {
      final firstFire = _nextOccurrence(h, h);
      await _plugin.zonedSchedule(
        h, // unique id (0-23)
        notifTitle,
        notifBody,
        firstFire,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'special_hour:$h',
      );
    }
  }

  /// Bir sonraki [hour]:[minute] saatinde local time'a gore TZDateTime.
  static tz.TZDateTime _nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Saat == dakika ve gun icinde takip ettigimiz saatlerden biri mi?
  static bool isSpecialMatch(DateTime now) {
    return now.hour == now.minute &&
        hoursThatMatchMinute.contains(now.hour);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
