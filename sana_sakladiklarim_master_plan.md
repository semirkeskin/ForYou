# Sana Sakladıklarım — Android Tablet Hediye Uygulaması Master Planı

## 1. Proje Özeti

**Uygulama adı:** Sana Sakladıklarım

Bu uygulama, kız arkadaşa özel hazırlanacak romantik, tatlı, modern ve kişisel bir dijital hediye uygulamasıdır.

Uygulama bir reminder, görev takip, takvim veya klasik not uygulaması değildir. Amaç; Android tablette açıldığında özel hissettiren, içinde kişisel mesajlar, anılar, fotoğraflar, sürpriz kutuları, sevgi sebepleri ve özel tarihe geri sayım bulunan offline çalışan bir uygulama oluşturmaktır.

Uygulama Play Store’a yayınlanmayacak. APK olarak Android tablete kurulacak ve sadece ona özel olacak.

---

## 2. Ana Konsept

Uygulamanın genel hissi:

- Tatlı ama çocukça değil
- Romantik ama cringe değil
- Modern ve sade
- Premium görünümlü
- Kişisel ve özel
- Offline çalışan
- Tablet ekranına uygun
- Fotoğraf, mesaj ve anılarla zenginleştirilmiş

Uygulama açıldığında kullanıcı şunu hissetmeli:

> “Bu uygulama sadece benim için yapılmış.”

---

## 3. Teknoloji Seçimi

### Önerilen teknoloji

- Flutter
- Dart
- Local JSON assets
- SharedPreferences
- Local image assets
- Opsiyonel audio support
- Google Fonts
- Flutter animations

### Neden Flutter?

- Android tablet için uygundur.
- APK olarak kolay kurulabilir.
- Offline uygulama yapmak kolaydır.
- Animasyon ve modern UI geliştirmek hızlıdır.
- İleride telefon ekranına da uyarlanabilir.
- Fotoğraf, ses, JSON ve local asset yönetimi kolaydır.

### 3.1 Teknik Karar Defteri

MVP için mühendislik kararları. AI editör bu kararların dışına çıkmamalıdır.

| Konu | Karar | Gerekçe |
|---|---|---|
| State management | `setState` + `StatefulWidget`. Provider / Riverpod / Bloc kullanılmayacak. | 9 ekran, tek kullanıcı, offline. Ek katman gereksiz karmaşıklık. |
| Navigation | `Navigator.push` + `MaterialPageRoute`. `go_router` yok. | Akış lineer, derin link yok. |
| Flutter sürümü | Stable kanal ≥ 3.24 | Material 3 ve modern API'lar. |
| Dart sürümü | ≥ 3.5 | Flutter 3.24 ile uyumlu. |
| `minSdkVersion` | 24 (Android 7.0) | Geniş tablet uyumluluğu. |
| `targetSdkVersion` | 34 | Güncel Play Store standardı, APK kurulumunda da güvenli. |
| `compileSdkVersion` | 34 | targetSdk ile aynı. |
| Test stratejisi | Sadece iki unit test: `local_json_service_test.dart` ve `app_date_utils_test.dart`. Widget/integration testi yok. | Hediye uygulaması; kritik olan JSON parse ve tarih matematiği. |
| Tema | **Light mode only**. Dark mode yok. | Pastel paleti dark'ta korunamaz; bilinçli estetik tercih. |
| Erişilebilirlik hedefi | WCAG AA, `textScaler` max 1.3, ana butonlarda `Semantics` label. | Yaşlı/görme zorluğu hedef kitle değil; ama ucuz iyileştirmeler eklenir. |

### 3.2 Bağımlılıklar

`pubspec.yaml` içine eklenmesi gerekenler:

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

İleride audio desteği için `just_audio` eklenecek; **şu an eklenmiyor**.

---

## 4. Uygulama Kapsamı

İlk sürümde uygulama şu bölümlerden oluşacaktır:

1. Intro Screen
2. Home Screen
3. Bugünün Notu
4. Seni Sevme Sebeplerim
5. Anılarımız
6. Sürpriz Kutuları
7. Beni Özlediğinde
8. Geri Sayım
9. Minimal Settings

---

## 5. MVP Hedefi

İlk versiyonun amacı; çalışan, güzel görünen, offline kullanılabilen ve kişisel içerikleri kolayca değiştirilebilen bir APK oluşturmaktır.

### MVP’de olacaklar

- İlk açılış intro ekranı
- Ana sayfa
- Günlük not sistemi
- Rastgele sevgi sebebi gösterimi
- Fotoğraflı anı galerisi
- Sürpriz kutuları
- Özel mesajlar bölümü
- Geri sayım ekranı
- Local JSON veri sistemi
- Local image assets
- Tablet uyumlu responsive tasarım
- Soft animasyonlar
- APK build

### MVP’de olmayacaklar

- Login sistemi
- Firebase
- Backend
- Cloud sync
- Online veri çekme
- Bildirim sistemi
- Karmaşık admin panel
- Kullanıcı hesabı
- Play Store yayını

---

## 6. Uygulama Sayfaları

### 6.1 Intro Screen

Uygulama ilk kez açıldığında özel bir giriş ekranı gösterilecektir.

Intro metni:

```text
Bu uygulama internette yok.
Play Store’da yok.
Başka kimsede yok.

Çünkü sadece senin için yapıldı.
```

Buton:

```text
Başla
```

Davranış:

- İlk açılışta intro gösterilir.
- Kullanıcı “Başla” butonuna basınca ana sayfaya geçer.
- SharedPreferences ile `intro_seen = true` kaydedilir.
- Sonraki açılışlarda intro tekrar gösterilmez.

---

### 6.2 Home Screen

Ana sayfa uygulamanın merkezi olacaktır.

Üst bölümde karşılama metni bulunur:

```text
Hoş geldin sevgilim 🌙
```

Altında küçük bir mesaj:

```text
Bugün de seni düşündüm.
```

Ana sayfada kartlar halinde bölümler bulunur:

- Bugünün Notu
- Seni Sevme Sebeplerim
- Anılarımız
- Sürpriz Kutuları
- Beni Özlediğinde
- Geri Sayım

Kart özellikleri:

- Yuvarlak köşeli
- Pastel renkli
- Soft shadow
- Minimal ikonlu
- Hafif animasyonlu
- Tablet ekranında grid yapıya uyumlu

---

### 6.3 Bugünün Notu

Bu bölümde her gün farklı bir özel mesaj gösterilecektir.

Veriler `assets/data/daily_notes.json` dosyasından okunur.

Davranış:

- Aynı gün içinde hep aynı not gösterilir.
- Ertesi gün farklı not seçilir.
- Seçim rastgele gibi hissettirebilir ama deterministik olmalıdır.
- İnternet bağlantısı gerekmez.

Seçim algoritması (psödokod):

```text
epoch = DateTime.utc(2025, 1, 1)
gun   = DateTime.now().toUtc().difference(epoch).inDays
index = gun % notes.length
secilen = notes[index]
```

UTC üzerinden hesaplanır ki saat dilimi değişimi günü kaydırmasın. Liste sonuna gelindiğinde başa sarılır.

Örnek mesaj:

```text
Bugün biraz yorulmuş olabilirsin ama bilmeni istiyorum, ben seninle gurur duyuyorum.
```

---

### 6.4 Seni Sevme Sebeplerim

Bu bölümde kullanıcı bir butona basarak rastgele sevgi sebebi açar.

Buton metni:

```text
Bir sebep aç
```

Veriler `assets/data/love_reasons.json` dosyasından okunur.

Davranış:

- Butona basıldığında rastgele bir sebep gösterilir.
- Aynı sebebin sürekli üst üste gelmemesine dikkat edilir.
- Mesaj animasyonlu kart içinde gösterilir.
- İleride favorilere ekleme desteklenebilir.

Tekrar etmeme kuralı:

- SharedPreferences'ta `recent_love_reason_ids` anahtarıyla **son 3 gösterilen ID** FIFO olarak tutulur.
- Yeni sebep seçilirken bu listede olmayan sebepler arasından random seçilir.
- Toplam sebep sayısı 3'ten az ise sadece "en son gösterilen" ID hariç tutulur.
- Yeni gösterim sonrası en eski ID listeden düşer, yeni ID eklenir.

Örnek sebep:

```text
Çünkü en basit anları bile güzel hale getiriyorsun.
```

---

### 6.5 Anılarımız

Bu bölüm dijital fotoğraf albümü gibi çalışacaktır.

Veriler `assets/data/memories.json` dosyasından okunur.

Her anı kartında:

- Fotoğraf
- Başlık
- Tarih
- Kısa açıklama

Fotoğraflar şu klasörde tutulur:

```text
assets/images/memories/
```

Davranış:

- Anılar grid yapıda gösterilir.
- Karta tıklanınca detay ekranı açılır.
- Detay ekranında fotoğraf büyük görünür.
- Fotoğrafın altında başlık, tarih ve açıklama bulunur.

---

### 6.6 Sürpriz Kutuları

Bu bölüm uygulamanın en duygusal ve özel bölümlerinden biridir.

Veriler `assets/data/surprise_boxes.json` dosyasından okunur.

Örnek kutular:

- Kötü bir gününde aç
- Beni özlediğinde aç
- Kendini güzel hissetmediğinde aç
- Uyuyamıyorsan aç
- Çok yorulduysan aç
- Sarılmaya ihtiyacın varsa aç

Bazı kutularda açmadan önce onay modalı gösterilir.

Örnek onay metni:

```text
Bunu gerçekten şimdi açmak istiyor musun?
```

Davranış:

- Kart tıklanınca detay mesajı açılır.
- `requiresConfirmation = true` ise önce onay modalı çıkar.
- Mesaj ekranı sade, okunabilir ve romantik olmalıdır.

---

### 6.7 Beni Özlediğinde

Bu bölüm, kullanıcının özel durumlarda okuyabileceği mesajlardan oluşur.

Veriler `assets/data/miss_me_messages.json` dosyasından okunur.

Örnek kart başlıkları:

- Beni özlediğinde oku
- Uyumadan önce oku
- Sarılmaya ihtiyacın varsa oku
- Moralin bozuksa oku
- Kendini yalnız hissedersen oku

İlk sürümde yazılı mesajlar yeterlidir.

İleride audio desteği eklenebilir:

```text
assets/audio/
```

Audio davranışı (MVP):

- `MissMeMessage` modelinde `String? audio` alanı bulunur (nullable).
- `MissMeCard` widget'ı `audio != null` ise küçük bir 🔇 ikonu gösterir.
- İkona basıldığında snackbar gösterilir: *"Sesli mesaj sonraki güncellemede"*.
- `pubspec.yaml` içine boş `assets/audio/` klasörü tanımlanır.
- `just_audio` paketi şu an eklenmiyor; gelecekte sadece dosya koyup paket entegre edilince aktif olur.

---

### 6.8 Geri Sayım

Bu bölüm özel bir tarihe geri sayım gösterir.

Veri `assets/data/app_config.json` dosyasından okunur.

Örnek config:

```json
{
  "appName": "Sana Sakladıklarım",
  "greetingName": "Sevgilim",
  "countdownTitle": "Bir sonraki buluşmamıza",
  "targetDate": "2026-06-20T18:00:00"
}
```

Ekranda gösterilecek bilgiler:

- Gün
- Saat
- Dakika
- Özel başlık

Eğer tarih geçmişse:

```text
Bugün o özel gün 💛
```

mesajı gösterilir.

---

### 6.9 Settings

Minimal bir ayarlar ekranıdır. Uygulamanın atmosferini bozmamalı, kullanıcının yanlışlıkla bir şey kırmasına izin vermemelidir.

İçerik:

1. **"Tanıtım ekranını tekrar göster"** — buton. Basıldığında SharedPreferences içindeki `intro_seen` değeri `false` yapılır. Sonraki açılışta intro tekrar görünür. Onay modalı opsiyoneldir.
2. **Geri sayım hedef tarihi** — sadece okunur metin. `app_config.json` içindeki `targetDate` ve `countdownTitle` gösterilir. Altında küçük not:

```text
Değiştirmek için uygulama dosyalarındaki app_config.json düzenlenmelidir.
```

3. **Uygulama versiyonu** — `package_info_plus` paketinden okunarak gösterilir (örnek: "Versiyon 1.0.0").
4. **"Sana özel hazırlandı"** — sayfa altında küçük, soft renkli imza satırı.

Davranış:

- Settings ekranına HomeScreen'in sağ üst köşesindeki küçük ikondan veya alt menüden ulaşılır.
- Veri yazma yalnızca `intro_seen` üzerinden yapılır. Diğer alanlar **read-only**.
- Tema seçimi, dil seçimi, bildirim ayarı **yoktur**.

---

## 7. Tasarım Dili

### Genel tasarım

Uygulama sıcak, sade, modern ve romantik görünmelidir.

Kaçınılması gerekenler:

- Aşırı kırmızı tema
- Çok fazla kalp kullanımı
- Çocukça çizimler
- Karmaşık ekranlar
- Fazla yazı yoğunluğu
- Teknik demo gibi görünen arayüz

Hedef his:

```text
Modern bir dijital aşk kutusu.
Tatlı ama abartılı değil.
Romantik ama sade.
Kişisel ama premium.
```

---

## 8. Renk Paleti

Önerilen renkler:

```text
Background: #FFF7F2
Card: #FFFFFF
Primary: #EFA3B8
Secondary: #B9A7E8
Text: #3A2D32
Muted Text: #8A7B82
Accent: #F6C7D5
Soft Yellow: #FFE8A3
```

---

## 9. Tipografi

Önerilen font karakteri:

- Yumuşak
- Okunaklı
- Modern
- Hafif romantik
- Tablet ekranında rahat okunabilir

Google Fonts kullanılabilir.

Öneriler:

- Poppins
- Nunito
- Quicksand
- Lora
- Playfair Display sadece özel başlıklarda kullanılabilir

---

## 10. Animasyonlar

Animasyonlar sade ve yumuşak olmalıdır.

Kullanılabilecek animasyonlar:

- Fade in
- Slide up
- Scale in
- Kart geçişleri
- Sayfa geçişlerinde soft transition
- Sürpriz kutusu açılırken küçük animasyon
- Sevgi sebebi kartı açılırken hafif scale/fade

Animasyonlar uygulamayı yavaşlatmamalı ve abartılı olmamalıdır.

### 10.1 Erişilebilirlik

Hediye uygulaması olmasına rağmen temel erişilebilirlik kuralları korunur:

- **Light mode only.** Dark mode desteklenmez. Pastel renk paleti dark'ta kimliğini kaybedeceği için bilinçli tercih.
- Sistem yazı boyutu büyütüldüğünde uygulama kırılmaz. `MediaQuery.textScaler` desteklenir, maksimum scale = 1.3 ile sınırlanır (daha büyük değerler layout'u bozar).
- Ana butonlara ve kart başlıklarına `Semantics` label'ları eklenir (TalkBack/Screen Reader uyumluluğu).
- Hedef seviye: **WCAG AA**. AAA hedeflenmiyor.
- Renk kontrastı: metin renkleri (`#3A2D32`, `#8A7B82`) `#FFF7F2` arka plan üzerinde AA seviyesini geçmelidir; yeni renk eklemelerinde de bu doğrulanır.

---

## 11. Veri Yapısı

İçerikler kod içine gömülmemeli, JSON dosyalarından okunmalıdır.

### Assets yapısı

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
    miss_me_01.mp3
    good_night.mp3
```

### 11.1 Fotoğraf Optimizasyon Kuralları

APK boyutunu kontrol altında tutmak için anılar klasörüne eklenen fotoğraflar şu kurallara uymalıdır:

| Özellik | Hedef |
|---|---|
| Format | JPG (kalite 80–85) veya WebP |
| Maksimum boyut | 1600 px uzun kenar |
| Hedef dosya boyutu | ≤ 400 KB / fotoğraf |
| Toplam APK hedefi | < 50 MB |

- Daha büyük orijinaller mutlaka **build öncesi** yeniden boyutlandırılmalıdır. Flutter çalışma anında küçültmez, kurulu APK'da orijinal boyutta kalır.
- Tablet retina ekranda 1600 px yeterli; daha yüksek görsel kazanım sağlamaz.
- Şeffaflık gerekmiyorsa PNG kullanılmamalıdır (gereksiz büyük dosya).

---

## 12. JSON Örnekleri

### daily_notes.json

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

### love_reasons.json

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

### surprise_boxes.json

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

### memories.json

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

### miss_me_messages.json

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

### app_config.json

```json
{
  "appName": "Sana Sakladıklarım",
  "greetingName": "Sevgilim",
  "countdownTitle": "Bir sonraki buluşmamıza",
  "targetDate": "2026-06-20T18:00:00"
}
```

---

## 13. Önerilen Flutter Klasör Yapısı

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

---

## 14. Geliştirme Fazları

### Faz 1 — Proje Kurulumu

Amaç: Flutter projesini ve temel mimariyi hazırlamak.

Yapılacaklar:

- Flutter projesi oluşturulacak.
- Android tablet uyumluluğu kontrol edilecek.
- Tema yapısı kurulacak.
- Renk paleti tanımlanacak.
- Assets klasörü hazırlanacak.
- JSON dosyaları oluşturulacak.
- `pubspec.yaml` içine assets yolları eklenecek.

Kabul kriteri:

- Uygulama Android emülatörde veya tablette açılmalı.
- Boş ana ekran görünmeli.
- Tema renkleri uygulanmış olmalı.

---

### Faz 2 — Intro ve Ana Sayfa

Amaç: Uygulamanın ilk duygusal etkisini oluşturmak.

Yapılacaklar:

- IntroScreen oluşturulacak.
- Intro sadece ilk açılışta gösterilecek.
- SharedPreferences entegrasyonu yapılacak.
- HomeScreen oluşturulacak.
- Home kartları oluşturulacak.

Kabul kriteri:

- İlk açılışta intro görünmeli.
- Başla butonuna basınca ana sayfa açılmalı.
- Sonraki açılışlarda direkt ana sayfa gelmeli.

---

### Faz 3 — Local JSON Veri Sistemi

Amaç: İçerikleri JSON dosyalarından dinamik şekilde okumak.

Yapılacaklar:

- LocalJsonService oluşturulacak.
- Model class’ları oluşturulacak.
- JSON parse işlemleri yapılacak.
- Hata durumları yönetilecek.
- Boş veri durumları için fallback UI eklenecek.

Kabul kriteri:

- Günlük notlar, sevgi sebepleri, anılar, sürpriz kutuları ve özel mesajlar JSON’dan okunmalı.

---

### Faz 4 — Bugünün Notu

Amaç: Gün bazlı özel mesaj sistemi oluşturmak.

Yapılacaklar:

- DailyNoteScreen oluşturulacak.
- Tarihe göre deterministik mesaj seçimi yapılacak.
- Mesaj soft card içinde gösterilecek.
- Sayfa geçiş animasyonu eklenecek.

Kabul kriteri:

- Aynı gün aynı not görünmeli.
- Farklı günlerde farklı not seçilebilmeli.
- Mesaj JSON’dan gelmeli.

---

### Faz 5 — Seni Sevme Sebeplerim

Amaç: Rastgele sevgi sebebi gösteren bölüm oluşturmak.

Yapılacaklar:

- LoveReasonsScreen oluşturulacak.
- LoveReasonCard oluşturulacak.
- “Bir sebep aç” butonu eklenecek.
- Rastgele seçim yapılacak.
- Aynı mesajın üst üste gelmesi mümkün olduğunca engellenecek.
- Kart animasyonu eklenecek.

Kabul kriteri:

- Butona basınca sevgi sebebi görünmeli.
- Mesajlar JSON’dan gelmeli.
- Arayüz tatlı ve modern görünmeli.

---

### Faz 6 — Anılarımız

Amaç: Fotoğraflı anı galerisi oluşturmak.

Yapılacaklar:

- MemoriesScreen oluşturulacak.
- MemoryCard oluşturulacak.
- Grid layout yapılacak.
- MemoryDetailScreen oluşturulacak.
- Fotoğraf, başlık, tarih ve açıklama gösterilecek.

Kabul kriteri:

- Anılar grid halinde görünmeli.
- Karta tıklanınca detay ekranı açılmalı.
- Fotoğraflar local assets üzerinden yüklenmeli.

---

### Faz 7 — Sürpriz Kutuları

Amaç: Özel durumlara göre açılan romantik kutular oluşturmak.

Yapılacaklar:

- SurpriseBoxesScreen oluşturulacak.
- SurpriseBoxCard oluşturulacak.
- Confirmation modal eklenecek.
- SurpriseBoxDetailScreen oluşturulacak.
- Açılma animasyonu eklenecek.

Kabul kriteri:

- Kutular JSON’dan gelmeli.
- Confirmation gereken kutularda onay çıkmalı.
- Kutuların mesaj detayları doğru açılmalı.

---

### Faz 8 — Beni Özlediğinde

Amaç: Özel mesajlar bölümü oluşturmak.

Yapılacaklar:

- MissMeScreen oluşturulacak.
- MissMeCard oluşturulacak.
- Mesaj detay görünümü yapılacak.
- İleride audio desteği için yapı hazırlanacak.

Kabul kriteri:

- Mesaj kartları görünmeli.
- Karta tıklanınca detay mesajı açılmalı.
- JSON’daki audio alanı ileride kullanılabilecek şekilde modelde bulunmalı.

---

### Faz 9 — Geri Sayım

Amaç: Özel tarihe canlı geri sayım göstermek.

Yapılacaklar:

- CountdownScreen oluşturulacak.
- app_config.json içinden hedef tarih okunacak.
- Kalan gün, saat, dakika hesaplanacak.
- Timer ile ekran güncellenecek.
- Tarih geçmişse özel mesaj gösterilecek.

Kabul kriteri:

- Geri sayım doğru çalışmalı.
- Hedef tarih app_config.json’dan değiştirilebilmeli.
- Tarih geçince özel gün mesajı görünmeli.

---

### Faz 10 — Cila, Test ve APK

Amaç: Uygulamayı hediye edilebilir hale getirmek.

Yapılacaklar:

- Responsive tablet tasarımı kontrol edilecek.
- Animasyonlar düzenlenecek.
- App icon eklenecek (`flutter_launcher_icons` paketi ile, kaynak 1024×1024 PNG).
- Splash screen eklenecek (`flutter_native_splash` paketi ile, arka plan `#FFF7F2`, ortada logo).
- Boş veri durumları kontrol edilecek.
- Android APK build alınacak (`flutter build apk --release`).
- Gerçek tablette test edilecek.

Kullanıcının sağlaması gereken varlık:

- Tek bir 1024×1024 PNG dosyası (`assets/branding/app_icon.png`). Yoksa uygulama isminden türetilmiş tipografik bir geçici logo kullanılır.

Kabul kriteri:

- APK tablete kurulmalı.
- Uygulama internet olmadan çalışmalı.
- Tüm sayfalar hatasız açılmalı.
- Uygulama teknik demo gibi değil, özel bir hediye gibi görünmeli.

---

## 15. İçerik Hazırlama Listesi

Uygulamayı tamamlamak için hazırlanması gereken içerikler:

### Günlük notlar

Minimum 30 adet.

### Seni sevme sebepleri

Minimum 50 adet.

### Sürpriz kutuları

Minimum 8-10 adet.

### Anılar

Minimum 5-10 fotoğraf ve açıklama.

### Beni özlediğinde mesajları

Minimum 5 adet.

### Geri sayım tarihi

1 özel tarih.

---

## 16. Kabul Kriterleri

Proje tamamlandığında aşağıdaki maddeler sağlanmalıdır:

- Uygulama Android tablette çalışır.
- Uygulama offline çalışır.
- İlk açılışta intro görünür.
- Intro sonraki açılışlarda tekrar görünmez.
- Ana sayfa kartları düzgün çalışır.
- Günlük not JSON’dan okunur.
- Günlük not aynı gün sabit kalır.
- Sevgi sebepleri rastgele gösterilir.
- Anılar fotoğraflı grid olarak görünür.
- Anı detay ekranı çalışır.
- Sürpriz kutuları açılır.
- Confirmation modal çalışır.
- Beni Özlediğinde bölümü çalışır.
- Geri sayım doğru hesaplanır.
- Uygulama tablet ekranına uyumludur.
- Tasarım modern, tatlı ve romantiktir.
- APK build alınabilir.

---

## 17. İleriki Sürüm Fikirleri

MVP tamamlandıktan sonra eklenebilecek özellikler:

- Sesli mesajlar
- Mood seçimi
- Mini oyun
- Şifreli kutular
- Gizli easter egg sayfası
- Fotoğraf üstüne not yazma
- Favori mesajlar
- Özel takvim
- Küçük animasyonlu karakter
- Ona özel mini quiz
- “Bugün nasıl hissediyorsun?” ekranı
