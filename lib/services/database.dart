import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersbyUsername(String username) async {
   return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();

  }
  getUsersbyUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e){
      print(e.toString());
    });
  }
  Future <void> createChatRoom(chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  Future <void> addConversionMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print(e.toString());
    });
  }

  getConversionMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).collection("chats").orderBy("time").snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance.collection("chatRoom").where("users", arrayContains: userName).snapshots();
  }

}