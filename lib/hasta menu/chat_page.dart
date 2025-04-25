// chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../functions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChatPage()),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user');
  final types.User _ai = const types.User(id: 'ai', firstName: 'AI');

  @override
  void initState() {
    super.initState();
    _addMessage('Merhaba! Sana nasıl yardımcı olabilirim?', fromAI: true);
  }

  void _addMessage(String text, {bool fromAI = false}) {
    final message = types.TextMessage(
      author: fromAI ? _ai : _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _onSendPressed(types.PartialText message) async {
    _addMessage(message.text);

    String aiResponse = await askAi(message.text);

    _addMessage(aiResponse, fromAI: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sanal Doktorum')),
      body: Chat(
        messages: _messages,
        onSendPressed: _onSendPressed,
        user: _user,
      ),
    );
  }
}
