import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';
import 'package:uniresys/entities/entities.dart';

class FirestoreUni extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _error;
  Student student;
  Faculty faculty;
  Course course;
  Degree degree;
  Registered registered;

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

  Stream<List<Registered>> getRegistered(){
    return firestore
        .collection('registered')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Registered.fromJson(doc.data()))
        .toList());
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

  Future<void> setStudent(){
    var options = SetOptions(merge:true);
    return firestore
        .collection('students')
        .doc(student.Id.toString())
        .set(student.toMap(),options);
  }

  Future<void> setFaculty(){
    var options = SetOptions(merge:true);
    return firestore
        .collection('faculties')
        .doc(faculty.Id.toString())
        .set(faculty.toMap(),options);
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
