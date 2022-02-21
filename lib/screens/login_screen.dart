import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../reuseable.dart';
import '../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class LoginScreen extends StatefulWidget {
  static String id = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? user_email;
  String? user_pass;
  bool showSpinner=false;
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  user_email = value;
                  print(user_email);
                  //Do something with the user input.
                },
                decoration: kLoginFieldEmailDecoration,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  user_pass = value;
                  print(user_pass);
                  //Do something with the user input.
                },
                decoration: kLoginFieldPasswordDecoration,
              ),
              SizedBox(
                height: 24.0,
              ),
              ReuseableButton(btnText: "Login", onPressed: ()async{
                setState(() {
                  showSpinner=true;
                });
                final loggedInUser = await loginUser(user_email.toString(),user_pass.toString());

                if(loggedInUser !=null)
                  {
                    print(loggedInUser);
                    print("user Logged in");
                    Fluttertoast.showToast(
                      msg: "User Logged in",
                    );
                    Navigator.pushReplacementNamed(context, ChatScreen.id);
                    setState(() {
                      showSpinner=false;
                    });
                  }
                else if(loggedInUser ==null){
                  print(loggedInUser);
                  Fluttertoast.showToast(
                    msg: "Please Register First",
                  );
                }
              }, bgColor: Colors.lightBlueAccent)
            ],
          ),
        ),
      ),
    );
  }
}