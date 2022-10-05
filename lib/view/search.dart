import 'dart:html';

import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/appbar.dart';
import 'package:chat_app/widget/textfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Stream userStream;
  TextEditingController searchController = TextEditingController();

//BTN CLICK FUNCTION
  onSearchBtnClick() async {
    userStream =
        await DatabaseMethods().getUserByUserName(searchController.text);
    setState(() {});
  }

  Widget searchUserList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.documents.lenght,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index];
            return Image.network(ds["imageUrl"]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Search"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SearchBar(
                hintText: "Search User..",
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
    );
  }
}
