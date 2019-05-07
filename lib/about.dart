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
  FirebaseUser firebaseUser;
  String name, email, url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      name = user.displayName;
      email = user.email;
      url = user.photoUrl;
    });
    FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        firebaseUser = snapshot.data;
      },
    );
  }

  Future<String> getUid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
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
    print("Name is:$name");
    print("NNnname is:$firebaseUser.displayName");
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("yash"),
          accountEmail: Text("yash"),
          currentAccountPicture: FutureBuilder(
            future: getImageURL(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                      child: Image.network(
                    snapshot.data,
                    fit: BoxFit.fill,
                  )),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
