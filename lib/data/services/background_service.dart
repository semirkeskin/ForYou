import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'preferences_service.dart';

/// Kullanicinin ana sayfa arka planini telefondan resim secerek
/// degistirmesini saglar. Secilen resim uygulamanin ozel klasorune kopyalanir
/// (galeri'den silinse bile uygulamada kalir).
class BackgroundService {
  BackgroundService(this._preferences);

  final PreferencesService _preferences;
  final ImagePicker _picker = ImagePicker();

  /// Galeriden resim sec, kopyala, path'i kaydet. Iptal edilirse null doner.
  Future<String?> pickAndSetBackground() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      maxHeight: 4000,
      imageQuality: 90,
    );
    if (picked == null) return null;

    final docsDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = _extensionOf(picked.path);
    final destPath = '${docsDir.path}/background_$timestamp$ext';

    final destFile = File(destPath);
    await destFile.create(recursive: true);
    await File(picked.path).copy(destPath);

    await _deleteOldBackground();

    await _preferences.setCustomBackgroundPath(destPath);
    return destPath;
  }

  /// Custom background'i sifirla, dosyayi sil.
  Future<void> clearBackground() async {
    await _deleteOldBackground();
    await _preferences.setCustomBackgroundPath(null);
  }

  Future<void> _deleteOldBackground() async {
    final oldPath = _preferences.customBackgroundPath;
    if (oldPath == null) return;
    final file = File(oldPath);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (_) {
        // Silinemediyse sessizce gec; yeni path zaten ustune yazilacak.
      }
    }
  }

  String _extensionOf(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1) return '.jpg';
    final ext = path.substring(lastDot).toLowerCase();
    if (ext.length > 5) return '.jpg';
    return ext;
  }
}
