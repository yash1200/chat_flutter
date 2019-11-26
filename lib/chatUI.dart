import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class chatUI extends StatefulWidget {
  String chatUserId, userId, customId, photoUrl;

  chatUI(
      {Key key,
      @required this.chatUserId,
      @required this.userId,
      @required this.customId,
      @required this.photoUrl})
      : super(key: key);

  @override
  _chatUIState createState() => _chatUIState(
      chatUserId: chatUserId,
      userId: userId,
      customId: customId,
      photoUrl: photoUrl);
}

// ignore: camel_case_types
class _chatUIState extends State<chatUI> {
  String chatUserId, userId, customId, groupId, photoUrl, photoUrl2, username2;
  TextEditingController textEditingController = new TextEditingController();
  int count1 = 0, count2 = 0;

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
    count1 = 0;
    count2 = 0;
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      username2 = user.displayName;
      photoUrl2 = user.photoUrl;
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
          decoration: BoxDecoration(color: Color(0xff020202)),
          width: double.infinity,
          height: double.infinity,
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
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('messages')
            .document(groupId)
            .collection(groupId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return buildMessages(index, snapshot.data.documents[index]);
              },
            );
          }
        },
      ),
    );
  }

  buildMessages(int index, DocumentSnapshot document) {
    if (document['idFrom'] == userId) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: Color(0xff2979ff),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(0))),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                decoration: BoxDecoration(
                    color: Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(8.0)),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget typeMessage() {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Color(0xffe6ecea)),
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
                      hintText: "Enter message",
                      hintStyle: TextStyle(color: Colors.black87)),
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
                    setState(() {
                      sendMsg(textEditingController.text);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
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
        'lastmessage': message,
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
        'photoUrl2': photoUrl2,
        'nickname2': username2,
      });
    }
  }
}
