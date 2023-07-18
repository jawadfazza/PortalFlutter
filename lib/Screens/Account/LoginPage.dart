import 'package:flutter/material.dart';
import 'package:shopping/Screens/ProductListingScreen.dart';
import '../../Lan/AppLocalizations.dart';
import 'RegistrationPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add more email validation logic here if needed
    // Regular expression pattern for email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add more password validation logic here if needed
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform your custom login logic here
      String email = _emailController.text;
      String password = _passwordController.text;

      // Validate the email and password
      // Authenticate the user using your own backend or service

      // For testing purposes, simply print the email and password
      print('Email: $email');
      print('Password: $password');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListScreen(),
        ),
      );
      // Navigate to the next screen or perform necessary actions upon successful login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text( 'Click Shopping'),// Replace 'assets/logo.png' with your own logo image path
        centerTitle: true,

      ),
      body:

      Container(
        color: Colors.white,
        child: Column(

          children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Image.asset(
              
            'assets/logo.png', // Replace 'assets/logo.png' with your own image path
            height: 100,
              width: 100,
              
              // Adjust the height as needed
        ),
          )
            ,Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed:_submitForm,
                      child: Text('Login'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                        onPressed:() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                        },
                       child: Text(AppLocalizations.of(context)!.hello))
                  ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
