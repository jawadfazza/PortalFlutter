import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FormButton extends StatelessWidget {
  final bool isSubmitting;
  final Function() onPressed;
  final String titleValue;
  FormButton({
    required this.isSubmitting,
    required this.onPressed,
    required this.titleValue
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isSubmitting ? null : onPressed,
      icon: isSubmitting
          ? SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(),
      )
          : Icon(Icons.person),
      label: Text(titleValue),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48.0),
      ),
    );
  }
}
