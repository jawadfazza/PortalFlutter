import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/main.dart';
import '../GlobalTools/AppConfig.dart';
import 'Models/Account.dart';



class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Locale _currentLocale = const Locale('en', 'US');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
      FlutterI18n.refresh(context, newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    TextDirection textDirection =
    _currentLocale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    return  Directionality(
      textDirection: textDirection,
      child:  Scaffold(
        key: _scaffoldKey,
          body: Center(
              child: isSmallScreen
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _Logo(),
                  _FormContent(),
                ],
              )
                  : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: const [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: _FormContent()),
                    ),
                  ],
                ),
              ))),
    );

  }



}
class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Flutter!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // Flag to track form submission status


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();



  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(context, "invalidPassword");
    }

    if (value.length < 8) {
      return FlutterI18n.translate(context, "passwordLengthError");
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return FlutterI18n.translate(context, "passwordUppercaseError");
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return FlutterI18n.translate(context, "passwordLowercaseError");
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return FlutterI18n.translate(context, "passwordDigitError");
    }
    return null;
  }
  String? _validateEmail(String? value) {
    if(value ==null || value.isEmpty){
      return FlutterI18n.translate(context, "invalidEmail");
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',);
    if(!emailRegex.hasMatch(value)){
      return FlutterI18n.translate(context, "InvalidEmailFormate");
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Perform your custom login logic here
      setState(() {
        _isSubmitting=true;
      });
      var url = '${AppConfig.baseUrl}/api/Accounts/Login';
      // Define the request headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      // Define the request body
      final body = jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      });
      try {
        // Make the POST request
        final response = await http.post(
            Uri.parse(url), headers: headers, body: body);
        // Check the response status code
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          Account _account = Account.fromJson(jsonResponse);
          setState(() {
            _isSubmitting = false;
          });

          // Store user information after successful login
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('RowKey', _account.rowKey);
          prefs.setString('preferdLanguage', _account.preferdLanguage);

          // Request successful, handle the response
          print(response.body);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
        } else {
          // Request failed, handle the error
          print('POST request failed with status code ${response.statusCode}');
          print(response.body);
          setState(() {
            _isSubmitting = false;
          });
        }
      }catch(e){
        setState(() {
          _isSubmitting=false;
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              validator: (value) => _validateEmail(value),
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) => _validatePassword(value),
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {

                    _submitForm();
                    /// do something
                  }
                },
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {

                    //_submitForm();
                    /// do something
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
  }
