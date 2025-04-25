import 'dart:io';
import 'package:PikaMed/model/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Menu/navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'dart:async';
import 'package:flutter_background/flutter_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale deviceLocale = PlatformDispatcher.instance.locale;
  localLanguage = deviceLocale.languageCode;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  enableBackgroundExecution();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

Future<void> enableBackgroundExecution() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Arka Planda Çalışıyor",
    notificationText: "Doz Takip Aktif.",
    notificationImportance: AndroidNotificationImportance.normal,
    enableWifiLock: true,
  );

  bool hasPermission = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (hasPermission) {
    FlutterBackground.enableBackgroundExecution();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Marul Tarlasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      themeMode: ThemeMode.light,
      home: NavigationHomeScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
/*
flutter build apk
xcopy /Y /I "build\app\outputs\flutter-apk\app-release.apk" "C:\Users\Kerem\Desktop\PikaMed.apk"

 */