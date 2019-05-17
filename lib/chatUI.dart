import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class chatUI extends StatefulWidget {
  String chatUserId;

  chatUI({Key key, @required this.chatUserId}) : super(key: key);

  @override
  _chatUIState createState() => _chatUIState(chatUserId: chatUserId);
}

// ignore: camel_case_types
class _chatUIState extends State<chatUI> {
  String chatUserId;

  _chatUIState({Key key, @required this.chatUserId});

  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      userName = user.displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUserId),
      ),
      body: Column(
        children: <Widget>[buildListMessages(), typeMessage()],
      ),
    );
  }

  Widget buildListMessages() {
    return Container();
  }

  Widget typeMessage() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 50,
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Type a Message...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          ),
          Material(
            child: Icon(
              Icons.send,
              size: 50,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}
