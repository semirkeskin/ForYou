import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana_sakladiklarim/data/services/local_json_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalJsonService service;
  final knownAssetKeys = <String>{};

  setUp(() {
    service = const LocalJsonService();
  });

  tearDown(() {
    // rootBundle CachingAssetBundle — testler arasi cache temizlenmeli.
    for (final key in knownAssetKeys) {
      rootBundle.evict(key);
    }
    knownAssetKeys.clear();
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  void mockAsset(String key, String body) {
    knownAssetKeys.add(key);
    rootBundle.evict(key);
    TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final requested = utf8.decode(message!.buffer.asUint8List());
      if (requested == key) {
        final bytes = utf8.encode(body);
        return ByteData.view(Uint8List.fromList(bytes).buffer);
      }
      return null;
    });
  }

  group('LocalJsonService.loadAppConfig', () {
    test('gecerli JSON ile alanlari parse eder', () async {
      mockAsset(
        'assets/data/app_config.json',
        '{"appName":"X","greetingName":"Y","countdownTitle":"Z",'
            '"targetDate":"2026-06-20T18:00:00"}',
      );
      final config = await service.loadAppConfig();
      expect(config.appName, 'X');
      expect(config.greetingName, 'Y');
      expect(config.countdownTitle, 'Z');
      expect(config.targetDate, DateTime.parse('2026-06-20T18:00:00'));
    });

    test('bozuk JSON FormatException firlatir', () async {
      mockAsset('assets/data/app_config.json', '{not json');
      await expectLater(service.loadAppConfig(), throwsFormatException);
    });
  });

  group('LocalJsonService.loadDailyNotes', () {
    test('liste parse eder', () async {
      mockAsset(
        'assets/data/daily_notes.json',
        '[{"id":1,"text":"a"},{"id":2,"text":"b"}]',
      );
      final notes = await service.loadDailyNotes();
      expect(notes, hasLength(2));
      expect(notes.first.id, 1);
      expect(notes.first.text, 'a');
    });

    test('bos liste icin bos sonuc doner', () async {
      mockAsset('assets/data/daily_notes.json', '[]');
      final notes = await service.loadDailyNotes();
      expect(notes, isEmpty);
    });
  });

  group('LocalJsonService.loadMissMeMessages', () {
    test('audio alani null olabilir ve messages parse edilir', () async {
      mockAsset(
        'assets/data/miss_me_messages.json',
        '[{"id":1,"title":"t","messages":["a","b"],"audio":null}]',
      );
      final list = await service.loadMissMeMessages();
      expect(list.first.audio, isNull);
      expect(list.first.messages, ['a', 'b']);
    });

    test('eski message alanı (string) geriye uyumlu', () async {
      mockAsset(
        'assets/data/miss_me_messages.json',
        '[{"id":1,"title":"t","message":"tek mesaj","audio":null}]',
      );
      final list = await service.loadMissMeMessages();
      expect(list.first.messages, ['tek mesaj']);
    });
  });
}
