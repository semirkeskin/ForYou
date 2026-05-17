import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/love_ping.dart';
import '../models/special_hour_message.dart';

/// Lokal bildirim planlayicisi.
///
/// Iki tur bildirim destekler:
/// 1. **Special Hours** (saat=dakika, 10:10 ... 02:02 — 17 zaman).
///    Hepsi ayni "ortak metin" gosterir. ID: 0-23.
/// 2. **Love Pings** (gunluk belli saatlerde ozlem/sevgi mesajlari).
///    Her birinin kendi title + body'si var. ID: 100+.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _specialChannelId = 'kiraz_special_hours';
  static const String _specialChannelName = 'Özel Anlar';
  static const String _specialChannelDesc =
      'Saat ve dakika eşleştiğinde gelen küçük hatırlatmalar (10:10, 11:11).';

  static const String _loveChannelId = 'kiraz_love_pings';
  static const String _loveChannelName = 'Sevgi Notları';
  static const String _loveChannelDesc =
      'Belirli saatlerde gelen kısa sevgi ve özlem mesajları.';

  /// 10:10'dan 02:02'ye kadar gun icinde takip edilen eslesmeler.
  static const List<int> hoursThatMatchMinute = [
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2,
  ];

  static const int _lovePingIdBase = 100;

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

  /// Tum bildirimleri (special hours + love pings) topluca planlar.
  /// Her cagrida cancelAll yapip yeniden kurar.
  static Future<void> scheduleAll({
    required SpecialHourMessage specialHour,
    required List<LovePing> lovePings,
  }) async {
    if (!_initialized) {
      await init();
    }
    await _plugin.cancelAll();
    await _scheduleSpecialHours(specialHour);
    await _scheduleLovePings(lovePings);
  }

  static Future<void> _scheduleSpecialHours(
      SpecialHourMessage message) async {
    if (message.isEmpty) return;

    final notifTitle =
        message.title.isNotEmpty ? message.title : 'Kiraz 🍒';
    final notifBody = message.body;

    for (final h in hoursThatMatchMinute) {
      final firstFire = _nextOccurrence(h, h);
      await _plugin.zonedSchedule(
        h, // ID: 0-23
        notifTitle,
        notifBody,
        firstFire,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _specialChannelId,
            _specialChannelName,
            channelDescription: _specialChannelDesc,
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

  static Future<void> _scheduleLovePings(List<LovePing> pings) async {
    for (final ping in pings) {
      if (ping.isEmpty) continue;
      final firstFire = _nextOccurrence(ping.hour, ping.minute);
      await _plugin.zonedSchedule(
        _lovePingIdBase + ping.id, // ID: 101+, 102+ ...
        ping.title.isNotEmpty ? ping.title : 'Kiraz 🍒',
        ping.body,
        firstFire,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _loveChannelId,
            _loveChannelName,
            channelDescription: _loveChannelDesc,
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
        payload: 'love_ping:${ping.id}',
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
