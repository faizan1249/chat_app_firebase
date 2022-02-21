import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


final _auth = FirebaseAuth.instance;
User? LoggedIn_User;

Future getCurrentUser ()async
{
  final user = await _auth.currentUser;
  try{
    LoggedIn_User = user;
    print(LoggedIn_User!.email);
    return LoggedIn_User;
  }
  catch(e)
  {
    print("Error: $e");
  }

}

Future loginUser (String email, String _password) async
{
  try{
    UserCredential user_cred = await _auth.signInWithEmailAndPassword
      (email: email, password: _password).catchError((err){print("Error: $err");});
    print(user_cred);
    return user_cred;

  } on FirebaseAuthException catch(e)
  {
    if(e.code == 'user-not-found'){
      print('No user found for that email.');
    }
    else if(e.code == 'wrong-password'){
      print('Wrong password provided for that user.');
    }
  }
  catch(e)
  {
    print(e);
  }

}




Future registerUser(String email,String _password)async
{
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: _password,
    ).catchError((err) {print("fb error $err");});

    return userCredential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }

  } catch (e) {
    print("Error: $e");
  }
}

class ReuseableButton extends StatelessWidget {
  ReuseableButton({
    required this.btnText,
    required this.onPressed,
    required this.bgColor
  });


  String btnText;
  final Function() onPressed;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: bgColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
           onPressed: onPressed,
          //() {
          //   //Go to login screen.
          //     Navigator.pushNamed(context,LoginScreen.id);
          // },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            btnText,
          ),
        ),
      ),
    );
  }
}





