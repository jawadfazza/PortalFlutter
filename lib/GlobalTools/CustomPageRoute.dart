import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;

  CustomPageRoute({required this.widget})
      : super(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

