import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:PikaMed/Menu/navigation_home_screen.dart';
import 'package:PikaMed/functions.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CenterNextButton extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;

  const CenterNextButton({
    Key? key,
    required this.animationController,
    required this.onNextClick,
  }) : super(key: key);

  @override
  _CenterNextButtonState createState() => _CenterNextButtonState();
}

class _CenterNextButtonState extends State<CenterNextButton> {

  Future<void> onTapped(BuildContext context) async {
    final _auth = firebase_auth.FirebaseAuth.instance;
    firebase_auth.User? user = await googleSignIn(_auth);
    if (user != null) {
      debugPrint('Google ile giriş başarılı: ${user.displayName}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
      );
    } else {
      debugPrint('Google ile giriş başarısız.');
    }
  }
  Future<firebase_auth.User?> googleSignIn(firebase_auth.FirebaseAuth _auth) async {
    try {
      await GoogleSignIn().signOut();
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        debugPrint("Kullanıcı oturum açmayı iptal etti.");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = (await _auth.signInWithCredential(credential)).user;
      if (user == null) {
        debugPrint("Google Sign-In başarısız.");
        return null;
      }
      String isim =  user.providerData.first.displayName!;
      String email = user.email!;
      String uid = user.uid;
      String profilurl = user.photoURL!;

      try {
        final targetUrl = '${apiserver}/authlog';
        final response = await http.post(
          Uri.parse(targetUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'sebep': 'Giriş',
            'uid': uid,
            'name': isim,
            'email': email,
            'profilUrl': profilurl,
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

  @override
  Widget build(BuildContext context) {
    final _topMoveAnimation =
    Tween<Offset>(begin: Offset(0, 5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.0, 0.2, curve: Curves.fastOutSlowIn),
      ),
    );

    final _signUpMoveAnimation =
    Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
    ));

    final _loginTextMoveAnimation =
    Tween<Offset>(begin: Offset(0, 5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _topMoveAnimation,
            child: AnimatedBuilder(
              animation: widget.animationController,
              builder: (context, child) => AnimatedOpacity(
                opacity: widget.animationController.value >= 0.2 &&
                    widget.animationController.value <= 0.6
                    ? 1
                    : 0,
                duration: Duration(milliseconds: 480),
                child: _pageView(),
              ),
            ),
          ),
          SlideTransition(
            position: _topMoveAnimation,
            child: AnimatedBuilder(
              animation: widget.animationController,
              builder: (context, child) => Padding(
                padding: EdgeInsets.only(
                  bottom: 38 - (38 * _signUpMoveAnimation.value),
                ),
                child: Container(
                  height: 58,
                  width: 58 + (200 * _signUpMoveAnimation.value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8 + 32 * (1 - _signUpMoveAnimation.value),
                    ),
                    color: Color(0xff132137),
                  ),
                  child: PageTransitionSwitcher(
                    duration: Duration(milliseconds: 480),
                    reverse: _signUpMoveAnimation.value < 0.7,
                    transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        ) {
                      return SharedAxisTransition(
                        fillColor: Colors.transparent,
                        child: child,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                      );
                    },
                    child: _signUpMoveAnimation.value > 0.7
                        ? InkWell(
                      key: ValueKey('Sign Up button'),
                      onTap: () {
                        onTapped(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giriş Yap',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    )
                        : InkWell(
                      key: ValueKey('next button'),
                      onTap: widget.onNextClick,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SlideTransition(
              position: _loginTextMoveAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageView() {
    int _selectedIndex = 0;

    if (widget.animationController.value >= 0.7) {
      _selectedIndex = 3;
    } else if (widget.animationController.value >= 0.5) {
      _selectedIndex = 2;
    } else if (widget.animationController.value >= 0.3) {
      _selectedIndex = 1;
    } else if (widget.animationController.value >= 0.1) {
      _selectedIndex = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: _selectedIndex == i
                      ? Color(0xff132137)
                      : Color(0xffE3E4E4),
                ),
                width: 10,
                height: 10,
              ),
            )
        ],
      ),
    );
  }
}
