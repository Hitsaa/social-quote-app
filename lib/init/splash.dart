import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quoteapp/login/login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow, child: Text("Quote App"));
    // FlutterLogo(size: MediaQuery.of(context).size.height));
  }
}
