import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/soft_card.dart';

class LoveReasonCard extends StatelessWidget {
  const LoveReasonCard({
    super.key,
    required this.text,
    this.onShuffle,
  });

  final String text;
  final VoidCallback? onShuffle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      child: SoftCard(
        padding: const EdgeInsets.fromLTRB(28, 24, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
                if (onShuffle != null)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.mutedText,
                    iconSize: 22,
                    tooltip: 'Yenile',
                    onPressed: onShuffle,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    text,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 19,
                      height: 1.65,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
