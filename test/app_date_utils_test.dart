import 'package:flutter_test/flutter_test.dart';
import 'package:sana_sakladiklarim/core/utils/app_date_utils.dart';

void main() {
  group('AppDateUtils.daysSinceEpoch', () {
    test('epoch tarihinde 0 doner', () {
      expect(AppDateUtils.daysSinceEpoch(DateTime.utc(2025, 1, 1)), 0);
    });

    test('bir gun sonra 1 doner', () {
      expect(AppDateUtils.daysSinceEpoch(DateTime.utc(2025, 1, 2)), 1);
    });

    test('UTC olmayan tarih dogru sayilir', () {
      final local = DateTime(2025, 1, 2, 12);
      expect(AppDateUtils.daysSinceEpoch(local), greaterThanOrEqualTo(1));
    });
  });

  group('AppDateUtils.dailyIndex', () {
    test('bos liste icin 0 doner', () {
      expect(AppDateUtils.dailyIndex(0), 0);
    });

    test('tek elemanli liste icin 0 doner', () {
      expect(AppDateUtils.dailyIndex(1, DateTime.utc(2025, 5, 15)), 0);
    });

    test('liste boyu mod uygular', () {
      expect(AppDateUtils.dailyIndex(5, DateTime.utc(2025, 1, 1)), 0);
      expect(AppDateUtils.dailyIndex(5, DateTime.utc(2025, 1, 6)), 0);
      expect(AppDateUtils.dailyIndex(5, DateTime.utc(2025, 1, 4)), 3);
    });

    test('ayni gun icinde ayni index doner', () {
      final morning = DateTime.utc(2025, 6, 15, 6);
      final evening = DateTime.utc(2025, 6, 15, 22);
      expect(
        AppDateUtils.dailyIndex(10, morning),
        AppDateUtils.dailyIndex(10, evening),
      );
    });
  });

  group('AppDateUtils.remaining', () {
    test('gelecek tarihte pozitif', () {
      final now = DateTime.utc(2025, 1, 1);
      final target = DateTime.utc(2025, 1, 5);
      expect(AppDateUtils.remaining(target, now).inDays, 4);
    });

    test('gecmis tarihte negatif', () {
      final now = DateTime.utc(2025, 1, 10);
      final target = DateTime.utc(2025, 1, 5);
      expect(AppDateUtils.remaining(target, now).isNegative, isTrue);
    });
  });
}
