# PikaMed Mobil Uygulaması

PikaMed, sağlık hizmetleri ve hasta takibi için geliştirilmiş bir mobil uygulamadır.

## Özellikler

- 🔐 Güvenli kullanıcı kimlik doğrulama (Firebase Authentication)
- 📱 Modern ve kullanıcı dostu arayüz
- 🔔 Anlık bildirimler
- 💬 Mesajlaşma özelliği
- 📊 Hasta takip sistemi
- 🤖 Yapay zeka destekli hasta analizi (Gemini AI)

## Teknolojiler

- Flutter SDK
- Firebase
- Google Sign-In
- Gemini AI
- HTTP

## Gereksinimler

- Flutter SDK (>=2.17.5)
- Dart SDK
- Firebase hesabı
- Android Studio / VS Code
- Git
- Gemini AI API anahtarı

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/keremlolgg/PikaMed.git
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Firebase yapılandırmasını ayarlayın:
- Firebase Console'dan yeni bir proje oluşturun
- Android ve iOS uygulamalarınızı Firebase'e ekleyin
- `google-services.json` ve `GoogleService-Info.plist` dosyalarını ilgili klasörlere ekleyin

4. Server Code:
- [Code](https://glitch.com/edit/#!/keremkk?path=routes/geogame.js)
- Api server oluşturun ve apiserveri değiştirin.

5. Uygulamayı çalıştırın:
```bash
flutter run
```

## Proje Yapısı

```
lib/
├── functions.dart
├── NotificationService.dart
├── main.dart
├── firebase_options.dart
├── model/
├── Menu/
├── hasta menu/
└── giris_animasyon/
```

## Katkıda Bulunma

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Bir Pull Request oluşturun

## Lisans

Bu proje GPL lisansı altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakın.

## İletişim

Proje Sahibi - [keremlolgg](https://keremkk.can.re)
