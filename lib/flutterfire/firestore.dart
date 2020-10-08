import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';

class FirestoreUni extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _error;

  Future addFeed(String str,BuildContext context) async{
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    try {
      var Feed = <String, dynamic>{
        'Feedback': str,
      };
      await FirebaseFirestore.instance.collection('feedbacks').add(Feed);
      _error = 'Success';
    } catch (e) {
        _error = e.code.toString().toUpperCase();
    }
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    await _error;
  }

  String getMsg(){
    return _error;
  }
}
