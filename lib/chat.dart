import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chatUI.dart';

// ignore: camel_case_types
class chat extends StatefulWidget {
  @override
  _chatState createState() => _chatState();
}

// ignore: camel_case_types
class _chatState extends State<chat> {
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Firestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
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
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  return buildItem(context, snapshot.data.documents[index]);
                },
                itemCount: snapshot.data.documents.length,
              );
            }
          }),
    );
  }

  Widget buildItem(BuildContext context, document) {
    if (uid == document['id1']) {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return chatUI(
                    chatUserId: document['nickname2'],
                    userId: document['id1'],
                    customId: document['id2'],
                    photoUrl: document['photoUrl2']);
              }));
            },
            title: Text(document['nickname2']),
            subtitle: Text(document['lastmessage']),
            isThreeLine: true,
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: document['photoUrl2'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      );
    } else if (uid == document['id2']) {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return chatUI(
                    chatUserId: document['nickname1'],
                    userId: document['id2'],
                    customId: document['id1'],
                    photoUrl: document['photoUrl1']);
              }));
            },
            title: Text(document['nickname1']),
            isThreeLine: true,
            subtitle: Text(document['lastmessage']),
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: document['photoUrl1'],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
