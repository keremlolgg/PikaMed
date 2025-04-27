import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._privateConstructor();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationService._privateConstructor();
  Future<void> initialize() async {
    const androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: androidInitialization);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) async {
        // Bildirime tıklanınca yapılacak işlem
      },
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
  }

  Future<void> showNotification(String title, String body) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'insulin_reminder_channel',
        'İnsülin Hatırlatıcı',
        channelDescription: 'PikaMed',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        return token;  // Token'ı döndürür.
      } else {
        return '';  // Token bulunmazsa boş string döndürür.
      }
    } catch (e) {
      print("FCM token alınırken hata oluştu: $e");
      return '';  // Hata durumunda boş string döndürür.
    }
  }
}
/*
          NotificationService.instance.showNotification(
            'Hatırlatma ${dose.titleTxt}',
            'Doz takibi zamanı geldi! ${dose.insulinDoses.map((e) => "${e.type} - ${e.dose}${e.unit}").join(", ")}',
          );

 */