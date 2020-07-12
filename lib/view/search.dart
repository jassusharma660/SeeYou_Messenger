import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messangerforseeyou/services/database.dart';
import 'package:messangerforseeyou/helper/constants.dart';
import 'package:messangerforseeyou/view/conversationScreen.dart';
import 'package:messangerforseeyou/widgets/widget.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  var searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async{
    if(searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
       databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
        setState(() {
          searchSnapshot = val;
        });
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  /// create chat room, send user to conversation, push replacement
  createChatRoomAndStartConversation({String username}) {
    if(username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            username: username,
            chatRoomId: chatRoomId,
          )
      ));
    }
    else {
      print("You can't send yourself a message.");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x110000000),
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(userEmail),
            ],
          ),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xff000000),
                border: Border.all(
                  color: Color(0x11000000),
                  width: 1,
                ),
              ),
              child: Text(
                "Message",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    print("Called => searchList");
    return haveUserSearched ?  ListView.builder(
      itemCount: searchSnapshot.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if(searchSnapshot.documents[index].data["name"]==Constants.myName) {
          return Container(
            alignment: Alignment.center,
            child:Text("Hurray! Its your username.", style: TextStyle(fontWeight: FontWeight.bold),),
          );
        }
        else {
          return searchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }
      }
    ) :
    Container(
      padding: EdgeInsets.only(top: 50),
      child:Text("Nothing here."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // App Logo
          appBarSecondary(
            context: context,
            title: "Find Friend",
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xfffafafa),
              border: Border.all(
                color: Color(0x11000000),
                width: 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.search,
                      color: Color(0xaa000000),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchTextEditingController,
                    onSubmitted: (username) {
                     initiateSearch();
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search",
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
              ],
            ),
          ),
          Container(
              child: isLoading ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) :searchList()),
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
    return "$b\_$a";
  else
    return "$a\_$b";
}