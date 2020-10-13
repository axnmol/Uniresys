import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';
import 'package:uniresys/entities/entities.dart';

class FirestoreUni extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _error;

  Future addFeed(String str, BuildContext context) async{
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    await firestore
        .collection('feedbacks')
        .add(<String, dynamic>{
          'Feedback': str,
        })
        .then((value) => _error = 'Success')
        .catchError((dynamic e) => {_error = e.toString().toUpperCase()});
    Provider.of<UserManage>(context, listen: false).toggle_Load();
  }

  Stream<List<Course>> getCourses(){
    return firestore
        .collection('courses')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Course.fromJson(doc.data()))
        .toList());
  }

  Stream<List<Degree>> getDegrees(){
    return firestore
        .collection('degrees')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Degree.fromJson(doc.data()))
        .toList());
  }

  Future<void> setDegree(Degree degree){
    var options = SetOptions(merge:true);
    return firestore
        .collection('degrees')
        .doc(degree.Id.toString())
        .set(degree.toMap(),options);
  }

  Future<void> removeDegree(String degreeId){
    return firestore
        .collection('degrees')
        .doc(degreeId)
        .delete();
  }

  String getMsg() {
    return _error;
  }
}
