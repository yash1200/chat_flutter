import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class community extends StatefulWidget {
  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  FirebaseUser firebaseUser;
  String userid;
  int count = 0;

  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
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
    String id = document['nickname'].toString();
    print("Document id:$id");
    return Padding(
      padding: const EdgeInsets.only(bottom: 5,top: 5),
      child: ListTile(
        title: Text("$id"),
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
      ),
    );
  }
}