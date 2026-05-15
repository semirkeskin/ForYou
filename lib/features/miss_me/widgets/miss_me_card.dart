import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/miss_me_message.dart';
import '../../../shared/widgets/soft_card.dart';

class MissMeCard extends StatelessWidget {
  const MissMeCard({
    super.key,
    required this.message,
    required this.onTap,
    required this.onAudioTap,
  });

  final MissMeMessage message;
  final VoidCallback onTap;
  final VoidCallback onAudioTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(22, 22, 18, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softYellow.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message.title,
              style: AppTextStyles.titleMedium,
            ),
          ),
          if (message.audio != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Semantics(
                label: 'Sesli mesaj',
                button: true,
                child: IconButton(
                  icon: const Icon(
                    Icons.volume_off_rounded,
                    color: AppColors.mutedText,
                  ),
                  tooltip: 'Sesli mesaj sonraki güncellemede',
                  onPressed: onAudioTap,
                ),
              ),
            ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
        ],
      ),
    );
  }
}
