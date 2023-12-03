import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/RegistrationPage.dart';
import '../../GlobalTools/FormButton.dart';
import '../../GlobalTools/LanguageButtons.dart';
import '../Shop/Products/ProductList.dart';
import 'Models/Account.dart';



class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Locale _currentLocale = const Locale('en', 'US');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false; // Flag to track form submission status


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController=TextEditingController();


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

  // @override
  // void initState() {
  //   super.initState();
  //   _loadAccountData();
  // }
  //
  // void _loadAccountData() async {
  //   final accountData = await SessionManager.getAccountData();
  //   if(accountData!=null){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen()));
  //   }
  // }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Perform your custom login logic here
      setState(() {
        _isSubmitting=true;
      });

      String Email = _emailController.text;

      var url = 'https://portalapps.azurewebsites.net/api/Accounts/Login';

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
          prefs.setString('userEmail', _emailController.text);
          prefs.setString('RowKey', _account.rowKey);
          prefs.setString('preferdLanguage', _account.preferdLanguage);

          // Request successful, handle the response
          // Send confirmation email after successful Login
          _showMessage('Account Authenticated Successfully: , $Email',
              Colors.lightGreen);
          print(response.body);
          Navigator.push(context, MaterialPageRoute(builder:
              (context) => ProductList(),
              settings: RouteSettings(
                  arguments:
                  _currentLocale.languageCode
              )));

        } else {
          // Request failed, handle the error
          print('POST request failed with status code ${response.statusCode}');
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
    TextDirection textDirection =
    _currentLocale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    return  Directionality(
      textDirection: textDirection,
      child: Scaffold(
        key: _scaffoldKey ,
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "LoginForm")),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  TextFormField(
                    //initialValue: "e.jawadfazza@gmail.com",
                    controller: _emailController,
                    validator: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "email"),
                      prefixIcon: const Icon(Icons.email),
                      enabled: !_isSubmitting,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  TextFormField(
                    //initialValue: "Apps@SYRDA12345",
                    controller: _passwordController,
                    validator: (value) => _validatePassword(value),

                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "password"),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    enabled:! _isSubmitting,
                  ),
                  const SizedBox(height: 16.0),

                  FormButton(isSubmitting: _isSubmitting, onPressed: _submitForm,titleValue: FlutterI18n.translate(context, "LoginAccount")),
                  const SizedBox(height: 16.0),
                  TextButton(
                      onPressed:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            RegistrationPage(),
                        ));

                      },
                      child: Text(FlutterI18n.translate(context, "RegisterAccount")))
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: LanguageButtons(
          currentLocale: _currentLocale,
          changeLanguage: _changeLanguage,
        ),
      ),
    );

  }


}
