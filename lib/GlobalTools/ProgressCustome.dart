import 'package:flutter/material.dart';

class ProgressCustom extends StatelessWidget {
  final Color? color;
  final double strokeWidth;
  final double size;

  ProgressCustom({this.color, this.strokeWidth = 5.0, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
