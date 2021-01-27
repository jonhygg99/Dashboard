import 'package:dashboard/utils/authentication.dart';
import 'package:dashboard/utils/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../googleButton.dart';

class AuthDialog extends StatefulWidget {
  AuthDialog(this.cleanWidgets);
  final Function cleanWidgets;
  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  TextEditingController textControllerEmail;
  FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;
  TextEditingController textControllerPassword;
  FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;
  bool _isRegistering = false;
  bool _isLogIn = false;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerEmail.text = null;
    textFocusNodeEmail = FocusNode();
    textControllerPassword = TextEditingController();
    textControllerPassword.text = null;
    textFocusNodePassword = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widgetMaxSize = 450;
    return Dialog(
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: widgetMaxSize, maxWidth: widgetMaxSize),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Login/Sing Up',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 40.0,
                        letterSpacing: 2),
                  ),
                ),
                SizedBox(height: 20.0),
                Wrap(
                  runSpacing: 10.0,
                  children: [
                    Text('Email address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                    customTextField(
                        inputType: TextInputType.emailAddress,
                        controller: textControllerEmail,
                        onChange: (value) {
                          setState(() {
                            _isEditingEmail = true;
                          });
                        },
                        hintText: 'Email',
                        errorText: _isEditingEmail
                            ? _validateEmail(textControllerEmail.text)
                            : null,
                        widgetMaxSize: widgetMaxSize),
                  ],
                ),
                SizedBox(height: 20.0),
                Wrap(
                  runSpacing: 10.0,
                  children: [
                    Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                    customTextField(
                        inputType: TextInputType.visiblePassword,
                        controller: textControllerPassword,
                        onChange: (value) {
                          setState(() {
                            _isEditingPassword = true;
                          });
                        },
                        hintText: 'Password',
                        errorText: _isEditingPassword
                            ? _validatePassword(textControllerPassword.text)
                            : null,
                        widgetMaxSize: widgetMaxSize),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buttonRegistration('Sign up'),
                    buttonRegistration('Log in'),
                  ],
                ),
                SizedBox(height: 10.0),
                const Divider(
                  thickness: 2,
                  height: 20,
                  indent: 50,
                  endIndent: 50,
                ),
                SizedBox(height: 10.0),
                Center(child: GoogleButton(widget.cleanWidgets)),
                SizedBox(height: 20.0),
                Text('By proceeding, you agree to our Terms of Use, and confirm tou have read our Privacy Policy', style: TextStyle(color: Colors.black),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }
    return null;
  }

  String _validatePassword(String value) {
    if (textControllerEmail.text != null) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Password should have at least 6 characters';
      }
    }
    return null;
  }

  Flexible buttonRegistration(type) {
    return Flexible(
      flex: 1,
      child: FlatButton(
        minWidth: 200,
        color: Colors.blueGrey[800],
        hoverColor: Colors.blueGrey[900],
        highlightColor: Colors.black,
        onPressed: () async {
          if (_validateEmail(textControllerEmail.text) == null &&
              _validatePassword(textControllerPassword.text) == null) {
            setState(() {
              if (type == 'Sign up') {
                _isRegistering = true;
                _isLogIn = false;
              } else {
                _isRegistering = false;
                _isLogIn = true;
              }
            });
            if (type == 'Sign up') {
              await registerWithEmailPassword(
                      textControllerEmail.text, textControllerPassword.text)
                  .then((result) {
                print(result);
                widget.cleanWidgets();
                  Navigator.pop(context);
              }).catchError((error) {
                print('Registration Error: $error');
              });
            } else {
              await signInWithEmailPassword(
                      textControllerEmail.text, textControllerPassword.text)
                  .then((result) {
                print(result);
                widget.cleanWidgets();
                Navigator.pop(context);
              }).catchError((error) {
                print('Sign in Error: $error');
              });
            }
          }
          setState(() {
            _isRegistering = false;
            _isLogIn = false;
            _isEditingEmail = false;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: type == 'Sign up' && _isRegistering ||
                  type == 'Log in' && _isLogIn
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  type,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
        ),
      ),
    );
  }
}