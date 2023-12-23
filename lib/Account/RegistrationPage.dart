import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/GlobalTools/AppConfig.dart';
import '../../GlobalTools/FormButton.dart';
import '../../GlobalTools/LanguageButtons.dart';



class RegistrationPage extends StatefulWidget {

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  String languageCode ="";
  Locale _currentLocale = Locale("en");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false; // Flag to track form submission status
  bool _isPasswordMatch = true;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController=TextEditingController();
  TextEditingController _phoneController=TextEditingController();


  String? _validatePasswordMatch(String? value) {
    setState(() {
      _isPasswordMatch = _passwordController.text == _confirmPasswordController.text;

    });
    return (_isPasswordMatch ?null:  FlutterI18n.translate(context, "passwordConfirmed"));
  }
  String? _validatePassword(String? value) {
    _isPasswordMatch=false;
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
  String? _validateFullNname(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(context, "invalidFullName");
    }
  }
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(context, "invalidPhone");
    }

    // Define a phone number regex pattern
    final phoneRegex = RegExp(
      r'^\+?[0-9]{6,}$',
    );

    if (!phoneRegex.hasMatch(value)) {
      return FlutterI18n.translate(context, "invalidPhoneFormate");
    }

    return null;
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

        var url = '${AppConfig.baseUrl}/api/Accounts/Create';

        // Define the request headers
        final headers = <String, String>{
          'Content-Type': 'application/json',
        };

        // Define the request body
        final body = jsonEncode({
          'fullName': _fullnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'PhoneNumber': _phoneController.text,
        });
        try {
          // Make the POST request
          final response = await http.post(
              Uri.parse(url), headers: headers, body: body);
          // Check the response status code
          if (response.statusCode == 200) {
            setState(() {
              _isSubmitting = false;
            });
            // Request successful, handle the response
            // Send confirmation email after successful registration
            _showMessage('Account registered successfully: $FullName, $Email',
                Colors.lightGreen);
            print(response.body);
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            // Request failed, handle the error
            print(
                'POST request failed with status code ${response.statusCode}');
            _showMessage(
                'POST request failed with status code ${response.statusCode}',
                Colors.deepOrangeAccent);
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

  void _showMessage(String message,Color messageColor) {
    final snackBar = SnackBar(content: Text(message),backgroundColor: messageColor ,);
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
  }
  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
      FlutterI18n.refresh(context, newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(languageCode==""){
      languageCode =ModalRoute.of(context)?.settings.arguments as String;
      _changeLanguage(Locale(languageCode));
    }
    TextDirection textDirection =
    _currentLocale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        key: _scaffoldKey ,
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "registrationForm")),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous page
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _fullnameController,
                    validator: (value) => _validateFullNname(value),
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "fullName"),
                      prefixIcon: Icon(Icons.person),
                    ),
                    enabled:! _isSubmitting,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "email"),
                      prefixIcon: Icon(Icons.email),
                      enabled: !_isSubmitting,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) => _validatePhoneNumber(value),
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "phone"),
                      prefixIcon: Icon(Icons.phone),
                      enabled: !_isSubmitting,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) => _validatePassword(value),

                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "password"),
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
                      labelText: FlutterI18n.translate(context, "confirmPassword"),
                      prefixIcon: Icon(Icons.lock),
                      errorText: _isPasswordMatch ? null : FlutterI18n.translate(context, "passwordMatchError"),
                    ),
                    obscureText: true,
                    enabled: !_isSubmitting,
                  ),
                  SizedBox(height: 32.0),
                  FormButton(isSubmitting: _isSubmitting, onPressed: _submitForm,titleValue: FlutterI18n.translate(context, "RegisterAccount")),
                ],
              ),
            ),
          ),
        ),

      ),
    );

  }


}
