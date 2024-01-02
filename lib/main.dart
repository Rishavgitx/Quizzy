import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Teacher.dart';
import 'SplashScreen.dart';

import 'EnterKey.dart';
import 'package:get/get.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height / 2.14,
                  child: Container(
                    child: Transform.scale(
                      scale: 0.7,
                      child: Image.asset(
                        'assets/images/logo-colourful.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 450,
                    constraints: BoxConstraints(),
                    // Create an instance of BoxConstraints
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFFF5793B),
                            Colors.white,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0.0),
                        topLeft: Radius.circular(0.0),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Select Your Role:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'FontMain1',
                              fontSize: 30,
                              shadows: [
                                Shadow(
                                  color: Color(0xFFF5793B),
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple, Color(0xFF3366FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Teacher()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'icons/icon/teacher.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'Teacher',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'FontMain',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueGrey,
                                  Color(0xFF33A1C9),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EnterKey()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'icons/icon/study.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'Student',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'FontMain',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
