import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersbyUsername(String username) async {
   return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }

  getUsersbyUserEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get().catchError((e){
      print(e.toString());
    });
  }

 Future<void> uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e){
      print(e.toString());
    });
  }

  Future <void> createChatRoom(chatroomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("chatRoom").doc(chatroomId).set(chatRoomMap).catchError((e){
      print(e);
    });
  }

  Future <void> addConversionMessage(String chatroomId, messageMap) {
    FirebaseFirestore.instance.collection("chatRoom").doc(chatroomId).collection("chats").add(messageMap).catchError((e) {
      print(e.toString());
    });
  }

  getConversionMessage(String chatroomId) async {
    return FirebaseFirestore.instance.collection("chatRoom").doc(chatroomId).collection("chats").orderBy("time").snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance.collection("chatRoom").where("users", arrayContains: userName).snapshots();
  }
}