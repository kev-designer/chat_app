import 'package:flutter/material.dart';

import 'package:chat_app/widget/appbar.dart';

class ChatScreen extends StatefulWidget {
  final String userName, name;
  const ChatScreen({
    Key? key,
    required this.name,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, widget.name),
    );
  }
}
