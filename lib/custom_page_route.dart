import 'package:flutter/material.dart';
import 'SplashScreen.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
    transitionDuration: Duration(seconds: 2),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,) {
    // Apply a bounce curve to the animation
    final Animation<double> bounceAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.bounceOut,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset.zero,
      ).animate(bounceAnimation), // Use bounceAnimation instead of animation
      child: child,
    );
  }
}
