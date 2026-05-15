import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Tum sayfalarda kullanilacak ortak kiraz dokulu arka plan.
/// Tile (ImageRepeat.repeat) ile her cihazda ayni boyutta gorunur.
class CherryBackdrop extends StatelessWidget {
  const CherryBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: AssetImage('assets/images/decorations/home_pattern.png'),
          repeat: ImageRepeat.repeat,
          alignment: Alignment.topLeft,
        ),
      ),
      child: child,
    );
  }
}
