import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../reuseable.dart';
import '../constants.dart';
import 'package:chat_app_flutter/reuseable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/registerScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email="";
  String password="";
  bool showSpinner=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true);
                ],
                onChanged: (value) {
                  email = value;
                  print(email);
                },
                decoration: kRegisterTextFieldEmail,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  print(password);
                },
                decoration: kRegisterTextFieldDecorationPassword
              ),
              SizedBox(
                height: 24.0,
              ),
              ReuseableButton(
                btnText: "Register",
                bgColor: Colors.blueAccent,
                onPressed: () async{
                  setState(() {
                    showSpinner=true;
                  });
                  final newUser = await registerUser(email,password);
                  print(newUser);
                  if(newUser != null)
                    {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                  else
                    {
                      Fluttertoast.showToast(
                        msg: "This Email is Already Exist",
                      );
                    }
                  setState(() {
                    showSpinner=false;
                  });


                  //Implement registration functionality.
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}