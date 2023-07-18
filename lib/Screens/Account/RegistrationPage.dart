import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:shopping/Screens/Account/LoginPage.dart';
import 'package:http/http.dart' as http;

import '../../Lan/AppLocalizations.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  Locale _currentLocale = const Locale('en', 'US');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController=TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false; // Flag to track form submission status

  bool _isPasswordMatch = true;

  String? _validatePasswordMatch(String? value) {
    setState(() {
      _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;

    });
    return (_isPasswordMatch ?null:  'Please enter your confirmed Password');
  }
  String? _validatePassword(String? value) {
    _isPasswordMatch=false;
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }

    return null;
  }
  String? _validateFullNname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Full Name';
    }
  }
  String? _validateEmail(String? value) {
      if(value ==null || value.isEmpty){
        return 'Please enter your email';
      }
      final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',);
      if(!emailRegex.hasMatch(value)){
        return 'Please enter a valid email address';
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
      String FullName = _fullnameController.text;
      String Email = _emailController.text;
      String Password = _passwordController.text;

        var url = 'https://portalapps.azurewebsites.net/api/Accounts/Create';

        // Define the request headers
        final headers = <String, String>{
          'Content-Type': 'application/json',
        };

        // Define the request body
        final body = jsonEncode({
          'fullName': _fullnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });
        // Make the POST request
        final response = await http.post(Uri.parse(url), headers: headers, body: body);
        // Check the response status code
        if (response.statusCode == 200) {
          // Request successful, handle the response
          _showMessage('Account registered successfully: $FullName, $Email',Colors.lightGreenAccent);
          print(response.body);
          setState(() {
            _isSubmitting=false;
          });
        } else {
          // Request failed, handle the error
          print('POST request failed with status code ${response.statusCode}');
          _showMessage('POST request failed with status code ${response.statusCode}',Colors.deepOrangeAccent);
          print(response.body);
        }
    }
  }

  void _showMessage(String message,Color messageColor) {
    final snackBar = SnackBar(content: Text(message),backgroundColor: messageColor ,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _changeLanguage(Locale? locale) {

    setState(() {
      _currentLocale = locale ?? const Locale('en', 'US');
    });

  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations(_currentLocale);
    String email = _emailController.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.registrationForm),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          key: _scaffoldKey,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Registration Form',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullnameController,
                  validator: (value) => _validateFullNname(value),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  enabled:! _isSubmitting,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => _validateEmail(value),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    enabled: !_isSubmitting,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) => _validatePassword(value),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  enabled:! _isSubmitting,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  onChanged: (_) => _validatePasswordMatch,
                  validator:(value) =>  _validatePasswordMatch(value),

                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    errorText: _isPasswordMatch ? null : 'Passwords do not match',
                  ),
                  obscureText: true,
                  enabled: !_isSubmitting,
                ),
                SizedBox(height: 32.0),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting ? SizedBox(
                    height: 24.0, // Set the desired height for the CircularProgressIndicator
                    width: 24.0, // Set the desired width for the CircularProgressIndicator
                    child: CircularProgressIndicator(),
                    )
                      : Icon(Icons.person),
                  label: Text('Register New Account'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48.0), // Set the minimum size of the button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _changeLanguage(Locale('en')),
                child: Text('English'),
              ),
              SizedBox(width: 16.0),
              TextButton(
                onPressed: () => _changeLanguage(Locale('ar')),
                child: Text('العربية'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
