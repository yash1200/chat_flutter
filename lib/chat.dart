import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class chat extends StatefulWidget {
  @override
  _chatState createState() => _chatState();
}

// ignore: camel_case_types
class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Firestore.instance.collection('messages').getDocuments(),
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
    return ListTile(
      title: Text(document['id1']),
    );
  }
}
