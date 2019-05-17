import 'package:chat_app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

// ignore: camel_case_types
class _aboutState extends State<about> {
  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              return UserAccountsDrawerHeader(
                accountEmail: Text(
                  snapshot.data.email,
                ),
                accountName: Text(
                  snapshot.data.displayName,
                  style: TextStyle(fontSize: 20),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 100,
                  child: ClipOval(
                    child: Image.network(
                      snapshot.data.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        ListTile(
          title: Text("Sign Out"),
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          onTap: (){
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return login();
            }));
          },
        )
      ],
    );
  }
}
