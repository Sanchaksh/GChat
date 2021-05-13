import 'package:flutter/material.dart';
import 'package:g_chat/helper/authenticate.dart';
import 'package:g_chat/helper/constants.dart';
import 'package:g_chat/helper/helperfunctions.dart';
import 'package:g_chat/services/auth.dart';
import 'package:g_chat/services/database.dart';
import 'package:g_chat/views/conversation_screen.dart';
import 'package:g_chat/views/search.dart';
import 'package:g_chat/widgets/widget.dart';


class chatRoom extends StatefulWidget {

  @override
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {

  Stream chatRoomsStream;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget chatRoomList() {
    return StreamBuilder(stream: chatRoomsStream,builder: (context, snapshot){
      return snapshot.hasData
          ? ListView.builder(
          itemCount:snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return chatRoomsTile(
              userName: snapshot.data.docs[index].data()["chatRoomId"].toString().replaceAll("_","").replaceAll(Constants.myName, ""),
              chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
            );
          }) : Container();
    },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots){
      setState(() {
        chatRoomsStream = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
          height: 50,),
        actions: [
          GestureDetector(
              onTap: (){
                authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8,),
                child: Icon(Icons.exit_to_app),
              )
          )
        ],
      ),
      body: Container(child: chatRoomList(),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class chatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  chatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationSceen(chatRoomId : chatRoomId))
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.green,
              ),
              child: Text("${userName.substring(0, 1).toUpperCase()}", style: mediumTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}

