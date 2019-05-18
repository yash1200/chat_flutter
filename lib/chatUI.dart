import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class chatUI extends StatefulWidget {
  String chatUserId, userId, customId;

  chatUI(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId})
      : super(key: key);

  @override
  _chatUIState createState() =>
      _chatUIState(chatUserId: chatUserId, userId: userId, customId: customId);
}

// ignore: camel_case_types
class _chatUIState extends State<chatUI> {
  String chatUserId, userId, customId, groupId;
  TextEditingController textEditingController = new TextEditingController();

  _chatUIState(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
  }

  readLocal() {
    if (userId.hashCode <= customId.hashCode) {
      groupId = '$userId-$customId';
    } else {
      groupId = '$customId-$userId';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUserId),
      ),
      body: new Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: new Container(
            child: new Column(
              children: <Widget>[
                buildListMessages(),
                Divider(height: 1.0),
                typeMessage(),
              ],
            ),
          )),
    );
  }

  Widget buildListMessages() {
    return Flexible(
      child: Container(),
    );
  }

  Widget typeMessage() {
    return Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: new IconTheme(
            data: new IconThemeData(color: Theme.of(context).accentColor),
            child: new Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: 48.0,
                    height: 48.0,
                    child: new IconButton(
                        icon: Icon(Icons.image), onPressed: () => () {}),
                  ),
                  new Flexible(
                    child: new TextField(
                      controller: textEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Enter message"),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 2.0),
                    width: 48.0,
                    height: 48.0,
                    child: new IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => () {
                          print(textEditingController.text);
                              sendMsg(textEditingController.text);
                            }),
                  ),
                ],
              ),
            )));
  }

  void sendMsg(String message) {
    print(message);
    if (message.trim() != '') {
      textEditingController.clear();
      Firestore.instance.collection('messages').document(groupId).setData({
        'idFrom': userId,
        'idTo': customId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'message': message,
      });
    }
  }
}
