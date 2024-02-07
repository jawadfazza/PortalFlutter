import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/Models/Account.dart';
import 'package:shopping/GlobalTools/bottomNavigationBar.dart';
import 'package:shopping/Shop/Products/ProductList.dart';
import 'package:shopping/Shop/Stores/StoreList.dart';
import 'package:shopping/main.dart';
import '../GlobalTools/AppConfig.dart';
import '../GlobalTools/FormButton.dart';
import '../GlobalTools/LocalizationManager.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isPageLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false; // Flag to track form submission status
  String? RowKey ="";
  String _selectedGender = '';
  String _preferredLanguage='';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _preferredLanguageController = TextEditingController();

  Locale currentLocale = LocalizationManager().getCurrentLocale();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(context, "invalidEmail");
    }
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',);
    if (!emailRegex.hasMatch(value)) {
      return FlutterI18n.translate(context, "InvalidEmailFormate");
    }
    return null;
  }

  String? _validateFullNname(String? value) {
    if (value == null || value.isEmpty) {
      return FlutterI18n.translate(context, "invalidFullName");
    }
    return null;
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
  void initState() {
    super.initState();
    setState(() {
      isPageLoading = true;
    });
    fetchDataProfile().then((value) {
      setState(() {
        isPageLoading = false;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Perform your custom login logic here
      setState(() {
        _isSubmitting = true;
      });

      var url = '${AppConfig.baseUrl}/api/Accounts/Update';

      // Define the request headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      // Define the request body
      final body = jsonEncode({
        'PartitionKey': '1' ,
        'RowKey':RowKey,
        'fullName': _fullnameController.text,
        'email': _emailController.text,
        'PhoneNumber': _phoneController.text,
        'Gender': _selectedGender,
        'PreferdLanguage': _preferredLanguage
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
          _showMessage('Profile  registered successfully',
              Colors.lightGreen);
          print(response.body);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => MyApp()));
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
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        print(e);
      }
    }
  }

  Future<void> fetchDataProfile() async {
    //languageCode = _currentLocale.languageCode.toUpperCase();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RowKey = prefs.getString('RowKey');
    try {
      var url = '${AppConfig.baseUrl}/api/Accounts/GetByRowKey?RowKey=$RowKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        Account _account = Account.fromJson(jsonResponse);

        setState(() {
          _fullnameController.text = _account.fullName ?? '';
          _emailController.text = _account.email ?? '';
          _phoneController.text = _account.phoneNumber ?? '';
          _selectedGender= _account.gender ?? '';
          _preferredLanguage = _account.preferdLanguage ?? '';

          // Set other fields' values similarly
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void _showMessage(String message, Color messageColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: messageColor,
    );
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      FlutterI18n.refresh(context, newLocale);
    });
  }



  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = currentLocale.languageCode.toLowerCase() == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "registrationForm")),
        ),
        backgroundColor: Colors.white,
        body: isPageLoading?
        const Center(
          child: CircularProgressIndicator(), // Display a loading indicator
        ):
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "fullName"),
                      prefixIcon: const Icon(Icons.account_circle_sharp),
                    ),
                    // ...Other TextFormField widgets for email, phone, password, confirmPassword
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "email"),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    // ...Other TextFormField widgets for email, phone, password, confirmPassword
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, "phone"),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    // Validator and other properties
                  ),
                  const SizedBox(height: 16.0),
                  // To store the selected gender value
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, "SelectGender"),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _selectedGender == 'Male',
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value! ? 'Male' : '';
                                _genderController.text = _selectedGender; // Update the TextFormField value
                              });
                            },
                          ),
                          Text(
                            FlutterI18n.translate(context, 'Male'),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                          Checkbox(
                            value: _selectedGender == 'Female',
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value! ? 'Female' : '';
                                _genderController.text = _selectedGender; // Update the TextFormField value
                              });
                            },
                          ),
                          Text(
                            FlutterI18n.translate(context, 'Female'),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // To store the selected preferred language value
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                            context, "SelectPreferredLanguage"),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(

                            value: _preferredLanguage=='EN',

                            onChanged: (value) {
                              setState(() {
                                _preferredLanguage = value! ?'EN':'';
                                _preferredLanguageController.text =
                                'EN'; // Update the TextFormField value
                              });
                            },
                          ),
                          Text(
                            'English',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                          Checkbox(
                            value:  _preferredLanguage=='AR',

                            onChanged: (value) {
                              setState(() {
                                _preferredLanguage = value! ?'AR':'';
                                _preferredLanguageController.text =
                                'AR'; // Update the TextFormField value
                              });
                            },
                          ),
                          Text(
                            'العربية',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Add a widget to upload profile picture
                  const SizedBox(height: 32.0),
                  FormButton(
                    isSubmitting: _isSubmitting,
                    onPressed: _submitForm,
                    titleValue: FlutterI18n.translate(context, "Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

}
