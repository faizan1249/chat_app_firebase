import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'chat_screen.dart';
import '../main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../reuseable.dart';
import '../constants.dart';
import 'chat_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/welcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  late var condition;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 3),
        vsync: this,
    );
    animation = ColorTween(begin: Colors.blueAccent,end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
    controller.addStatusListener((status) {
      print(status);
    });



  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    kAnimatedTextStyling,
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReuseableButton(
              btnText: "Login",
              onPressed:  () => Navigator.pushReplacementNamed(context,LoginScreen.id),
              bgColor: Colors.lightBlueAccent,
            ),
            ReuseableButton(
              btnText: "Register",
              onPressed:  () => Navigator.pushReplacementNamed(context,RegistrationScreen.id),
              bgColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}