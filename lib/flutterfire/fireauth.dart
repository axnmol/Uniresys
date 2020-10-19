import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';

class SignUpIn extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _error;

  Future signIn(BuildContext context,String e,String p) async{
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    try {
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: e, password: p);
      if (userCredential != null) {
        _error='Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _error = 'Wrong password provided for that user.';
      } else {
        _error = e.code.toUpperCase();
      }
    }
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    e = null;
    p = null;
    await _error;
  }

  Future signUP(BuildContext context,String e, String p, String vp) async{
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    try {
        var userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: e, password: p);
        if (userCredential != null) {
          _error='Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _error = 'The account already exists for that email.';
      } else {
        _error = e.code.toUpperCase();
      }
    }
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    e = null;
    p = null;
    await _error;
  }

  Future signOut() async {
    await auth.signOut();
  }

  String getMsg(){
    return _error;
  }
}