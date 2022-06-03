import 'package:flutter/material.dart';

Route _animationRightLeft(Widget destination) => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    });

void push(BuildContext context, Widget destination) =>
    Navigator.push(context, _animationRightLeft(destination));

void pushAndRemove(BuildContext context, Widget destination) =>
    Navigator.pushAndRemoveUntil(
        context, _animationRightLeft(destination), (route) => false);

void doublePush(BuildContext context, Widget first, Widget second) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => first),
      (route) => false);
  Navigator.push(context, _animationRightLeft(second));
}
