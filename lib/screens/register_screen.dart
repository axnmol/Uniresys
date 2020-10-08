import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:email_validator/email_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';
import 'package:uniresys/flutterfire/fireauth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class RegisterScreen extends StatelessWidget {
  static const String id = 'register_screen';
  final _rFormKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _verifyFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    String name, phone, id, mail, pass, vpass;

    void register() async {
      String s;
      if (_rFormKey.currentState.validate()) {
        _rFormKey.currentState.save();
        FocusScope.of(context).requestFocus(FocusNode());
        if (pass == vpass) {
          FocusScope.of(context).requestFocus(FocusNode());
          await Provider.of<SignUpIn>(context, listen: false)
              .signUP(mail, pass, vpass, context);
          s = Provider.of<SignUpIn>(context, listen: false).getMsg();
        } else {
          Provider.of<UserManage>(context, listen: false).toggle_Load();
          s = 'Password do not match with Verify password';
        }
      }
      if (s == 'Success') {
        Provider.of<UserManage>(context, listen: false)
            .showMyDialog(context, 'Registered', 1);
        _rFormKey.currentState.reset();
      } else if (s != null)
        Provider.of<UserManage>(context, listen: false).errorDialog(s, context);
    }

    final nameField = TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(),
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => name = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Name',
            hintText: 'Enter Name',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _nameFocus.unfocus();
          FocusScope.of(context).requestFocus(_phoneFocus);
        });

    final phoneField = TextFormField(
        keyboardType: TextInputType.phone,
        style: TextStyle(),
        textInputAction: TextInputAction.next,
        focusNode: _phoneFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => phone = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Phone',
            hintText: 'Enter Phone No.',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _nameFocus.unfocus();
          FocusScope.of(context).requestFocus(_emailFocus);
        });

    final emailField = TextFormField(
        style: TextStyle(),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        validator: (input) =>
            EmailValidator.validate(input) ? null : 'Invalid email address',
        onSaved: (input) => mail = input,
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

    final passField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.next,
        focusNode: _passFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => pass = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Password',
            suffixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onFieldSubmitted: (term) {
          _passFocus.unfocus();
          FocusScope.of(context).requestFocus(_verifyFocus);
        });

    final vpassField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.next,
        focusNode: _verifyFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => vpass = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Verify Password',
            suffixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onFieldSubmitted: (term) {
          _verifyFocus.unfocus();
          FocusScope.of(context).requestFocus(_idFocus);
        });

    final idField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _idFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => id = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: Provider.of<UserManage>(context).getId() + ' Id',
            hintText: 'Enter Id.',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _idFocus.unfocus();
        });

    final dropDown = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: DropdownButton<String>(
          value: null,
          icon: Icon(Icons.arrow_drop_down),
          iconDisabledColor: Colors.blueAccent,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
          underline: Container(
            height: 1,
            color: Colors.blueAccent,
          ),
          items: <String>['One', 'Two', 'Three', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
          onChanged: (String newValue) {},
          hint: Text(
            'Please select a ' + Provider.of<UserManage>(context).getDrop(),
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
    );

    final registerButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          register();
        },
        child: Text('Register',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 25,
        brightness: Brightness.dark,
        title:
            Text(Provider.of<UserManage>(context).getName() + ' Registration'),
      ),
      body: LoadingOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _rFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  nameField,
                  SizedBox(height: 15.0),
                  phoneField,
                  SizedBox(height: 15.0),
                  emailField,
                  SizedBox(height: 15.0),
                  passField,
                  SizedBox(height: 15.0),
                  vpassField,
                  SizedBox(height: 15.0),
                  idField,
                  SizedBox(height: 40),
                  dropDown,
                  SizedBox(height: 40),
                  registerButton,
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
