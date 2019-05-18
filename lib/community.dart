import 'package:chat_app/chatUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: camel_case_types
class community extends StatefulWidget {
  @override
  _communityState createState() => _communityState();
}

// ignore: camel_case_types
class _communityState extends State<community> {
  FirebaseUser firebaseUser;
  String userid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      userid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Firestore.instance.collection('users').getDocuments(),
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
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    String id = document['id'].toString();
    String name = document['nickname'].toString();
    print("userid is:$userid");
    print("Document id:$id");
    if (userid != id) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        child: ListTile(
          title: Text("$name"),
          leading: Material(
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
              imageUrl: document['photoUrl'],
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.message,
              color: Colors.indigo,
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return chatUI(chatUserId: name,userId: userid,customId: id);
              }));
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
