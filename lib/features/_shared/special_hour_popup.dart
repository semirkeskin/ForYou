import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/special_hour_message.dart';

/// 10:10, 11:11 gibi saat-dakika eslesmesi anlarinda uygulama on planda
/// iken acilan popup. Kullanici manuel kapatir.
class SpecialHourPopup extends StatelessWidget {
  const SpecialHourPopup({
    super.key,
    required this.message,
    required this.matchedTime,
  });

  final SpecialHourMessage message;

  /// Eslesmis saat (Sadece "HH:MM" formatinda gostermek icin).
  final DateTime matchedTime;

  static Future<void> show(
    BuildContext context, {
    required SpecialHourMessage message,
    required DateTime matchedTime,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      barrierDismissible: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: SpecialHourPopup(
          message: message,
          matchedTime: matchedTime,
        ),
      ),
    );
  }

  String _formatTime(DateTime d) {
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${pad(d.hour)}:${pad(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final title = message.title.isNotEmpty ? message.title : 'Kiraz 🍒';
    final body = message.body;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 26, 28, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 30,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Kiraz emoji üst kapsül
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('🍒', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 14),
              // Eşleşmiş saat: minik etiket
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTime(matchedTime),
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (body.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 15.5,
                    height: 1.55,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Tamam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
