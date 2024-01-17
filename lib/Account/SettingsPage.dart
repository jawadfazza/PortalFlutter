// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/Profile.dart';

import '../Shop/Stores/_ProductInfo.dart';
import 'LoginPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<SettingsPage> {
  bool? _isDark = false;


  // Sign-out method
  void _signOut() async {
    // Clear user session data (e.g., remove stored preferences or reset authentication state)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Clear stored preferences or remove specific keys as needed

    // Navigate to the login page after signing out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark! ? ThemeData.dark() : ThemeData.light(),

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                        title: "Dark Mode",
                        icon: Icons.dark_mode_outlined,
                        trailing: Switch(
                            value: _isDark!,
                            onChanged:  (value) {
                              setState(()  async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool('_isDark', value);
                              });
                            })),
                    const _CustomListTile(
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Security Status",
                        icon: CupertinoIcons.lock_shield),
                  ],
                ),
                const Divider(),
                 _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                        title: "Profile", icon: Icons.person_outline_rounded, onTap:() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Profile(),
                        ),
                      );

                    }),
                    const _CustomListTile(
                        title: "Messaging", icon: Icons.message_outlined),
                     const _CustomListTile(
                        title: "Calling", icon: Icons.phone_outlined),
                     const _CustomListTile(
                        title: "People", icon: Icons.contacts_outlined),
                      const _CustomListTile(
                        title: "Calendar", icon: Icons.calendar_today_rounded)
                  ],
                ),
                const Divider(),
                  _SingleSection(
                  children: [
                    const _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded),
                    const _CustomListTile(
                        title: "About", icon: Icons.info_outline_rounded),
                    _CustomListTile(
                        title: "Sign out", icon: Icons.exit_to_app_rounded,onTap: _signOut),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap; // Callback for onTap
   const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap, // Accepting the callback in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap, // Executing the callback on tap
    );
  }
}


class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}