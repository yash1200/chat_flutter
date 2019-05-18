import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class chatUI extends StatefulWidget {
  String chatUserId, userId, customId,photoUrl;

  chatUI(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId,
      @required this.photoUrl})
      : super(key: key);

  @override
  _chatUIState createState() =>
      _chatUIState(chatUserId: chatUserId, userId: userId, customId: customId, photoUrl: photoUrl);
}

// ignore: camel_case_types
class _chatUIState extends State<chatUI> {
  String chatUserId, userId, customId, groupId,photoUrl,photoUrl2,username2;
  TextEditingController textEditingController = new TextEditingController();

  _chatUIState(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId,
      @required this.photoUrl});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      username2=user.displayName;
      photoUrl2=user.photoUrl;
    });
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
      child: FutureBuilder(
        future: Firestore.instance
            .collection('messages')
            .document(groupId)
            .collection(groupId)
            .orderBy('timestamp', descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            );
          } else {
            return ListView.builder(
              reverse: true,
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return buildMessages(index,snapshot.data.documents[index]);
                });
          }
        },
      ),
    );
  }

  buildMessages(int index,DocumentSnapshot document){
    if(document['idFrom']==userId){
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(document['message']),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(document['message'])
          ],
        ),
      );
    }
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
                      onPressed: () {
                        print(textEditingController.text);
                        sendMsg(textEditingController.text);
                      },
                    ),
                  )
                ],
              ),
            )));
  }

  void sendMsg(String message) {
    if (message.trim() != '') {
      textEditingController.clear();
      Firestore.instance
          .collection('messages')
          .document(groupId)
          .collection(groupId)
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        'idFrom': userId,
        'idTo': customId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'message': message,
      });
      Firestore.instance.collection('messages').document(groupId).setData({
        'nickname1': chatUserId,
        'photoUrl1': photoUrl,
        'id1': customId,
        'id2': userId,
        'photoUrl2': photoUrl2,
        'nickname2': username2,
      });
    }
  }
}
