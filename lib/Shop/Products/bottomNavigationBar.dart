import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ProfileBottomNavigationBar extends StatefulWidget {
  final Function(int) onItemTapped;
  final int currentIndex;

  const ProfileBottomNavigationBar({
    Key? key,
    required this.onItemTapped,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _ProfileBottomNavigationBarState createState() =>
      _ProfileBottomNavigationBarState();
}

class _ProfileBottomNavigationBarState extends State<ProfileBottomNavigationBar> {



  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: FlutterI18n.translate(context, 'Home') ,
        ) ,
        BottomNavigationBarItem(
          icon: Icon(Icons.shop_2),
          label: FlutterI18n.translate(context,'Shops'),
        ) ,
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: FlutterI18n.translate(context, 'Profile'),
        ),
        // Add more items as needed for navigation or actions
      ],
      currentIndex: widget.currentIndex,
      onTap: widget.onItemTapped,
    );
  }
}
