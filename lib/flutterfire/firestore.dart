import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

import 'package:uniresys/users.dart';
import 'package:uniresys/entities/entities.dart';

class FireStoreUni extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var students = <Student>[];
  var courses = <Course>[];
  String _error;
  Admin admin;
  Student student;
  Faculty faculty;
  Registered registered;
  Degree degree;
  Course course;

  void setCourseEntity(Course x) {
    course = x;
    notifyListeners();
  }

  void setDegreeEntity(Degree x) {
    degree = x;
    notifyListeners();
  }

  void setFacultyEntity(Faculty x) {
    faculty = x;
    notifyListeners();
  }

  void setStudentEntity(Student x) {
    student = x;
    notifyListeners();
  }

  void setRegisteredEntity(Registered x) {
    registered = x;
    notifyListeners();
  }

  void setAdminEntity(Admin x) {
    admin = x;
    notifyListeners();
  }

  Future addFeed(String str, BuildContext context) async {
    Provider.of<UserManage>(context, listen: false).toggle_Load();
    await fireStore
        .collection('feedbacks')
        .add(<String, dynamic>{
          'Feedback': str,
        })
        .then((value) => _error = 'Success')
        .catchError((dynamic e) => {_error = e.toString().toUpperCase()});
    Provider.of<UserManage>(context, listen: false).toggle_Load();
  }

  Stream<List<Registered>> getRegistered() {
    return fireStore.collection('registered').snapshots().map((snapshot) => snapshot.docs.map((doc) => Registered.fromJson(doc.data())).toList());
  }

  Stream<List<Course>> getCourses() {
    return fireStore.collection('courses').snapshots().map((snapshot) => snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList());
  }

  Stream<List<Course>> getCoursesStudents(int x) {
    return fireStore
        .collection('courses')
        .where('Student Ids', arrayContains: x)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList());
  }

  Stream<List<Degree>> getDegrees() {
    return fireStore.collection('degrees').snapshots().map((snapshot) => snapshot.docs.map((doc) => Degree.fromJson(doc.data())).toList());
  }

  Stream<List<Student>> getStudent() {
    return fireStore.collection('students').snapshots().map((snapshot) => snapshot.docs.map((doc) => Student.fromJson(doc.data())).toList());
  }

  Stream<List<Student>> getStudentFaculty(List<int> x) {
    return fireStore
        .collection('students')
        .where('Id', whereIn: x)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Student.fromJson(doc.data())).toList());
  }

  Stream<List<Faculty>> getFaculty() {
    return fireStore.collection('faculties').snapshots().map((snapshot) => snapshot.docs.map((doc) => Faculty.fromJson(doc.data())).toList());
  }

  Stream<List<Admin>> getAdmin() {
    return fireStore.collection('admins').snapshots().map((snapshot) => snapshot.docs.map((doc) => Admin.fromJson(doc.data())).toList());
  }

  Future<void> setStudent() {
    var options = SetOptions(merge: true);
    return fireStore.collection('students').doc(student.Id.toString()).set(student.toMap(), options);
  }

  Future<void> setFaculty() {
    var options = SetOptions(merge: true);
    return fireStore.collection('faculties').doc(faculty.Id.toString()).set(faculty.toMap(), options);
  }

  Future<void> setDegree() {
    var options = SetOptions(merge: true);
    return fireStore.collection('degrees').doc(degree.Id.toString()).set(degree.toMap(), options);
  }

  Future<void> setCourse() {
    var options = SetOptions(merge: true);
    return fireStore.collection('courses').doc(course.Id.toString()).set(course.toMap(), options);
  }

  Future<void> setAdmin() {
    var options = SetOptions(merge: true);
    return fireStore.collection('admins').doc(admin.Email.toString()).set(admin.toMap(), options);
  }

  Future<void> setRegistered() {
    var options = SetOptions(merge: true);
    return fireStore.collection('registered').doc(registered.Id.toString()).set(registered.toMap(), options);
  }

  Future<void> delRegistered(String id) {
    return fireStore.collection('registered').doc(id).delete();
  }

  Future<void> delDegree(String degreeId) {
    return fireStore.collection('degrees').doc(degreeId).delete();
  }

  Future<void> delCourse(String courseId) {
    return fireStore.collection('courses').doc(courseId).delete();
  }

  Future<void> delStudent(String studentId) async {
    return fireStore.collection('students').doc(studentId).delete();
  }

  Future<void> delFaculty(String facultyId) async {
    return fireStore.collection('faculties').doc(facultyId).delete();
  }

  String getMsg() {
    return _error;
  }
}
