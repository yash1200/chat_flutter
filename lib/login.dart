import 'package:chat_app/homePage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> getUser() async{
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((_firebaseUser){
      if(_firebaseUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return homePage();
        }));
      }
    });
  }

  addStringToSF(String str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', str);
  }

  Future<FirebaseUser> _signIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );
    final FirebaseUser firebaseUser =
    await _auth.signInWithCredential(credential);
    if (firebaseUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid
        });
      }

      String str=firebaseUser.uid;
      addStringToSF(str);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return homePage();
      }));
    }
    print("User Name : ${firebaseUser.displayName}");
    return firebaseUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.indigo[600],
                    Colors.indigo[400],
                    Colors.indigo[200],
                    Colors.indigo[100],
                  ],
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  print("Button Clicked");
                  _signIn(context)
                      .then((FirebaseUser user) => print(user.displayName))
                      .catchError((e) => print(e));
                },
                color: Colors.black38,
                elevation: 5,
                child: Text(
                  "Google Sign-In",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
