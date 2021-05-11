import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:g_chat/views/chatRoomsScreen.dart';

class DatabaseMethods {
  getUsersbyUsername(String username) async {
   return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();

  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
}