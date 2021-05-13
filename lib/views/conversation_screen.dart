import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_chat/helper/constants.dart';
import 'package:g_chat/services/database.dart';
import 'package:g_chat/widgets/widget.dart';

class ConversationSceen extends StatefulWidget {
  final String chatRoomId;
  ConversationSceen({this.chatRoomId});

  @override
  _ConversationSceenState createState() => _ConversationSceenState();
}

class _ConversationSceenState extends State<ConversationSceen> {

  TextEditingController messageController = new TextEditingController();

  Stream <QuerySnapshot> chatMessageStream ;

  Widget ChatMessageList() {
    return StreamBuilder(stream: chatMessageStream, builder: (context, snapshot) {
      return snapshot.hasData ? ListView.builder(itemCount: snapshot.data.docs.length, itemBuilder: (context, index){
        return MessageTile(
            message: snapshot.data.docs[index].data()["message"],
            isSendByMe: snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
      }) : Container();
    });
  }


  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseMethods().addConversionMessage(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getConversionMessage(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: simpleTextStyle(),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/images/send.png")
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({@ required this.message, @required this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ?  0 : 18,right: isSendByMe ? 18 : 0),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe ? [const Color(0xff007EF4), const Color(0xff2A75BC)] : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomLeft: Radius.circular(23)) : BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomRight: Radius.circular(23))
      ),
      child: Text(message, style: TextStyle(
        color: Colors.white,
        fontSize: 17,),
      ),)
    );
  }
}