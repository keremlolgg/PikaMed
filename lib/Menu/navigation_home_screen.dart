import 'package:PikaMed/model/app_theme.dart';
import 'package:PikaMed/Menu/custom_drawer/drawer_user_controller.dart';
import 'package:PikaMed/Menu/custom_drawer/home_drawer.dart';
import 'package:PikaMed/Menu/feedback_screen.dart';
import 'package:PikaMed/Menu/help_screen.dart';
import 'package:PikaMed/Menu/invite_friend_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:PikaMed/hasta menu/fitness_app_home_screen.dart';
import 'package:PikaMed/giris_animasyon/introduction_animation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:PikaMed/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:PikaMed/hasta menu/models/InsulinDose.dart';
import 'package:intl/date_symbol_data_local.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  final _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Message received: ${message.notification?.title}, ${message.notification?.body}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message.notification?.title ?? 'Bildirim'),
              content: Text(message.notification?.body ?? 'Bildirim içeriği yok.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    });
    setState(() {
      drawerIndex = DrawerIndex.HOME;
      _user = _auth.currentUser;
    });
    if(_user==null) {
      setState(() {
        screenView =GirisAnimasyonScreen();
      });
    } else {
      setState(() {
        screenView = HastaHomeScreen();
      });
    }
    surumkiyasla(context);
    starting();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }
  void starting()async {
    await initializeDateFormatting('tr_TR', null);
    await readFromFile((update) => setState(update));
    InsulinListData.updateDoseLists();
    if(channelId.isEmpty)
      channelId= await getChannelId();
    bmi = weight / ((size / 100) * (size / 100));
    if (bmi < 18.5) {
      bmiCategory = 'Zayıf';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      bmiCategory = 'Normal';
    } else if (bmi >= 25 && bmi < 29.9) {
      bmiCategory = 'Fazla Kilolu';
    } else {
      bmiCategory = 'Obez';
    }
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (changeWaterDay == null || changeWaterDay != today) {
      changeWaterDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
      debugPrint("Yeni gün tespit edildi! Veriler sıfırlandı.");
      availableWater=0;
      changeWaterClock = DateFormat('EEEE,  ', 'tr_TR').format(DateTime.now());
      changeWaterClock +='00:00';
    } else {
      debugPrint("Bugün zaten kaydedilmiş: $today");
    }
    writeToFile();
    postInfo();
  }
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      Permission.notification.request();
    }
  }
  Future<void> surumkiyasla(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    String? remoteVersion;
    String? apkUrl;
    String? updateNotes;
    bool isUpdateMandatory = false;

    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/keremlolgg/PikaMed/main/PikaMed.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null &&
            data.containsKey('latest_version') &&
            data.containsKey('apk_url') &&
            data.containsKey('apiserver') &&
            data.containsKey('update_notes')) {

          remoteVersion = data['latest_version'] ?? 'N/A';
          apkUrl = data['apk_url'] ?? 'N/A';
          updateNotes = data['update_notes'] ?? 'Yama notları bulunamadı';

          if (remoteVersion != localVersion && apkUrl != 'N/A') {
            showDialog(
              context: context,
              barrierDismissible: !isUpdateMandatory,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Yeni Sürüm Var'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mevcut Sürüm: $localVersion'),
                      Text('Yeni Sürüm: $remoteVersion'),
                      SizedBox(height: 10),
                      Text('Yama Notları:'),
                      Text(updateNotes ?? 'Yama notları mevcut değil'),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Güncelle'),
                      onPressed: () {
                        EasyLauncher.url(url: apkUrl!);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          throw Exception('JSON verisinde eksik anahtarlar var');
        }
      } else {
        throw Exception('Veri alınamadı. HTTP Hatası: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }

  void changeIndex(DrawerIndex drawerIndexdata) async {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          if(_user==null) {
            setState(() {
              screenView =GirisAnimasyonScreen();
            });
          } else {
            setState(() {
              screenView = HastaHomeScreen();
            });
          }
          break;
        case DrawerIndex.Doctor:
          bool isDoctorUser = await isDoctor();
          if (isDoctorUser) {
            setState(() {
              EasyLauncher.url(
                // kendi whatsapp linkim değiştirilcek
                url: 'https://keremkk.glitch.me/doktor',
              );
            });
          } else {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Doktor menüsüne girmek için yetkiniz bulunmuyor.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        case DrawerIndex.Share:
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Uygulamayı değerlendir sekmesi açılacak."),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.blue,
                action: SnackBarAction(
                  label: "Kapat",
                  onPressed: () {
                    // İşlem yapılabilir
                  },
                ),
              ),
            );
          });
          break;
        case DrawerIndex.About:
          setState(() {
            EasyLauncher.url(
              url: 'https://keremkk.vercel.app/pikamed',
            );
          });
          break;
        default:
          break;
      }
    }

}
