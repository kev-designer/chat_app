import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/search.dart';
import 'package:chat_app/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'colors.dart';
import 'const.dart';

//BACK ARROW ICON
AppBar buildAppBar(
  BuildContext context,
  String appbarTitle,
) {
  return AppBar(
    elevation: 1,
    shadowColor: ColorData.black.withOpacity(0.1),
    centerTitle: true,
    backgroundColor: Colors.white,
    leading: Padding(
      padding: const EdgeInsets.only(left: 20, right: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          HapticFeedback.heavyImpact();
        },
        child: SvgPicture.asset(
          "assets/svg/32/blue_left_arrow.svg",
        ),
      ),
    ),
    title: Text(
      appbarTitle,
      style: GoogleFonts.nunito(
        fontSize: height(context) * .025,
        fontWeight: FontWeight.w800,
        color: ColorData.black,
      ),
    ),
  );
}

// MAIN APP BAR
AppBar buildMainAppBar(
  BuildContext context,
  String appbarTitle,
) {
  return AppBar(
    centerTitle: true,
    elevation: 1,
    shadowColor: ColorData.black.withOpacity(0.1),
    backgroundColor: Colors.white,
    title: Text(
      appbarTitle,
      style: GoogleFonts.nunito(
        fontSize: height(context) * .025,
        fontWeight: FontWeight.w800,
        color: ColorData.black,
      ),
    ),
  );
}

// LOGOUT ICON
AppBar buildMessageAppBar(
  BuildContext context,
  String appbarTitle,
) {
  return AppBar(
    centerTitle: true,
    elevation: 1,
    shadowColor: ColorData.black.withOpacity(0.1),
    backgroundColor: Colors.white,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            //SEARCH
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              child: SvgPicture.asset(
                "assets/svg/32/search.svg",
              ),
            ),

            20.widthBox,
            //LOGOUT
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                AuthMethods().signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                });
              },
              child: SvgPicture.asset(
                "assets/svg/32/logout.svg",
                color: ColorData.red,
              ),
            ),
          ],
        ),
      ),
    ],
    title: Text(
      appbarTitle,
      style: GoogleFonts.nunito(
        fontSize: height(context) * .025,
        fontWeight: FontWeight.w800,
        color: ColorData.black,
      ),
    ),
  );
}

// SEARCH ICON
AppBar buildSeachIconAppBar(
  BuildContext context,
  String appbarTitle,
) {
  return AppBar(
    centerTitle: true,
    elevation: 1,
    shadowColor: ColorData.black.withOpacity(0.1),
    backgroundColor: Colors.white,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            //SEARCH
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
              },
              child: SvgPicture.asset(
                "assets/svg/32/search.svg",
              ),
            ),
          ],
        ),
      ),
    ],
    title: Text(
      appbarTitle,
      style: GoogleFonts.nunito(
        fontSize: height(context) * .025,
        fontWeight: FontWeight.w800,
        color: ColorData.black,
      ),
    ),
  );
}
