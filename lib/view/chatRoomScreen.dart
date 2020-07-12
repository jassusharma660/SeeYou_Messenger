import 'package:flutter/material.dart';
import 'package:messangerforseeyou/helper/authenticate.dart';
import 'package:messangerforseeyou/helper/constants.dart';
import 'package:messangerforseeyou/helper/helperFunctions.dart';
import 'package:messangerforseeyou/services/auth.dart';
import 'package:messangerforseeyou/services/database.dart';
import 'package:messangerforseeyou/view/search.dart';

import 'conversationScreen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot){
          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var names = snapshot.data.documents[index].data["chatRoomId"].toString().split("_");
              var username = (Constants.myName==names[0]) ? names[1] : names[0];
              return ChatRoomTiles(
                username: username,
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            }) :
          Container(
            alignment: Alignment.center,
            child:Text("Nothing here!", style: TextStyle(fontWeight: FontWeight.bold),),
          );
    });
  }

  @override
  void initState() {
    setUserConstants();
    super.initState();
  }

  setUserConstants() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // App Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Text(
                      "Messages",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  authMethod.signOut();
                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.exit_to_app),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 130),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height-130,
                      child: chatRoomList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff2143b1),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTiles extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomTiles({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(
              username: username,
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x11000000),
              width: 1,
            )
          )
        ),

        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${username.substring(0,1).toUpperCase()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              "$username",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
