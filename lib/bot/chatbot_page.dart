import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  ChatUser me = ChatUser(
    id: "1",
    firstName: "You",
  );
  ChatUser bot = ChatUser(
    id: "2",
    firstName: "ChatBot",
  );

  List<ChatMessage> allMessages = [];

  getData(ChatMessage message){
    allMessages.insert(0, message);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: DashChat(
        messages: allMessages,
        onSend: (ChatMessage message) {
          getData(message);
        },
        currentUser: me,
      ),
    );
  }
}
