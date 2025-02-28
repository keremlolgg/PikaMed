import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseLogin extends StatefulWidget {
  const FirebaseLogin({super.key});

  @override
  _FirebaseLoginState createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends State<FirebaseLogin> {
  final _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;
  // If this._busy=true, the buttons are not clickable. This is to avoid
  // clicking buttons while a previous onTap function is not finished.
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    this._user = _auth.currentUser;
    _auth.authStateChanges().listen((firebase_auth.User? usr) {
      this._user = usr;
      debugPrint('user=$_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusText = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        _user == null
            ? 'You are not logged in.'
            : 'You are logged in as "${_user!.displayName}".',
      ),
    );
    final googleLoginBtn = MaterialButton(
      color: Colors.blueAccent,
      onPressed: this._busy
          ? null
          : () async {
        setState(() => this._busy = true);
        try {
          final user = await this._googleSignIn();

          // Kullanıcı null ise işlemi durdur
          if (user == null) {
            setState(() => this._busy = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Google oturum açma başarısız!")),
            );
            return;
          }
          this._showUserProfilePage(user);
        } catch (e) {
          // Hata durumunda SnackBar ile hata mesajı göster
          setState(() => this._busy = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Oturum açma hatası: $e")),
          );
          debugPrint('Oturum açma hatası: $e');
        }
      },
      child: const Text('Log in with Google'),
    );

    final signOutBtn = TextButton(
      onPressed: this._busy
          ? null
          : () async {
        setState(() => this._busy = true);
        await this._signOut();
        setState(() => this._busy = false);
      },
      child: const Text('Log out'),
    );
    return Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
        children: <Widget>[
          Text(
              'NOTE: prefer the flutterfire_ui package, see `FlutterFireLoginUiExample`.'),
          statusText,
          googleLoginBtn,
          signOutBtn,
        ],
      ),
    );
  }

  Future<firebase_auth.User?> _googleSignIn() async {
    try {
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
      return user;
    } catch (error) {
      debugPrint("Google Sign-In Hatası: $error");
      return null;
    }
  }
  Future<void> _signOut() async {
    final user = _auth.currentUser;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user == null
              ? 'No user logged in.'
              : '"${user.displayName}" logged out.',
        ),
      ),
    );
    _auth.signOut();
    setState(() => this._user = null);
  }
  void _showUserProfilePage(firebase_auth.User user) {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: const Text('user profile'),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(title: Text('User: $user')),
              ListTile(title: Text('User id: ${user.uid}')),
              ListTile(title: Text('Display name: ${user.displayName}')),
              ListTile(title: Text('Anonymous: ${user.isAnonymous}')),
              ListTile(title: Text('Email: ${user.email}')),
              ListTile(
                title: const Text('Profile photo: '),
                trailing: user.photoURL != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                )
                    : CircleAvatar(
                  child: Text(user.displayName![0]),
                ),
              ),
              ListTile(
                title: Text('Last sign in: ${user.metadata.lastSignInTime}'),
              ),
              ListTile(
                title: Text('Creation time: ${user.metadata.creationTime}'),
              ),
              ListTile(title: Text('ProviderData: ${user.providerData}')),
            ],
          ),
        ),
      ),
    );
  }

}