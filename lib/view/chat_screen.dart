import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_app/helperfunction/sharedpref_helper.dart';
import 'package:chat_app/widget/appbar.dart';
import 'package:chat_app/widget/colors.dart';

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
  late String chatRoomId, messageId = "";
  late String myName, myProfilePic, myUserName, myEmail;
  late Stream messageStream;

  TextEditingController messageController = TextEditingController();

  //
  getMyInfoFromSharedPreference() async {
    myName = (await SharedPreferenceHelper().getUserDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfilePic())!;
    myUserName = (await SharedPreferenceHelper().getUserName())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;

    chatRoomId = getChatRoomIdByUserNames(widget.userName, myUserName);
  }

  //GET CHAT ROOM ID BY USER NAME
  getChatRoomIdByUserNames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  //ADD MESSAGE BY CLICK
  addMessage(bool sendClicked) {
    if (messageController.text != "") {
      String message = messageController.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imageUrl": myProfilePic
      };

      //MESSAGE ID
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSentTs": lastMessageTs,
          "lastMessageSendBy": myUserName,
        };

        //UPDATE MESSGAE SEND
        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          //REMOVE TEXT ON TEXT FIELD
          messageController.text = "";

          //MESSAGE ID BLANK TO GET NEW MESSGE SEND
          messageId = "";
        }
      });
    } else {}
  }

//
  getAndSetMessage() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
  }

//BUBBLE LIST
  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            color: (sendByMe
                ? ColorData.primary
                : ColorData.grey200.withOpacity(.35)),
          ),
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
          padding: const EdgeInsets.all(18),
          child: Text(
            message,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: (sendByMe ? ColorData.white : ColorData.black),
            ),
          ),
        ),
      ],
    );
  }

//
  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return chatMessageTile(
                      ds["message"], myUserName == ds["sendBy"]);
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

//
  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessage();
    setState(() {});
  }



  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, widget.name),
      body: Column(
        children: [
          //BODY PART
          Expanded(
            child: Container(
              child: chatMessages(),
            ),
          ),

          //TYPING TEXT
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TEXT MESSAGE TYPING
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        addMessage(false);
                      },
                      controller: messageController,
                      cursorColor: ColorData.primary,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: GoogleFonts.nunito(
                          color: ColorData.grey,
                          fontSize: 16,
                        ),
                      ),
                      style: GoogleFonts.nunito(
                        color: ColorData.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //GALLERY BTN
                  InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                    },
                    child: SvgPicture.asset(
                      "assets/svg/24/image.svg",
                      height: 38,
                    ),
                  ),
                  24.widthBox,

                  //SEND BUTTON
                  InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      addMessage(true);
                    },
                    child: SvgPicture.asset(
                      "assets/svg/24/send.svg",
                      height: 38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
