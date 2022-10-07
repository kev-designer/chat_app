import 'package:chat_app/view/chat_screen.dart';
import 'package:chat_app/widget/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const ChatDetailPage();
        //     },
        //   ),
        // );
      },
      child: Container(
        color: ColorData.white,
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  //PROFILE IMAGE
                  CircleAvatar(
                    backgroundColor: ColorData.primary,
                    backgroundImage: NetworkImage(myProfilePic),
                    maxRadius: 30,
                  ),
                  12.widthBox,
                  //NAME & MESSAGE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.nunito(
                            fontSize: height(context) * .02,
                            fontWeight: FontWeight.w700,
                            color: ColorData.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                        8.heightBox,
                        Text(
                          widget.lastMessage,
                          style: GoogleFonts.nunito(
                            fontSize: height(context) * .018,
                            color: ColorData.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //TIME
            // Text(
            //   widget.time,
            //   style: GoogleFonts.nunito(
            //     fontSize: height(context) * .018,
            //     color: ColorData.primary,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),
      ),
    );

    // return GestureDetector(
    //   onTap: () {
    //     HapticFeedback.heavyImpact();

    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ChatScreen(name: name, userName: userName),
    //       ),
    //     );
    //   },
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: Image.network(
    //           myProfilePic,
    //           height: 30,
    //           width: 30,
    //         ),
    //       ),
    //       Column(
    //         children: [
    //           Text(name),
    //           12.heightBox,
    //           Text(widget.lastMessage),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
