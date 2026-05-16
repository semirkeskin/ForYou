import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/surprise_box.dart';
import '../../../shared/widgets/soft_card.dart';

const Map<int, _BoxPalette> _kBoxPalettes = {
  1: _BoxPalette(Color(0xFFFBD5D5), Color(0xFFE07B7B)), // soft pink (kotu gun)
  2: _BoxPalette(Color(0xFFDCE7FA), Color(0xFF6C8CC4)), // soft blue (uyku)
  3: _BoxPalette(Color(0xFFF6D8F0), Color(0xFFB07AB0)), // soft lilac (ozlem)
  4: _BoxPalette(Color(0xFFFCE6C2), Color(0xFFC68A36)), // soft amber (sirlar)
};

const _BoxPalette _kDefault = _BoxPalette(Color(0xFFF6C7D5), AppColors.primary);

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({
    super.key,
    required this.box,
    required this.onTap,
  });

  final SurpriseBox box;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _kBoxPalettes[box.id] ?? _kDefault;
    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: palette.foreground,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(box.title, style: AppTextStyles.titleMedium),
                if (box.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(box.subtitle, style: AppTextStyles.bodyMuted),
                ],
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.mutedText,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _BoxPalette {
  const _BoxPalette(this.background, this.foreground);
  final Color background;
  final Color foreground;
}
