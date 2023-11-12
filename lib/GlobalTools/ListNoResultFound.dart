
import 'package:flutter/material.dart';

class ListNoResultFound extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(
        'No results found',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

}
