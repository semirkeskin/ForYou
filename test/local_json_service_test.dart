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
        '{"appName":"X","greetingName":"Y",'
            '"secretWord":"Kiraz","secretMeaning":"seni seviyorum"}',
      );
      final config = await service.loadAppConfig();
      expect(config.appName, 'X');
      expect(config.greetingName, 'Y');
      expect(config.secretWord, 'Kiraz');
      expect(config.secretMeaning, 'seni seviyorum');
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

  group('LocalJsonService.loadSurpriseBoxes', () {
    test('messages listesi parse edilir', () async {
      mockAsset(
        'assets/data/surprise_boxes.json',
        '[{"id":1,"title":"t","subtitle":"s","messages":["a","b"],'
            '"requiresConfirmation":false}]',
      );
      final list = await service.loadSurpriseBoxes();
      expect(list.first.messages, ['a', 'b']);
      expect(list.first.requiresConfirmation, isFalse);
    });

    test('eski message alanı (string) geriye uyumlu', () async {
      mockAsset(
        'assets/data/surprise_boxes.json',
        '[{"id":1,"title":"t","subtitle":"s","message":"tek mesaj",'
            '"requiresConfirmation":true}]',
      );
      final list = await service.loadSurpriseBoxes();
      expect(list.first.messages, ['tek mesaj']);
      expect(list.first.requiresConfirmation, isTrue);
    });
  });
}
