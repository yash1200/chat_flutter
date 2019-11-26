import 'package:chat_app/about.dart';
import 'package:chat_app/chat.dart';
import 'package:chat_app/community.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

// ignore: camel_case_types
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
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff121212)
        ),
        child: BottomNavigationBar(
          currentIndex: _cIndex,
          backgroundColor: Color(0xff121212),
          fixedColor: Color(0xff121212),
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Color(0xffcf6679)),
                title: new Text(
                  'Chats',
                  style: TextStyle(color: Color(0xffcf6679)),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.people, color: Color(0xffcf6679)),
                title: new Text(
                  'Community',
                  style: TextStyle(color: Color(0xffcf6679)),
                )),
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ),
      ),
    );
  }
}
