import 'package:flutter/widgets.dart';

/// Cihaz boyutu yardimcilari. Xiaomi Pad 7 (11.2", 3:2) ve diger
/// tablet'lerde 'isTablet' true doner (shortestSide >= 600).
class Responsive {
  Responsive._();

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  /// Tablet icin yatay ic kenar bosluk artisi. Telefonda 24, tablette 40.
  static double horizontalPadding(BuildContext context) {
    return isTablet(context) ? 40 : 24;
  }

  /// Ana icerigin maksimum genisligi — landscape tablet'lerde kenarlardan
  /// fazla dolmasin diye ortalanir.
  static double contentMaxWidth(BuildContext context) {
    if (!isTablet(context)) return double.infinity;
    return 1100;
  }

  /// Tablet'te tipografi olcegi (Material textScaler farkli sebepten dolayi
  /// clamp ediliyor; bu sadece bizim widget'larin manuel buyutmesi icin).
  static double textScale(BuildContext context) {
    return isTablet(context) ? 1.15 : 1.0;
  }

  /// Hero kart yuksekligi. Telefonda 280; tablette landscape modda
  /// daha estetik gorunsun diye height arttirilir ama maxHeight 420.
  static double heroHeight(BuildContext context) {
    if (!isTablet(context)) return 280;
    final width = MediaQuery.of(context).size.width;
    return width >= 1000 ? 420 : 360;
  }
}
