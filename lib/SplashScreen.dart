import 'package:flutter/material.dart';
import 'main.dart';
import 'custom_page_route.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        CustomPageRoute(child: MyApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF5793B),
      // Set the desired background color here
      body: Center(
        child: Transform.scale(
          scale: 0.5,
          child:
        Image.asset(
          'assets/images/logo-white.png',
        ),
        ),
      ),
    );
  }
}
