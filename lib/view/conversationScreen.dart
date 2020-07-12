import 'package:flutter/material.dart';
import 'package:messangerforseeyou/helper/constants.dart';
import 'package:messangerforseeyou/services/database.dart';
import 'package:messangerforseeyou/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {

  final String username;
  final String chatRoomId;

  ConversationScreen({this.username, this.chatRoomId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      padding: EdgeInsets.only(bottom: 70),
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                isSendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) :
          Container(
            alignment: Alignment.center,
            child:Text("Type message to start a conversation.", style: TextStyle(fontWeight: FontWeight.bold),),
          );
        },
      ),
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[

            chatMessageList(),

            // App Logo
            appBarSecondary(
              context: context,
              title: widget.username,
              raised: true,
              backgroundColor: Colors.white,
            ),

            // Main area
            Container(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: <Widget>[

                  //Chat Input
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xfffafafa),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 10.0)
                        )],
                      border: Border.all(
                        color: Color(0x11000000),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            onSubmitted: (e) {
                              sendMessage();
                            },
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              hintText: "Type a message",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.send,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
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

  MessageTile({this.message, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, right: isSendByMe ? 20:100, left: isSendByMe ? 100:20,),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSendByMe ? Color(0xFFECF4FF) : Color(0xFFF8F8F8),
          border: Border.all(
            width: 1,
            color: Color(0x10000000),
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ) : BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
