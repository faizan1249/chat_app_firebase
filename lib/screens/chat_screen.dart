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
import 'package:chat_app_flutter/model/chat_screen_model.dart';


User? loggedInUser;
final _auth = FirebaseAuth.instance;


class ChatScreen extends StatefulWidget {
  static String id = '/chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fieldText = TextEditingController();
  void clearField ()
  {
    fieldText.clear();
  }

  String msg="";
  final _chat_store = FirebaseFirestore.instance;
  void getCurrentLoggedInUser()async{
    loggedInUser=await getCurrentUser();
  }

  void getMessages()async{
    //  final messages = await _chat_store.collection("messages").get();
    // for (var message in messages.docs)
    //   print(message.data());
  }


  void getStreamOfMessages() async{
   await for(var snapshots in _chat_store.collection("messages").snapshots()){
     for (var message in snapshots.docs)
       print(message.data());
   }
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
                try{
                  getStreamOfMessages();
                }
                catch(e)
                {
                  print("Error: $e");
                }
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
            Expanded(
              child: MessageStream(firestoreInstance: _chat_store,),
            ),

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
                      controller: fieldText,
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
                      setState(() {
                        clearField();
                      });

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






class MessageStream extends StatelessWidget {
  MessageStream({
    required this.firestoreInstance,
  });
  FirebaseFirestore firestoreInstance;
  bool? isMee;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance.collection("messages").snapshots(),
        builder: (BuildContext context,snapshot) {
          if(snapshot.hasError)
          {
            return Text("Something Went Wrong");
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading");
          }
          if(!snapshot.hasData)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index)
            {
              DocumentSnapshot documents = snapshot.data!.docs[index];
              final msgText = documents['message_text'];
              final msgSender = documents['sender'];
              // final currentUser = loggedInUser;
              final currentLoginUser = loggedInUser!.email;
              print("Current Login User is :: $currentLoginUser");

              if(currentLoginUser == msgSender){

              }


              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessageBubble(msgtext: msgText,
                                sender: msgSender,
                                isMee:currentLoginUser == msgSender,

                  ),

                  // Text("$msgText is from $msgSender",style: TextStyle(fontSize: 14.0),),
                ],
              );
            },
          );
        }
    );
  }
}









class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.msgtext,
    required this.sender,
    required this.isMee,
  });
  String msgtext='';
  String sender='';
  bool isMee;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
              isMee==true?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text("$sender",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black45,
            ),

          ),
          Container(
            child: Material(
              elevation: 5.0,
              color: isMee==true?Colors.lightBlueAccent:Colors.white70,
              // borderRadius: BorderRadius.circular(20),
              borderRadius: isMee==true?

              BorderRadius.only(topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)):


              BorderRadius.only(topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),


              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: Text("$msgtext",style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



