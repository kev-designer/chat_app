import 'package:chat_app/helperfunction/sharedpref_helper.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurentUser() async {
    return await auth.currentUser;
  }

  //GOOGLE SIGN IN FUNCTION
  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email.toString());
      SharedPreferenceHelper().saveUserId(userDetails.uid.toString());
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper()
          .saveUserDisplayName(userDetails.displayName.toString());
      SharedPreferenceHelper()
          .saveUserProfilePic(userDetails.photoURL.toString());

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "imageUrl": userDetails.photoURL,
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      });
    }
  }

  //SIGOUT FUNCTION
  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
