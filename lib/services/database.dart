import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userID, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .set(userInfoMap);
  }

  //GET USER BY NAME FUNCTION
  Future<Stream<QuerySnapshot>> getUserByName(String name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: name)
        .snapshots();
  }
}
