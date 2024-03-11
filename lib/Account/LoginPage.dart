import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Shop/View/Products/ProductList.dart';
import 'package:shopping/main.dart';
import '../GlobalTools/AppConfig.dart';
import '../GlobalTools/CustomPageRoute.dart';
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
              child: SingleChildScrollView(
                child: isSmallScreen
                    ? SingleChildScrollView(child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    _Logo(),
                    _FormContent(),
                  ],
                ))
                    : SingleChildScrollView(
                      child: Container(
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
                  )),
              ),
          )),
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
        Image.asset(
          'assets/Logo/logo.png', // Replace with your custom image asset path
          width: isSmallScreen ? 250 : 350,
          height: isSmallScreen ? 250 : 350,
        ),
        const SizedBox(height: 15)
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
  bool _rememberMe = true;
  bool _isSubmitting = false; // Flag to track form submission status
  static String _RowKey="";
  static String _preferdLanguage="";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          prefs.setBool('_isDark', false);
          prefs.setString('preferdLanguage', _account.preferdLanguage);
          prefs.setInt('RememberMe', _rememberMe?1000:1);

          // Request successful, handle the response
          print(response.body);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
          //Navigator.push(context, CustomPageRoute(widget: MyApp()),);

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

// Future<void> _handleGoogleSignIn() async {
//   try {
//     final GoogleSignInAccount? googleSignInAccount =
//     await GoogleSignIn(clientId: "915786824433-mhgrdj6f8s33eav772e3dsft3t9vdoil.apps.googleusercontent.com",
//       scopes: ['email']).signIn();

//     if (googleSignInAccount != null) {
//       // Successfully signed in with Google, now you can use the user's information
//       // For example, you can access googleSignInAccount.email, googleSignInAccount.displayName, etc.
//       print('Google Sign In Success: ${googleSignInAccount.email}');
//     } else {
//       // User canceled the Google sign-in
//       print('Google Sign In Canceled');
//     }
//   } catch (error) {
//     print('Error during Google Sign In: $error');
//   }
// }

// Define a boolean flag to track whether the async operation is in progress
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child:  SingleChildScrollView(
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: isSubmitting
                      ? null // Button is disabled while the async operation is in progress
                      : () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Set the flag to true before starting the async operation
                      setState(() {
                        isSubmitting = true;
                      });

                      await _submitForm();

                      // Set the flag back to false after the async operation is complete
                      setState(() {
                        isSubmitting = false;
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              _gap(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  //onPressed: () => _handleGoogleSignIn(),
                  onPressed: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/Logo/google_logo.png', // Replace with the path to your Google logo asset
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _gap(),
              SizedBox(
                width: double.maxFinite,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Adjust text button style here (e.g., padding, text color, etc.)
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ??  false) {
                      // Perform actions when the button is pressed
                      // _submitForm();
                      /// do something
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue), // Adjust text style as needed
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
  }
