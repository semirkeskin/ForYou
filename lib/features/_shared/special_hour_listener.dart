import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/special_hour_message.dart';
import '../../data/services/notification_service.dart';
import 'special_hour_popup.dart';

/// Root-level widget. Her 20 saniyede saat:dakika kontrol eder; eslesme
/// yakalandiginda (ayni dakikada bir defa) [SpecialHourPopup] acar.
///
/// Uygulama on plandayken sistem bildirimi de gelir, ama popup daha
/// dramatik. Ikisi de gozukur — bildirim arka plandayken esas gorev,
/// popup on plandayken ek vurgu.
class SpecialHourListener extends StatefulWidget {
  const SpecialHourListener({
    super.key,
    required this.message,
    required this.child,
  });

  final SpecialHourMessage message;
  final Widget child;

  @override
  State<SpecialHourListener> createState() => _SpecialHourListenerState();
}

class _SpecialHourListenerState extends State<SpecialHourListener>
    with WidgetsBindingObserver {
  Timer? _timer;
  // Ayni dakikada birden fazla popup acmamak icin son tetiklenen "HH:MM".
  String? _lastTriggeredKey;
  // Eslesmenin gercek anini tutmak icin (popup'ta gosterilen saat).
  DateTime? _lastTriggeredAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNow();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => _checkNow());
  }

  @override
  void didUpdateWidget(covariant SpecialHourListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mesaj guncellenirse listener calismaya devam etsin.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Uygulama tekrar on plana gelince hemen kontrol et.
      _checkNow();
    }
  }

  void _checkNow() {
    if (widget.message.isEmpty) return;
    final now = DateTime.now();
    if (!NotificationService.isSpecialMatch(now)) return;

    String pad(int v) => v.toString().padLeft(2, '0');
    final key = '${pad(now.hour)}:${pad(now.minute)}-${now.day}';
    if (key == _lastTriggeredKey) return;
    _lastTriggeredKey = key;
    _lastTriggeredAt = now;

    // Build sonrasi dialog ac.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SpecialHourPopup.show(
        context,
        message: widget.message,
        matchedTime: _lastTriggeredAt ?? now,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
