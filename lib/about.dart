import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

// ignore: camel_case_types
class _aboutState extends State<about> {
  String url1;

  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  getImageURL() async {
    var user = Firestore.instance.collection("users").document(await getUid());
    DocumentSnapshot documentSnapshot = await user.get();
    String url2 = documentSnapshot['photoUrl'];
    print("URL is:$url2");
    return url2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: getImageURL(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),
              );
            } else {
              return Container(
                child: Image.network(snapshot.data),
              );
            }
          },
        ),
      ],
    );
  }
}
