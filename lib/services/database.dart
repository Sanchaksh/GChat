import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersbyUsername(String username) async {
   return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();

  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
}