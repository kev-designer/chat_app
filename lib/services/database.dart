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

  //ADD MESSAGE
  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  //UPDATE LAST MESSGAE SENT
  updateLastMessageSent(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  //CREATE  CHAT ROOM
  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      //CAHT ROOM ALREADY EXITS
      return true;
    } else {
      //CHAT ROOM DOES NOT EXITS
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  //GET CHAT ROOM MESSSAGE
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}
