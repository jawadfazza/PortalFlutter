import 'package:flutter/material.dart';


class AlertMessage extends StatelessWidget {
  final String buttonText;
  final String confirmationText;
  final Function confirmFunction;

  AlertMessage({
    required this.buttonText,
    required this.confirmationText,
    required this.confirmFunction,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                confirmationText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                buttonText,
                style: TextStyle(fontSize: 16.0),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    confirmFunction(); // Call the provided function
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set button color
                  ),
                  child: Text(
                    "Yes",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400], // Set button color
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.delete, size: 28.0),
    );
  }
}
