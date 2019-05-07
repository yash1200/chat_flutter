import 'package:chat_app/about.dart';
import 'package:chat_app/chat.dart';
import 'package:chat_app/community.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  final widgets = [
    chat(),
    community(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      drawer: Drawer(
        child: about(),
      ),
      body: Center(
        child: widgets.elementAt(_cIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cIndex,
        fixedColor: Colors.indigo,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'Chats',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance,
                  color: Color.fromARGB(255, 0, 0, 0)),
              title: new Text(
                'Community',
                style: TextStyle(color: Colors.black),
              )),
        ],
        onTap: (index) {
          _incrementTab(index);
        },
      ),
    );
  }
}
