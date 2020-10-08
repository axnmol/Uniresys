import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:uniresys/screens/contact_screen.dart';
import 'package:uniresys/screens/register_screen.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import 'package:uniresys/flutterfire/fireauth.dart';
import 'package:uniresys/users.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    String _email, _password = '';

    void login() async {
      String s;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        FocusScope.of(context).requestFocus(FocusNode());
        await Provider.of<SignUpIn>(context, listen: false)
            .signIn(_email, _password, context);
        s = Provider.of<SignUpIn>(context, listen: false).getMsg();
        _passFocus.unfocus();
        _formKey.currentState.reset();
      }
      if (s == 'Success') {
        Provider.of<UserManage>(context, listen: false)
            .showMyDialog(context, 'Logged In', 1);
      } else if (s != null)
        Provider.of<UserManage>(context, listen: false).errorDialog(s, context);
    }

    final emailField = TextFormField(
        style: TextStyle(),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        validator: (email) =>
            EmailValidator.validate(email) ? null : 'Invalid email address',
        onSaved: (email) => _email = email,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Email',
            hintText: 'e.g. abc@gmail.com',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _emailFocus.unfocus();
          FocusScope.of(context).requestFocus(_passFocus);
        });

    final passwordField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _passFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (password) => _password = password,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Password',
            suffixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _passFocus.unfocus();
          login();
        });

    final signInButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          login();
        },
        child: Text('Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final signUpButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (Provider.of<UserManage>(context, listen: false).getSelect() !=
              1) {
            _formKey.currentState.reset();
            Navigator.pushNamed(context, RegisterScreen.id);
          } else {
            Provider.of<UserManage>(context, listen: false)
                .errorDialog('Cannot sign up as Admin', context);
          }
        },
        child: Text('Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final contactUni = Material(
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey, fontSize: 20),
          children: <TextSpan>[
            TextSpan(text: 'Need Help? '),
            TextSpan(
                text: 'Contact Us',
                style: TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _formKey.currentState.reset();
                    Navigator.pushNamed(context, ContactScreen.id);
                  }),
          ],
        ),
      ),
    );

    final userCategory = Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Provider.of<UserManage>(context, listen: false).setSelect(0);
              },
              child: Text('Student',
                  style: TextStyle(
                      color: Provider.of<UserManage>(context).getColor(0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          GestureDetector(
            onTap: () {
              Provider.of<UserManage>(context, listen: false).setSelect(1);
            },
            child: Text('Admin',
                style: TextStyle(
                    color: Provider.of<UserManage>(context).getColor(1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<UserManage>(context, listen: false).setSelect(2);
            },
            child: Text('Faculty',
                style: TextStyle(
                    color: Provider.of<UserManage>(context).getColor(2),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );

    return Scaffold(
      body: LoadingOverlay(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  userCategory,
                  SizedBox(height: 20.0),
                  emailField,
                  SizedBox(height: 20.0),
                  passwordField,
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[signInButton, signUpButton]),
                  Expanded(
                    child: SizedBox(),
                  ),
                  contactUni,
                ],
              ),
            ),
          ),
        ),
        isLoading: Provider.of<UserManage>(context, listen: false).getLoad(),
        opacity: 0.5,
        progressIndicator: SpinKitDoubleBounce(
          color: Colors.white,
          size: 150,
        ),
        color: Colors.blueAccent,
      ),
    );
  }
}