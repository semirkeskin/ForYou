# Sana Sakladıklarım

Kişiye özel, offline çalışan Flutter hediye uygulaması. APK olarak Android telefon veya tablete kurulur.

## Geliştirme — ilk kurulum

1. **Flutter SDK** kur (~1 GB): https://docs.flutter.dev/get-started/install/windows/mobile
   - Zip'i `C:\flutter\` altına aç (yol içinde boşluk olmasın).
   - `C:\flutter\bin` klasörünü PATH'e ekle.
   - Terminal aç, `flutter --version` çalışıyor mu kontrol et.
2. Proje klasöründe ilk defa platform iskeletini üret:
   ```bash
   flutter create --project-name sana_sakladiklarim --platforms=android,web .
   ```
   Bu komut `android/` ve `web/` klasörlerini ekler. Mevcut `lib/`, `assets/`, `pubspec.yaml` dosyalarına dokunmaz.
3. Bağımlılıkları çek:
   ```bash
   flutter pub get
   ```

## Geliştirme sırasında — tarayıcıda önizleme

APK build etmeden hızlı önizleme için Chrome'da çalıştır:

```bash
flutter run -d chrome
```

Bu mod web'de canlı önizleme verir. Kod değiştir, kaydet, **r** tuşuna bas → anında yeniden yüklenir.

## APK'yı GitHub Actions ile build et

1. GitHub'da yeni bir **private** repo aç.
2. Bu klasörden push et:
   ```bash
   git init
   git add .
   git commit -m "Ilk surum"
   git branch -M main
   git remote add origin git@github.com:<kullanici>/<repo>.git
   git push -u origin main
   ```
3. GitHub'da repo sayfasını aç → **Actions** sekmesi → **Build APK** workflow'unu seç.
4. Workflow otomatik çalışır (push'ta tetiklenir). 5–8 dakika sürer.
5. Bittiğinde sayfanın altındaki **Artifacts** bölümünde `sana-sakladiklarim-apks` dosyasını indir.
6. ZIP içinde 3 APK olur (ARMv7, ARM64, x86_64). Modern telefonların hemen hepsi için **`app-arm64-v8a-release.apk`** doğru olanı.

## APK'yı telefona kurma

1. APK'yı telefona aktar (USB, Drive, Telegram, mail, hangisi pratikse).
2. Telefonda `Ayarlar → Güvenlik → Bilinmeyen kaynaklara izin ver` (Android sürümüne göre yer değişebilir).
3. APK dosyasına dokun → kur.
4. Uygulama açıldığında intro ekranı görünür. "Başla" → ana sayfaya geçer. Bir daha intro görünmez.

## Klasör yapısı

```
lib/
  main.dart, app.dart
  core/theme/         renkler, font, tema
  core/constants/     asset yollari
  core/utils/         tarih yardimcilari
  data/models/        JSON modelleri
  data/services/      JSON okuma + SharedPreferences
  features/intro/     ilk acilis ekrani
  features/home/      ana sayfa
  shared/widgets/     SoftCard, PrimaryButton, AnimatedFadeSlide

assets/
  data/               6 JSON dosyasi (icerikler)
  images/memories/    fotograflar (her biri <= 400 KB / 1600 px)
  audio/              ileride sesli mesajlar
  branding/           app_icon.png (1024x1024) — sen ekleyeceksin
```

## İçerik düzenleme

İçerikler kod içinde değil JSON dosyalarında. `assets/data/` altındaki dosyaları düz metin editörü ile aç:

- `daily_notes.json` — her gün gösterilecek mesajlar
- `love_reasons.json` — sevgi sebepleri
- `memories.json` — anı kartları (fotoğraf yolu, başlık, tarih, açıklama)
- `surprise_boxes.json` — sürpriz kutu mesajları
- `miss_me_messages.json` — özlediğinde okunacak mesajlar
- `app_config.json` — geri sayım tarihi ve karşılama adı

Fotoğraflar `assets/images/memories/` altına `memory_01.jpg`, `memory_02.jpg` şeklinde konulur. `memories.json` içindeki `image` yolu bu dosyayla eşleşmelidir.

## Önemli kısıtlar (özet)

- Firebase, backend, login yok. Tamamen offline.
- State management paketi (Provider/Riverpod/Bloc) yok — sadece `setState`.
- Navigation paketi yok — sadece `Navigator.push`.
- Dark mode yok. Sadece light tema.
- Audio paketi şu an eklenmedi; altyapı hazır.

Detaylı plan için `sana_sakladiklarim_master_plan.md` dosyasına bak.
