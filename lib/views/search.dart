import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_chat/helper/constants.dart';
import 'package:g_chat/services/database.dart';
import 'package:g_chat/widgets/widget.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile( //No idea how this works but it does LOL
            userName:  searchSnapshot.docs[index].data().toString().substring(searchSnapshot.docs[index].data().toString().indexOf(','), searchSnapshot.docs[index].data().toString().indexOf('}')).replaceAll('{userEmail:', '').replaceAll('userName:', '').replaceAll('}', '').replaceAll(',', ''),
            userEmail:  searchSnapshot.docs[index].data().toString().substring(searchSnapshot.docs[index].data().toString().indexOf(':'), searchSnapshot.docs[index].data().toString().indexOf(',')).replaceAll('{userEmail:', '').replaceAll('userName:', '').replaceAll('}', '').replaceAll(':', ''),
          );
        }) : Container();
  }


  initiateSearch() {
    databaseMethods.getUsersbyUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
     // print(val.toString());
      });
  }

  // Create Chatroom Function, send user for convo
  createChatroomAndStartConversation({String userName}) {
    if(userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationSceen(
        chatRoomId
      )
      ));
    } else {
      print("Khudko message karoge kya pagal bande ho?");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle(),),
              Text(userEmail, style: mediumTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(
                userName: userName,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(300),
              ),
              child: Text("Message", style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
   initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]
                          ),
                              borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

}

getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  }else {
    return "$a \_ $b";
  }
}

