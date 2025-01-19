import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

String apiserver = "";

Future<void> postmessage(String message,String neden,String api) async {
  try {
    final targetUrl = '${apiserver}/$api';
    final response = await http.post(
      Uri.parse(targetUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sebep': neden,
        'message': message,
      }),
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      print('Mesaj başarıyla gönderildi!');
    } else {
      print('Mesaj gönderilemedi: ${response.statusCode}');
    }
  } catch (e) {
    print('Hata: $e');
  }
}

Future<bool> isDoctor() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Yeni bir idToken alınması
    final idTokenResult = await user.getIdTokenResult(); // true parametresi ile yeni bir idToken alınır.

    return idTokenResult.claims?['role'] == 'doctor';
  }
  return false;
}