# AI Editöre Verilecek Uygulama Promptu

Sen profesyonel bir Flutter geliştiricisisin. Android tablet için kişiye özel, romantik, offline çalışan bir hediye uygulaması geliştireceksin.

Proje adı: Sana Sakladıklarım

Bu uygulama bir reminder, görev takip, takvim veya klasik not uygulaması değildir. Kız arkadaşıma özel hazırlanacak, Android tablette APK olarak çalışacak, modern ve tatlı bir dijital hediye uygulamasıdır.

Uygulama Play Store’a yayınlanmayacak. Sadece APK olarak kurulacak. İnternet, login, Firebase, backend, cloud sync veya kullanıcı hesabı istemiyorum. Tüm içerikler local JSON ve local assets üzerinden çalışmalı.

Önce çalışan bir MVP oluştur. Kodları tek dosyaya yığma. Temiz, modüler ve genişletilebilir bir Flutter klasör yapısı kullan.

## Kullanılacak teknoloji

- Flutter
- Dart
- Local JSON assets
- SharedPreferences
- Local image assets
- Google Fonts kullanılabilir
- Audio desteği için ileride genişletilebilir yapı hazırlanabilir ama ilk sürümde audio şart değil

## SDK ve sürüm gereksinimleri

- Flutter stable kanal ≥ 3.24
- Dart ≥ 3.5
- `minSdkVersion = 24` (Android 7.0)
- `targetSdkVersion = 34`
- `compileSdkVersion = 34`

## Paket listesi

`pubspec.yaml` içine eklenecek paketler:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.3.0
  google_fonts: ^6.2.0
  package_info_plus: ^8.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.14.0
  flutter_native_splash: ^2.4.0
```

Kullanılmayacak (açıkça yasak):

- `provider`, `riverpod`, `flutter_bloc` veya benzeri state management paketleri
- `go_router` veya başka navigation paketi
- `just_audio` veya başka audio paketi (ilk sürümde)
- Firebase, Hive, Drift, SQLite, ağ paketleri

State management için sadece `setState` + `StatefulWidget` kullanılacak.
Navigation için sadece `Navigator.push` + `MaterialPageRoute` kullanılacak.

## Uygulama bölümleri

1. IntroScreen
2. HomeScreen
3. DailyNoteScreen
4. LoveReasonsScreen
5. MemoriesScreen
6. MemoryDetailScreen
7. SurpriseBoxesScreen
8. SurpriseBoxDetailScreen
9. MissMeScreen
10. CountdownScreen
11. Minimal SettingsScreen

## Tasarım hedefi

- Tatlı ama çocukça değil
- Romantik ama cringe değil
- Modern ve sade
- Premium hissiyatlı
- Pastel pembe, krem, lavanta tonları
- Yuvarlak köşeler
- Soft shadow
- Yumuşak animasyonlar
- Tablet ekranına uyumlu responsive layout
- Çok fazla kalp, aşırı kırmızı ve abartılı romantik görsel kullanma

## Renk paleti

- Background: #FFF7F2
- Card: #FFFFFF
- Primary: #EFA3B8
- Secondary: #B9A7E8
- Text: #3A2D32
- Muted Text: #8A7B82
- Accent: #F6C7D5
- Soft Yellow: #FFE8A3

Uygulamanın genel hissi şu olmalı:

> Modern bir dijital aşk kutusu. Tatlı ama abartılı değil. Romantik ama sade. Sadece ona özel hazırlanmış gibi.

## Önerilen klasör yapısı

```text
lib/
  main.dart
  app.dart

  core/
    theme/
      app_colors.dart
      app_text_styles.dart
      app_theme.dart
    constants/
      asset_paths.dart
    utils/
      app_date_utils.dart

  data/
    models/
      daily_note.dart
      love_reason.dart
      memory_item.dart
      surprise_box.dart
      miss_me_message.dart
      app_config.dart
    services/
      local_json_service.dart
      preferences_service.dart

  features/
    intro/
      intro_screen.dart

    home/
      home_screen.dart
      widgets/
        home_card.dart
        greeting_header.dart

    daily_note/
      daily_note_screen.dart

    love_reasons/
      love_reasons_screen.dart
      widgets/
        love_reason_card.dart

    memories/
      memories_screen.dart
      memory_detail_screen.dart
      widgets/
        memory_card.dart

    surprise_boxes/
      surprise_boxes_screen.dart
      surprise_box_detail_screen.dart
      widgets/
        surprise_box_card.dart

    miss_me/
      miss_me_screen.dart
      widgets/
        miss_me_card.dart
        audio_message_card.dart

    countdown/
      countdown_screen.dart

    settings/
      settings_screen.dart

  shared/
    widgets/
      soft_card.dart
      primary_button.dart
      page_header.dart
      animated_fade_slide.dart
```

## Assets yapısı

```text
assets/
  data/
    daily_notes.json
    love_reasons.json
    surprise_boxes.json
    memories.json
    miss_me_messages.json
    app_config.json

  images/
    memories/
      memory_01.jpg
      memory_02.jpg
      memory_03.jpg

  audio/
```

`pubspec.yaml` içine bu assets yollarını ekle.

## IntroScreen

- Uygulama ilk açıldığında intro gösterilecek.
- Intro metni:

```text
Bu uygulama internette yok.
Play Store’da yok.
Başka kimsede yok.

Çünkü sadece senin için yapıldı.
```

- Altında “Başla” butonu olacak.
- Kullanıcı Başla’ya basınca SharedPreferences ile `intro_seen` true yapılacak.
- Sonraki açılışlarda intro tekrar gösterilmeyecek, direkt HomeScreen açılacak.

## HomeScreen

- Üstte şu metin olacak:

```text
Hoş geldin sevgilim 🌙
```

- Altında:

```text
Bugün de seni düşündüm.
```

- Ana bölüm kartları:
  - Bugünün Notu
  - Seni Sevme Sebeplerim
  - Anılarımız
  - Sürpriz Kutuları
  - Beni Özlediğinde
  - Geri Sayım

- Kartlar yuvarlak köşeli, pastel renkli, ikonlu ve soft animasyonlu olacak.
- Tablet ekranında grid layout güzel görünmeli.

## DailyNoteScreen

- `assets/data/daily_notes.json` dosyasından mesajları oku.
- Her gün aynı notu gösterecek deterministik bir seçim yap.
- Aynı gün içinde uygulama kapatılıp açılsa da aynı mesaj görünmeli.
- Ertesi gün farklı not seçilebilir.
- Mesajı büyük, okunabilir ve soft card içinde göster.

Seçim algoritması (aynen uygula):

```dart
final epoch = DateTime.utc(2025, 1, 1);
final gun = DateTime.now().toUtc().difference(epoch).inDays;
final index = gun % notes.length;
final secilen = notes[index];
```

UTC üzerinden hesapla. Liste sonuna gelinince başa sar.

`daily_notes.json` örneği:

```json
[
  {
    "id": 1,
    "text": "Bugün biraz yorulmuş olabilirsin ama bilmeni istiyorum, ben seninle gurur duyuyorum."
  },
  {
    "id": 2,
    "text": "Senin gülüşün bazen bütün günümü düzeltiyor."
  }
]
```

## LoveReasonsScreen

- `assets/data/love_reasons.json` dosyasından sevgi sebeplerini oku.
- “Bir sebep aç” butonu olacak.
- Butona basınca rastgele bir sebep animasyonlu kart olarak gösterilecek.
- Aynı mesajın sürekli üst üste gelmemesine dikkat et.

Tekrar etmeme kuralı:

- SharedPreferences'ta `recent_love_reason_ids` anahtarıyla son **3 ID** FIFO listede tutulur.
- Yeni sebep seçilirken bu listedeki ID'ler hariç tutulur; geri kalanlardan random seçim yapılır.
- Toplam sebep sayısı 3'ten az ise sadece en son gösterilen ID hariç tutulur.
- Gösterim sonrası en eski ID listeden düşer, yeni ID eklenir.

`love_reasons.json` örneği:

```json
[
  {
    "id": 1,
    "text": "Çünkü en basit anları bile güzel hale getiriyorsun."
  },
  {
    "id": 2,
    "text": "Çünkü yanında kendim gibi hissediyorum."
  }
]
```

## MemoriesScreen

- `assets/data/memories.json` dosyasından anıları oku.
- Anıları grid layout ile göster.
- Her kartta fotoğraf, başlık ve kısa açıklama olacak.
- Karta tıklayınca MemoryDetailScreen açılacak.
- Detayda fotoğraf büyük görünsün, altında başlık, tarih ve açıklama olsun.
- Fotoğraflar local assets üzerinden yüklenecek.

`memories.json` örneği:

```json
[
  {
    "id": 1,
    "title": "İlk kahvemiz",
    "date": "2025-10-12",
    "description": "O gün sen fark etmeden sana uzun uzun bakmıştım.",
    "image": "assets/images/memories/memory_01.jpg"
  }
]
```

## SurpriseBoxesScreen

- `assets/data/surprise_boxes.json` dosyasından kutuları oku.
- Kart başlıkları şu tarzda olabilir:
  - Kötü bir gününde aç
  - Beni özlediğinde aç
  - Kendini güzel hissetmediğinde aç
  - Uyuyamıyorsan aç
  - Çok yorulduysan aç
- Eğer `requiresConfirmation` true ise kutu açılmadan önce confirmation modal göster.
- Modal metni:

```text
Bunu gerçekten şimdi açmak istiyor musun?
```

- Onaydan sonra SurpriseBoxDetailScreen içinde mesajı göster.
- Mesaj ekranı duygusal, sade ve okunabilir olsun.

`surprise_boxes.json` örneği:

```json
[
  {
    "id": 1,
    "title": "Kötü bir gününde aç",
    "subtitle": "Bugün biraz ağır geldiyse buradayım.",
    "message": "Bugün her şey üst üste gelmiş olabilir. Ama sen hâlâ çok değerlisin. Ben senin en yorgun halini de seviyorum.",
    "requiresConfirmation": true
  },
  {
    "id": 2,
    "title": "Beni özlediğinde aç",
    "subtitle": "Biraz yanındaymışım gibi.",
    "message": "Şu an yanında olamasam da kalbimin en güzel yeri sende.",
    "requiresConfirmation": false
  }
]
```

## MissMeScreen

- `assets/data/miss_me_messages.json` dosyasından özel mesajları oku.
- Kart başlıkları:
  - Beni özlediğinde oku
  - Uyumadan önce oku
  - Sarılmaya ihtiyacın varsa oku
  - Moralin bozuksa oku
  - Kendini yalnız hissedersen oku
- Karta tıklayınca mesaj detayını göster.
- İlk sürümde yazılı mesajlar yeterli.
- Modelde audio alanı bulunsun. JSON içinde audio varsa ileride audio player gösterilebilecek altyapı hazırlanmalı ama şu an audio zorunlu değil.

Audio davranışı (MVP):

- `MissMeMessage` modelinde `String? audio` alanı nullable olarak bulunsun.
- `MissMeCard` widget'ı `audio != null` ise küçük 🔇 ikonu göstersin.
- İkona basıldığında snackbar çıksın: *"Sesli mesaj sonraki güncellemede"*.
- `pubspec.yaml`'a boş `assets/audio/` klasörü tanımla.
- `just_audio` paketi **eklenmeyecek**.

`miss_me_messages.json` örneği:

```json
[
  {
    "id": 1,
    "title": "Beni özlediğinde oku",
    "message": "Şu an yanında olamasam da kalbimin en güzel yeri sende.",
    "audio": null
  },
  {
    "id": 2,
    "title": "Uyumadan önce oku",
    "message": "Gözlerini kapatmadan önce bilmeni istiyorum: seni çok seviyorum.",
    "audio": null
  }
]
```

## CountdownScreen

- `assets/data/app_config.json` içinden `countdownTitle` ve `targetDate` değerlerini oku.
- Hedef tarihe kalan gün, saat ve dakika değerlerini göster.
- Timer ile canlı güncellensin.
- Eğer hedef tarih geçtiyse “Bugün o özel gün 💛” mesajı göster.
- Tasarımı büyük, temiz ve duygusal olsun.

`app_config.json` örneği:

```json
{
  "appName": "Sana Sakladıklarım",
  "greetingName": "Sevgilim",
  "countdownTitle": "Bir sonraki buluşmamıza",
  "targetDate": "2026-06-20T18:00:00"
}
```

## SettingsScreen

Minimal bir ayarlar ekranı. HomeScreen'in sağ üst köşesindeki küçük ikondan açılır.

İçerik (sırayla):

1. **"Tanıtım ekranını tekrar göster"** butonu — basıldığında SharedPreferences'taki `intro_seen` değerini `false` yapar. Kısa bir onay snackbar göster.
2. **Geri sayım hedef tarihi** — `app_config.json`'dan okunan `countdownTitle` ve `targetDate` salt okunur olarak gösterilir. Altında küçük not metni:

```text
Değiştirmek için uygulama dosyalarındaki app_config.json düzenlenmelidir.
```

3. **Uygulama versiyonu** — `package_info_plus` paketi ile okunup gösterilir (örnek: "Versiyon 1.0.0").
4. **"Sana özel hazırlandı"** — sayfanın altında küçük, soft renkli imza satırı.

Kurallar:

- Tema seçimi, dil seçimi, bildirim ayarı **yok**.
- Hedef tarihi değiştirme arayüzü **yok** (dosya üzerinden).
- Yalnızca `intro_seen` yazma izinli.

## Shared widgets

- SoftCard
- PrimaryButton
- PageHeader
- AnimatedFadeSlide
- HomeCard

## Kod kalitesi

- Kodları modüler tut.
- Tek dosyaya büyük UI yığma.
- Model class’ları ayrı olsun.
- JSON okuma servisi ayrı olsun.
- Preferences servisi ayrı olsun.
- Tema renkleri hardcoded dağınık şekilde kullanılmasın, AppColors içinden gelsin.
- Hata durumlarında uygulama crash etmesin.
- JSON okunamazsa kullanıcıya güzel bir boş durum mesajı gösterilsin.

## Kabul kriterleri

1. Uygulama Android tablette çalışmalı.
2. Uygulama internet olmadan çalışmalı.
3. İlk açılışta intro görünmeli.
4. Intro sonraki açılışlarda görünmemeli.
5. HomeScreen kartları doğru sayfalara gitmeli.
6. Daily note JSON’dan okunmalı ve gün bazlı sabit kalmalı.
7. Love reasons rastgele çalışmalı.
8. Memories bölümü fotoğrafları ve detayları göstermeli.
9. Surprise boxes confirmation modal ve detay ekranıyla çalışmalı.
10. MissMeScreen özel mesajları göstermeli.
11. Countdown doğru hesaplanmalı.
12. Uygulama tablet ekranına uyumlu olmalı.
13. Tasarım modern, tatlı, sade ve kişisel görünmeli.
14. APK build alınabilecek durumda olmalı.

## Önemli kısıtlar

- Firebase ekleme.
- Backend ekleme.
- Login sistemi ekleme.
- İnternet bağlantısına bağlı özellik ekleme.
- Gereksiz karmaşık state management kullanma.
- Çok ağır animasyonlar kullanma.
- Uygulamayı teknik demo gibi gösterme.
- Cringe, aşırı kırmızı, aşırı kalpli tasarım yapma.
- **Dark mode ekleme.** Sadece light tema. `ThemeMode.light` ile kilitle.
- Provider / Riverpod / Bloc / go_router / just_audio gibi paketleri **ekleme**.
- Fotoğraflar 400 KB / 1600 px üst sınırını geçmesin (içerik üreten kullanıcıya not olarak README'ye yaz).
- Sadece şu iki unit test dosyası yazılacak, daha fazlası değil:
  - `test/local_json_service_test.dart` — JSON parse hataları ve boş/eksik dosya durumu
  - `test/app_date_utils_test.dart` — geri sayım hesaplama ve günlük not seçim algoritması
- Widget test, integration test ve golden test **yazma**.
- `MediaQuery.textScaler` clamp et: max 1.3. Daha büyüğüne layout dayanmıyor.
- Ana butonlara ve kart başlıklarına `Semantics` label ekle (TalkBack desteği).

Önce projeyi bu yapıya göre oluştur. Sonra çalışan MVP’yi tamamla. Gerekli örnek JSON dosyalarını da oluştur. Fotoğraflar için placeholder asset kullanabilirsin, ama yapı gerçek fotoğraflar eklenecek şekilde hazır olsun.
