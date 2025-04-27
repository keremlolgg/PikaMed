import 'package:PikaMed/model/app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:PikaMed/functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../navigation_home_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  final _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((firebase_auth.User? user) {
      setState(() {
        _user = user;
      });
      debugPrint('user=$_user');
    });
    setDrawerListArray();
  }


  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Ana Menü',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Doctor,
        labelName: 'Doktor Menüsü',
        icon: Icon(Icons.person),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Yardım',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'Geri Bildirim',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Uygulamayı Paylaş',
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: 'Uygulamayı Değerlendir',
        icon: Icon(Icons.star),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'Hakkında',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 -
                            (widget.iconAnimationController!.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController!,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60.0)),
                              child: _user == null ? Image.asset('assets/custom_profile.png') : Image.network(
                                _user?.photoURL ?? 'https://http.dog/404.jpg',
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.account_circle, size: 50); // Hata durumunda bir ikon göster
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _user == null ? 'Lütfen Oturum Açın' : (_user?.providerData.first.displayName! ?? 'Kullanıcı'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  _user == null ? 'Oturum Aç': 'Oturumu Kapat',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: _user == null ? Colors.green : Colors.red,
                ),
                onTap: () { onTapped(context); },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped(BuildContext context) async {
    if(_user==null){
      try {
        final user = await this.googleSignIn();

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Google oturum açma başarısız!")),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oturum açma hatası: $e")),
        );
        debugPrint('Oturum açma hatası: $e');
      }
    }
    else {
      signOut();
    }
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.black
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }

  Future<firebase_auth.User?> googleSignIn() async {
    try {
      await GoogleSignIn().signOut();
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Kullanıcı oturum açmayı iptal etti
        debugPrint("Kullanıcı oturum açmayı iptal etti.");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        name=  user.providerData.first.displayName!;
        uid = user.uid;
        photoURL = user.photoURL!;
      } else {
        name = "Error";
      }
      await fetchUserData((update) => setState(update));
      writeToFile();
      try {
        final targetUrl = '${apiserver}/authlog';
        final response = await http.post(
          Uri.parse(targetUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'sebep': 'Giriş',
            'uid': uid,
            'name': name,
            'profilUrl': photoURL,
          }),
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          debugPrint('Mesaj başarıyla gönderildi!');
        } else {
          // Yanıtın içeriğini de yazdır
          debugPrint('Mesaj gönderilemedi: ${response.statusCode}');
          debugPrint('Yanıt içeriği: ${response.body}');
        }
      } catch (e) {
        // Hata türünü ve mesajını yazdır
        debugPrint('Hata: ${e.toString()}');

        // Eğer hata bir http isteği ile ilgiliyse, daha fazla bilgi ekleyebiliriz
        if (e is http.ClientException) {
          debugPrint('HTTP İsteği Hatası: ${e.message}');
        } else if (e is TimeoutException) {
          debugPrint('Zaman aşımı hatası: İstek zaman aşımına uğradı.');
        } else {
          debugPrint('Bilinmeyen hata: ${e.runtimeType}');
        }
      }
      return user;
    } catch (error) {
      debugPrint("Google Sign-In Hatası: $error");
      return null;
    }
  }
  Future<void> signOut() async {
    final user = _auth.currentUser;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user == null
              ? 'Zaten giriş yapmadınız.'
              : '"${user.providerData.first.displayName!}" adlı hesaptan çıkış yaptınız.',
        ),
      ),
    );
    _auth.signOut();
    try {
      final targetUrl = '${apiserver}/authlog';
      final requestBody = {
        'sebep': "Çıkış",
        'name': name,
        'uid': uid,
        'profilUrl': photoURL,
      };

      debugPrint('Çıkış isteği API\'ye gönderiliyor: $targetUrl');
      debugPrint('İstek verileri: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(targetUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      ).timeout(Duration(seconds: 30));

      debugPrint('API yanıt kodu: ${response.statusCode}');
      debugPrint('API yanıtı: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Çıkış mesajı başarıyla gönderildi!');
      } else {
        debugPrint('Çıkış mesajı gönderilemedi: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      debugPrint('Hata: Çıkış isteği zaman aşımına uğradı!');
    } catch (e, stackTrace) {
      debugPrint('Hata: $e');
      debugPrint('StackTrace: $stackTrace');
    }
    await resetAllData((update) => setState(update));
    writeToFile();
    setState(() => this._user = null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
    );
  }
}

enum DrawerIndex {
  HOME,
  Doctor,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
