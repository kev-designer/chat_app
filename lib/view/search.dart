import 'package:chat_app/helperfunction/sharedpref_helper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/chat_screen.dart';
import 'package:chat_app/widget/appbar.dart';
import 'package:chat_app/widget/buttons.dart';
import 'package:chat_app/widget/colors.dart';
import 'package:chat_app/widget/textfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Stream? userStream;

  late String myName, myProfilePic, myUserName, myEmail;

  //
  getMyInfoFromSharedPreference() async {
    myName = (await SharedPreferenceHelper().getUserDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfilePic())!;
    myUserName = (await SharedPreferenceHelper().getUserName())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;

    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  getChatRoomIdByUserNames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

//BTN CLICK FUNCTION
  onSearchBtnClick() async {
    userStream = await DatabaseMethods().getUserByName(searchController.text);
    setState(() {});
  }

//SEARCH LIST
  Widget searchUserList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchUserTileList(
                    imageUrl: ds['imageUrl'],
                    name: ds['name'],
                    userName: ds['username'],
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("")],
                ),
              );
      },
    );
  }

//SEARCH USER TILE
  Widget searchUserTileList({required String imageUrl, name, userName}) {
    return Column(
      children: [
        32.heightBox,
        Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: ColorData.white,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.nunito(
                      color: ColorData.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  6.heightBox,
                  Text(
                    userName,
                    style: GoogleFonts.nunito(
                      color: ColorData.grey,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            12.widthBox,
            SmallColouredButton(
              textName: " Chat     ",
              onPressed: () {
                HapticFeedback.heavyImpact();

                //GENERATE CHAT ROOM ID
                var chatRoomId = getChatRoomIdByUserNames(myUserName, userName);
                Map<String, dynamic> chatRoomInfoMap = {
                  "users": [myUserName, userName]
                };
                DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(name: name, userName: userName)),
                );
              },
              textColor: ColorData.primary,
              borderColor: ColorData.primary,
              buttonColor: ColorData.white,
            ),
          ],
        ),
      ],
    );
  }

//INIT STATE
  @override
  void initState() {
    getMyInfoFromSharedPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Search"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Expanded(
            child: Column(
              children: [
                SearchBar(
                  hintText: "Search User by Full Name...",
                  controller: searchController,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      if (searchController.text != "") {
                        onSearchBtnClick();
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/svg/32/search.svg",
                    ),
                  ),
                ),
                searchUserList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
