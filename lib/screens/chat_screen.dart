import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app_flutter/reuseable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';
import 'package:chat_app_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class ChatScreen extends StatefulWidget {
  static String id = '/chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String msg="";
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  final _chat_store = FirebaseFirestore.instance;
  void getCurrentLoggedInUser()async{
    loggedInUser=await getCurrentUser();
  }

  void getMessages()async{
    final messages = await _chat_store.collection("messages").get();
    for (var message in messages.docs)
      print(message.data);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                getMessages();
                // await FirebaseAuth.instance.signOut();
                // Fluttertoast.showToast(
                //   msg: "Logout Successful",
                // );
                // Navigator.pop(context,LoginScreen.id);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        msg = value;
                        print(msg);
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //msg text + sender
                      _chat_store.collection("messages").add({
                        'message_text':msg,
                        'sender': loggedInUser!.email,
                      });
                      Fluttertoast.showToast(
                        msg: "Message Sent ",
                      );

                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}