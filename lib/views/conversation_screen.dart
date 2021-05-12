import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_chat/helper/constants.dart';
import 'package:g_chat/services/database.dart';
import 'package:g_chat/widgets/widget.dart';

class ConversationSceen extends StatefulWidget {
  String chatRoomId;
  ConversationSceen(this.chatRoomId);

  @override
  _ConversationSceenState createState() => _ConversationSceenState();
}

class _ConversationSceenState extends State<ConversationSceen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream ;

  Widget ChatMessageList() {
    return StreamBuilder(stream: chatMessageStream, builder: (context, snapshot) {
      return snapshot.hasData ? ListView.builder(itemCount: snapshot.data.docs.length, itemBuilder: (context, index){
        return MessageTile(snapshot.data.docs[index].data()["message"]);
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
      databaseMethods.addConversionMessage(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversionMessage(widget.chatRoomId).then((value){
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
  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message, style: mediumTextStyle(),),
    );
  }
}

