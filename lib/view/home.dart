import 'package:chat_app/view/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/appbar.dart';
import 'package:chat_app/widget/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  late final Stream chatRoomStream;

  //USER LIST
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(
                    chatRoomId: ds.id,
                    lastMessage: ds["lastMessage"],
                    myUserName: ds["lastMessageSendBy"],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: ColorData.primary,
                ),
              );
      },
    );
  }

//GET CHAT ROOM LIST
  getChatRooms() async {
    chatRoomStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMessageAppBar(context, "Home Page"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Expanded(
            child: Column(
              children: [
                chatRoomList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String chatRoomId, lastMessage, myUserName;
  const ChatRoomListTile({
    Key? key,
    required this.chatRoomId,
    required this.lastMessage,
    required this.myUserName,
  }) : super(key: key);

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  late String myProfilePic = "", name = "", userName = "";

  getThisUserInfo() async {
    userName =
        widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(userName);
    // print("something ${querySnapshot.docs[0].id}");
    name = "${querySnapshot.docs[0]["name"]}";
    myProfilePic = "${querySnapshot.docs[0]["imageUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(name: name, userName: userName),
          ),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Image.network(
              myProfilePic,
              height: 30,
              width: 30,
            ),
          ),
          Column(
            children: [
              Text(name),
              12.heightBox,
              Text(widget.lastMessage),
            ],
          )
        ],
      ),
    );
  }
}
