import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:uniresys/users.dart';

class ChangeScreen extends StatelessWidget {
  static const String id = 'change_screen';

  final _cFormKey = GlobalKey<FormState>();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _verifyFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    String pass, vPass;

    void change() {
      if (_cFormKey.currentState.validate()) {
        _cFormKey.currentState.save();
        print(pass);
        print(vPass);
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
                      child: Icon(Icons.admin_panel_settings_sharp,color: Colors.blueAccent,),
                      fit: BoxFit.contain,
                    ),
                  ),
                  passField,
                  SizedBox(height: 20.0),
                  vPassField,
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
