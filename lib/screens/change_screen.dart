import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uniresys/flutterfire/fireauth.dart';

import 'package:uniresys/users.dart';

class ChangeScreen extends StatelessWidget {
  static const String id = 'change_screen';

  final _cFormKey = GlobalKey<FormState>();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _verifyFocus = FocusNode();
  final FocusNode _newFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    String pass, newPass, vPass;

    void change() async {
      String s;
      if (_cFormKey.currentState.validate()) {
        _cFormKey.currentState.save();
        FocusScope.of(context).requestFocus(FocusNode());
        Provider.of<UserManage>(context, listen: false).toggle_Load();
        if (newPass == vPass) {
          try {
            var user =
                Provider.of<SignUpIn>(context, listen: false).auth.currentUser;
            var credential =
                EmailAuthProvider.credential(email: user.email, password: pass);
            var authResult = await Provider.of<SignUpIn>(context, listen: false)
                .auth
                .currentUser
                .reauthenticateWithCredential(credential);
            if (authResult != null) {
              await Provider.of<SignUpIn>(context, listen: false)
                  .auth
                  .currentUser
                  .updatePassword(vPass);
              s = 'Successfully Changed';
            }
          } on FirebaseAuthException catch (e) {
            s = e.code.toUpperCase().toString();
          }
        } else {
          s = 'Passwords do no match';
        }
        if (s == 'Successfully Changed') {
          Provider.of<UserManage>(context, listen: false)
              .showMyDialog(context, s, 0);
          _cFormKey.currentState.reset();
        } else if(s!=null){
          Provider.of<UserManage>(context, listen: false)
              .errorDialog(s, context);
        }
        Provider.of<UserManage>(context, listen: false).toggle_Load();
      }
    }

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

    final vPassField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _verifyFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => vPass = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'New Password',
            suffixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onFieldSubmitted: (term) {
          _verifyFocus.unfocus();
          FocusScope.of(context).requestFocus(_newFocus);
        });

    final nPassField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _newFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => newPass = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Verify Password',
            suffixIcon: Icon(Icons.lock),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        onFieldSubmitted: (term) {
          change();
        });

    final changeButton = Material(
        elevation: 10,
        shadowColor: Colors.blueAccent,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueAccent,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 3,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (_cFormKey.currentState.validate()) {
              _cFormKey.currentState.save();
            }
            change();
          },
          child: Text('Change',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Change Password'),
        elevation: 25,
        brightness: Brightness.dark,
      ),
      body: LoadingOverlay(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _cFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      child: Icon(
                        Icons.admin_panel_settings_sharp,
                        color: Colors.black54,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  passField,
                  SizedBox(height: 20.0),
                  vPassField,
                  SizedBox(height: 20.0),
                  nPassField,
                  SizedBox(height: 20.0),
                  changeButton,
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
        isLoading: Provider.of<UserManage>(context, listen: false).isLoad,
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
