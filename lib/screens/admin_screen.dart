import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import 'package:uniresys/admin.dart';
import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/screens/change_screen.dart';
import 'package:uniresys/screens/update_screen.dart';
import 'package:uniresys/users.dart';

// ignore: must_be_immutable
class AdminScreen extends StatelessWidget {
  static const String id = 'admin_screen';

  final _idFormKey = GlobalKey<FormState>();
  final _addDegreeFormKey = GlobalKey<FormState>();
  final _addCourseFormKey = GlobalKey<FormState>();
  final _updateFormKey = GlobalKey<FormState>();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _mainIdFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _idsFocus = FocusNode();
  final FocusNode _creditsFocus = FocusNode();
  final FocusNode _seatsFocus = FocusNode();
  final FocusNode _facIdFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  List<Course> courses = <Course>[];
  List<Degree> degrees = <Degree>[];
  List<Faculty> faculties = <Faculty>[];
  List<Student> students = <Student>[];

  @override
  Widget build(BuildContext context) {
    var fireStoreUni = Provider.of<FireStoreUni>(context);
    var adminManage = Provider.of<AdminManage>(context);
    var userManage = Provider.of<UserManage>(context);

    int mainId, credits, seats, facId;
    String name, ids, phone;

    List<int> convertS2L(String s) {
      List<int> result;
      result = s.split(',').map(int.parse).toList();
      return result;
    }

    void maintain() async {
      userManage.toggle_Load();
      String error;
      try {
        switch (adminManage.maintainSelect) {
          case 0:
            switch (adminManage.crudSelect){
              case 1:
                if (_updateFormKey.currentState.validate()) {
                  _updateFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  students.forEach((element) {
                    if (element.Name == name && element.Id != adminManage.id) {
                      error = 'Student already exists';
                    }
                  });
                  if (error == null) {
                    fireStoreUni.setStudentEntity(Student(adminManage.id, name, students[adminManage.it].Email, phone));
                    await fireStoreUni.setStudent();
                  }
                  _updateFormKey.currentState.reset();
                }
                adminManage.setIt(0);
                break;
              case 3:
                await fireStoreUni.delStudent(adminManage.id.toString());
                await fireStoreUni.delRegistered(adminManage.id.toString());
                adminManage.setIt(0);
                break;
              default:
                break;
            }
            break;
          case 1:
            switch (adminManage.crudSelect){
              case 1:
                if (_updateFormKey.currentState.validate()) {
                  _updateFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  faculties.forEach((element) {
                    if (element.Name == name && element.Id != adminManage.id) {
                      error = 'Faculty already exists';
                    }
                  });
                  if (error == null) {
                    fireStoreUni.setFacultyEntity(Faculty(adminManage.id,name,faculties[adminManage.it].Email,phone));
                    await fireStoreUni.setFaculty();
                  }
                  _updateFormKey.currentState.reset();
                }
                adminManage.setIt(0);
                break;
              case 3:
                await fireStoreUni.delFaculty(adminManage.id.toString());
                await fireStoreUni.delRegistered(adminManage.id.toString());
                adminManage.setIt(0);
                break;
              default:
                break;
            }
            break;
          case 2:
            switch (adminManage.crudSelect) {
              case 0:
                if (_addDegreeFormKey.currentState.validate()) {
                  _addDegreeFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  degrees.forEach((element) {
                    if (element.Id == mainId || element.Name == name) {
                      error = 'Degree already exists';
                    }
                    element.Student_Ids.forEach((stuId) {
                      if (convertS2L(ids).contains(stuId)) {
                        error = 'One of the student ids already exists ';
                      }
                    });
                  });
                  if (error == null) {
                    fireStoreUni.setDegreeEntity(Degree(mainId, name, convertS2L(ids)));
                    await fireStoreUni.setDegree();
                  }
                  _addDegreeFormKey.currentState.reset();
                }
                break;
              case 1:
                if (_addDegreeFormKey.currentState.validate()) {
                  _addDegreeFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  degrees.forEach((element) {
                    if (element.Name == name && element.Id != adminManage.id) {
                      error = 'Degree already exists';
                    }
                    element.Student_Ids.forEach((stuId) {
                      if (convertS2L(ids).contains(stuId) && element.Id != adminManage.id) {
                        error = 'One of the student ids already exists ';
                      }
                    });
                  });
                  if (error == null) {
                    fireStoreUni.setDegreeEntity(Degree(adminManage.id, name, convertS2L(ids)));
                    await fireStoreUni.setDegree();
                  }
                  _addDegreeFormKey.currentState.reset();
                }
                adminManage.setIt(0);
                break;
              case 3:
                await degrees[adminManage.it].Student_Ids.forEach((element) {
                  fireStoreUni.delStudent(element.toString());
                  fireStoreUni.delRegistered(element.toString());
                });
                await fireStoreUni.delDegree(adminManage.id.toString());
                adminManage.setIt(0);
                break;
              default:
                break;
            }
            break;
          case 3:
            switch (adminManage.crudSelect) {
              case 0:
                if (_addCourseFormKey.currentState.validate()) {
                  _addCourseFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  courses.forEach((element) {
                    if (element.Id == mainId || element.Name == name || element.Faculty_Id == facId) {
                      error = 'Course already exists';
                    }
                  });
                  if (convertS2L(ids).length > seats) {
                    error = 'Students cannot be more than seats';
                  }
                  if (error == null) {
                    fireStoreUni.setCourseEntity(Course(mainId, name, facId, credits, seats, convertS2L(ids)));
                    await fireStoreUni.setCourse();
                  }
                  _addCourseFormKey.currentState.reset();
                }
                break;
              case 1:
                if (_addCourseFormKey.currentState.validate()) {
                  _addCourseFormKey.currentState.save();
                  FocusScope.of(context).unfocus();
                  courses.forEach((element) {
                    if ((element.Name == name || element.Faculty_Id == facId) && element.Id != adminManage.id) {
                      error = 'Course already exists';
                    }
                  });
                  if (error == null) {
                    fireStoreUni.setCourseEntity(Course(adminManage.id, name, facId, credits, seats, convertS2L(ids)));
                    await fireStoreUni.setCourse();
                  }
                  _addCourseFormKey.currentState.reset();
                }
                adminManage.setIt(0);
                break;
              case 3:
                await fireStoreUni.delFaculty(courses[adminManage.it].Faculty_Id.toString());
                await fireStoreUni.delRegistered(courses[adminManage.it].Faculty_Id.toString());
                await fireStoreUni.delCourse(adminManage.id.toString());
                adminManage.setIt(0);
                break;
              default:
                break;
            }
            break;
          default:
            break;
        }
      } on FirebaseException catch (e) {
        error = e.code.toString().toUpperCase();
      }
      if (error == null) {
        userManage.showMyDialog(context, adminManage.action[adminManage.crudSelect] + ' Successful', 0);
        _innerDrawerKey.currentState.toggle();
      } else {
        userManage.errorDialog(error, context);
      }
      userManage.toggle_Load();
    }

    final idField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _idFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => adminManage.setId(int.parse(input)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Id',
            hintText: 'Enter Id.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _idFocus.unfocus();
        });

    final mainIDField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _mainIdFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => mainId = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Id',
            hintText: 'Enter Id.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _mainIdFocus.unfocus();
        });

    final nameField = TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _nameFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => name = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Name',
            hintText: 'Enter Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _nameFocus.unfocus();
        });

    final phoneField = TextFormField(
        keyboardType: TextInputType.text,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _phoneFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => phone = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Phone No.',
            hintText: 'Enter Phone No.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _nameFocus.unfocus();
        });

    final idsField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _idsFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => ids = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Student Ids',
            hintText: 'Enter Ids separated by comma',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _idsFocus.unfocus();
        });

    final creditsField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _creditsFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => credits = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Credits',
            hintText: 'Enter No. of credits',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _creditsFocus.unfocus();
        });

    final seatsField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _seatsFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => seats = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Seats',
            hintText: 'Enter No. of seats',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _seatsFocus.unfocus();
        });

    final facIdField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _facIdFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => facId = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Faculty Id',
            hintText: 'Enter Id.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _facIdFocus.unfocus();
        });

    final addDegree = Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _addDegreeFormKey,
          child: Column(
            children: <Widget>[
              if (adminManage.crudSelect == 0) mainIDField,
              if (adminManage.crudSelect == 0)
                SizedBox(
                  height: 20,
                ),
              nameField,
              SizedBox(
                height: 20,
              ),
              idsField
            ],
          ),
        ),
      ),
    );

    final addCourse = Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Form(
          key: _addCourseFormKey,
          child: Column(
            children: <Widget>[
              if (adminManage.crudSelect == 0) mainIDField,
              if (adminManage.crudSelect == 0)
                SizedBox(
                  height: 20,
                ),
              nameField,
              SizedBox(
                height: 20,
              ),
              facIdField,
              SizedBox(
                height: 20,
              ),
              creditsField,
              SizedBox(
                height: 20,
              ),
              seatsField,
              SizedBox(
                height: 20,
              ),
              idsField
            ],
          ),
        ),
      ),
    );

    final updatePerson = Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _updateFormKey,
          child: Column(
            children: <Widget>[
              nameField,
              SizedBox(
                height: 20,
              ),
              phoneField
            ],
          ),
        ),
      ),
    );

    final maintainButton = Material(
        elevation: 10,
        shadowColor: Colors.blueAccent,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueAccent,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 3,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            maintain();
          },
          child: Text(adminManage.action[adminManage.crudSelect] + ' ' + adminManage.maintain[adminManage.maintainSelect],
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ));

    final viewTile = Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          if (adminManage.maintainSelect == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: Colors.blueAccent.withOpacity(0.75),
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              students[adminManage.it].Name + ' - ' + students[adminManage.it].Id.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  students[adminManage.it].Phone,
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  students[adminManage.it].Email,
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (adminManage.maintainSelect == 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: Colors.blueAccent.withOpacity(0.75),
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              faculties[adminManage.it].Name + ' - ' + faculties[adminManage.it].Id.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  faculties[adminManage.it].Phone,
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  faculties[adminManage.it].Email,
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (adminManage.maintainSelect == 2)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Icon(
                    Icons.book,
                    size: 50,
                  ),
                ),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: Colors.blueAccent.withOpacity(0.75),
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              degrees[adminManage.it].Id.toString(),
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                            Text(
                              degrees[adminManage.it].Name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'No. of Students: ',
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  degrees[adminManage.it].Student_Ids.length.toString(),
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (adminManage.maintainSelect == 3)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Icon(
                    Icons.book,
                    size: 50,
                  ),
                ),
                title: Align(
                  alignment: Alignment(-1.1, 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      color: Colors.blueAccent.withOpacity(0.75),
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              courses[adminManage.it].Id.toString(),
                              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            Text(
                              courses[adminManage.it].Name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Credits -',
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  courses[adminManage.it].Credits.toString(),
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  'Seats -',
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  courses[adminManage.it].Seats.toString(),
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Faculty ID -',
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  courses[adminManage.it].Faculty_Id.toString(),
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final viewModel = Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            if (adminManage.maintainSelect == 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                height: MediaQuery.of(context).size.height / 2.4,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: students.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.1, 0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                color: Colors.blueAccent.withOpacity(0.75),
                                elevation: 10,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.height / 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        students[index].Name + ' - ' + students[index].Id.toString(),
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            students[index].Phone,
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.mail,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            students[index].Email,
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            if (adminManage.maintainSelect == 1)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                height: MediaQuery.of(context).size.height / 2.4,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: faculties.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.1, 0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                color: Colors.blueAccent.withOpacity(0.75),
                                elevation: 10,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.height / 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        faculties[index].Name + ' - ' + faculties[index].Id.toString(),
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            faculties[index].Phone,
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.mail,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            faculties[index].Email,
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            if (adminManage.maintainSelect == 2)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                height: MediaQuery.of(context).size.height / 2.4,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: degrees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Icon(
                              Icons.book,
                              size: 50,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.1, 0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                color: Colors.blueAccent.withOpacity(0.75),
                                elevation: 10,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.height / 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        degrees[index].Id.toString(),
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 20),
                                      ),
                                      Text(
                                        degrees[index].Name,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'No. of Students: ',
                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            degrees[index].Student_Ids.length.toString(),
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            if (adminManage.maintainSelect == 3)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                height: MediaQuery.of(context).size.height / 2.4,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                  },
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Icon(
                              Icons.book,
                              size: 50,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.1, 0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                color: Colors.blueAccent.withOpacity(0.75),
                                elevation: 10,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.height / 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        courses[index].Id.toString(),
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 15),
                                      ),
                                      Text(
                                        courses[index].Name,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Credits -',
                                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            courses[index].Credits.toString(),
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'Seats -',
                                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            courses[index].Seats.toString(),
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Faculty ID -',
                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            courses[index].Faculty_Id.toString(),
                                            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
          ],
        ));

    final viewButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black54,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          adminManage.toggleView();
          print(adminManage.viewAll);
        },
        child: Text('View All', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    void handle() async {
      var error = false;
      if (adminManage.crudSelect != 0) {
        if (_idFormKey.currentState.validate()) {
          _idFormKey.currentState.save();
          switch (adminManage.maintainSelect) {
            case 0:
              var len = students.length;
              for (var i = 0; i < len; ++i) {
                if (students[i].Id == adminManage.id) {
                  error = true;
                  adminManage.setIt(i);
                }
              }
              break;
            case 1:
              var len = faculties.length;
              for (var i = 0; i < len; ++i) {
                if (faculties[i].Id == adminManage.id) {
                  error = true;
                  adminManage.setIt(i);
                }
              }
              break;
            case 2:
              var len = degrees.length;
              for (var i = 0; i < len; ++i) {
                if (degrees[i].Id == adminManage.id) {
                  error = true;
                  adminManage.setIt(i);
                }
              }
              break;
            case 3:
              var len = courses.length;
              for (var i = 0; i < len; ++i) {
                if (courses[i].Id == adminManage.id) {
                  error = true;
                  adminManage.setIt(i);
                }
              }
              break;
            default:
              break;
          }
          if (!error) {
            userManage.errorDialog(adminManage.maintain[adminManage.maintainSelect] + ' Id not found', context);
          } else {
            _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.start);
            _idFormKey.currentState.reset();
          }
        }
      } else {
        _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.start);
      }
    }

    final defaultButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(_addDegreeFormKey.currentState!=null)_addDegreeFormKey.currentState.reset();
          if(_addCourseFormKey.currentState!=null)_addCourseFormKey.currentState.reset();
          if(_updateFormKey.currentState!=null)_updateFormKey.currentState.reset();
          handle();
        },
        child: Text(adminManage.action[adminManage.crudSelect] + '  ' + adminManage.maintain[adminManage.maintainSelect],
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<List<Course>>(
          stream: fireStoreUni.getCourses(),
          builder: (context, snapCourse) {
            return StreamBuilder<List<Degree>>(
                stream: fireStoreUni.getDegrees(),
                builder: (context, snapDegree) {
                  return StreamBuilder<List<Faculty>>(
                      stream: fireStoreUni.getFaculty(),
                      builder: (context, snapFaculty) {
                        return StreamBuilder<List<Student>>(
                            stream: fireStoreUni.getStudent(),
                            builder: (context, snapStudent) {
                              if (!snapDegree.hasData || !snapStudent.hasData || !snapCourse.hasData || !snapFaculty.hasData) {
                                return Center(
                                  child: SpinKitDoubleBounce(
                                    color: Colors.blueAccent,
                                    size: 150,
                                  ),
                                );
                              }
                              courses = snapCourse.data;
                              degrees = snapDegree.data;
                              faculties = snapFaculty.data;
                              students = snapStudent.data;
                              return InnerDrawer(
                                key: _innerDrawerKey,
                                onTapClose: true,
                                swipe: false,
                                colorTransitionChild: Colors.blueAccent.withOpacity(0.75),
                                colorTransitionScaffold: Colors.blueAccent.withOpacity(0.75),
                                offset: IDOffset.only(bottom: 0.05, right: 0.05, left: 0.75),
                                scale: IDOffset.horizontal(0.8),
                                proportionalChildArea: true,
                                borderRadius: 50,
                                leftAnimationType: InnerDrawerAnimation.quadratic,
                                rightAnimationType: InnerDrawerAnimation.quadratic,
                                backgroundDecoration: BoxDecoration(color: Colors.white),
                                //innerDrawerCallback: return  true (open) or false (close)
                                leftChild: KeyboardSizeProvider(
                                  child: Scaffold(
                                    resizeToAvoidBottomInset: false,
                                    backgroundColor: Colors.white,
                                    body: LoadingOverlay(
                                      child: SingleChildScrollView(
                                        reverse: true,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 100, 10, 0),
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('Maintain ' + adminManage.maintain[adminManage.maintainSelect],
                                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.black54)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                adminManage.action[adminManage.crudSelect] + ' ' + adminManage.maintain[adminManage.maintainSelect],
                                                style: TextStyle(fontSize: 25, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                                              ),
                                              if (adminManage.maintainSelect == 1 || adminManage.maintainSelect == 0)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    if (adminManage.crudSelect == 0 || adminManage.crudSelect == 1) updatePerson,
                                                  ],
                                                ),
                                              if (adminManage.maintainSelect == 2)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    if (adminManage.crudSelect == 0 || adminManage.crudSelect == 1) addDegree,
                                                  ],
                                                ),
                                              if (adminManage.maintainSelect == 3)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    if (adminManage.crudSelect == 0 || adminManage.crudSelect == 1) addCourse,
                                                  ],
                                                ),
                                              if (adminManage.crudSelect == 2)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    viewTile,
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 60,
                                                        ),
                                                        viewButton
                                                      ],
                                                    ),
                                                    if (adminManage.viewAll) viewModel,
                                                  ],
                                                ),
                                              if (adminManage.crudSelect == 3)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Icon(
                                                      Icons.delete_forever,
                                                      size: 200,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Are you sure, you want to delete ?',
                                                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('Then press delete'),
                                                    SizedBox(
                                                      height: 15,
                                                    )
                                                  ],
                                                ),
                                              if (adminManage.crudSelect != 2) maintainButton,
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Consumer<ScreenHeight>(builder: (context, _res, child) {
                                                return Container(height: _res.keyboardHeight);
                                              })
                                            ],
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
                                  ),
                                ),
                                rightChild: Scaffold(
                                  backgroundColor: Colors.white,
                                  body: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.contacts_rounded,
                                            size: MediaQuery.of(context).size.width / 3,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(height: 30),
                                          Text(
                                            'Profile',
                                            style: TextStyle(fontSize: 25, color: Colors.blueAccent, fontWeight: FontWeight.w800),
                                          ),
                                          Text('Management', style: TextStyle(fontSize: 25, color: Colors.blueAccent, fontWeight: FontWeight.w800)),
                                          SizedBox(height: 30),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, UpdateScreen.id);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                '   Update  \nInformation',
                                                style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            borderSide: BorderSide(color: Colors.black54, width: 2),
                                            shape: StadiumBorder(),
                                          ),
                                          SizedBox(height: 20),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, ChangeScreen.id);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                '   Change  \n Password ',
                                                style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            borderSide: BorderSide(color: Colors.black54, width: 2),
                                            shape: StadiumBorder(),
                                          ),
                                          SizedBox(height: 15),
                                          OutlineButton(
                                            onPressed: () {
                                              adminManage.setMSelect(4);
                                              adminManage.setCSelect(4);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                'Logout',
                                                style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            borderSide: BorderSide(color: Colors.black54, width: 2),
                                            shape: StadiumBorder(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                scaffold: KeyboardSizeProvider(
                                  child: Scaffold(
                                    resizeToAvoidBottomInset: false,
                                    backgroundColor: Colors.white,
                                    appBar: AppBar(
                                      backgroundColor: Colors.blueAccent,
                                      leading: Icon(
                                        Icons.contacts_outlined,
                                        size: 30,
                                      ),
                                      title: Center(
                                        child: Text(Provider.of<UserManage>(context).getName()),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: IconButton(
                                              onPressed: () {
                                                _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.end);
                                              },
                                              icon: Icon(Icons.menu, size: 40)),
                                        )
                                      ],
                                      elevation: 25,
                                      brightness: Brightness.dark,
                                    ),
                                    body: LoadingOverlay(
                                      child: SafeArea(
                                        child: SingleChildScrollView(
                                          reverse: true,
                                          padding: EdgeInsets.symmetric(vertical: 20),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                fireStoreUni.admin.Name,
                                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 5),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.mail,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    fireStoreUni.admin.Email,
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Icon(
                                                    Icons.phone,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    fireStoreUni.admin.Phone,
                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      adminManage..setMSelect(0);
                                                    },
                                                    child: Material(
                                                      elevation: 10,
                                                      shadowColor: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: adminManage.getColorM(0),
                                                            border: Border.all(width: 2, color: Colors.black54),
                                                            borderRadius: BorderRadius.circular(20.0)),
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: MediaQuery.of(context).size.width / 4,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Material(
                                                            elevation: 10,
                                                            shadowColor: Colors.white,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(width: 2, color: Colors.black54),
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.person_outlined,
                                                                    color: Colors.black54,
                                                                  ),
                                                                  Text('Maintain',
                                                                      style: TextStyle(
                                                                          color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.w600)),
                                                                  Text('Student Records',
                                                                      style:
                                                                          TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 16))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      adminManage.setMSelect(1);
                                                    },
                                                    child: Material(
                                                      elevation: 10,
                                                      shadowColor: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: adminManage.getColorM(1),
                                                            border: Border.all(width: 2, color: Colors.black54),
                                                            borderRadius: BorderRadius.circular(20.0)),
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: MediaQuery.of(context).size.width / 4,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Material(
                                                            elevation: 10,
                                                            shadowColor: Colors.white,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(width: 2, color: Colors.black54),
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.person_outlined,
                                                                    color: Colors.black54,
                                                                  ),
                                                                  Text(
                                                                    'Maintain',
                                                                    style: TextStyle(
                                                                        color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    'Faculty Records',
                                                                    style:
                                                                        TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 16),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      adminManage.setMSelect(2);
                                                    },
                                                    child: Material(
                                                      elevation: 10,
                                                      shadowColor: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: adminManage.getColorM(2),
                                                            border: Border.all(width: 2, color: Colors.black54),
                                                            borderRadius: BorderRadius.circular(20.0)),
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: MediaQuery.of(context).size.width / 4,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Material(
                                                            elevation: 10,
                                                            shadowColor: Colors.white,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(width: 2, color: Colors.black54),
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.book_outlined,
                                                                    color: Colors.black54,
                                                                  ),
                                                                  Text('Maintain',
                                                                      style: TextStyle(
                                                                          color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.w600)),
                                                                  Text('Degree Records',
                                                                      style:
                                                                          TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 16))
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      adminManage.setMSelect(3);
                                                    },
                                                    child: Material(
                                                      elevation: 10,
                                                      shadowColor: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: adminManage.getColorM(3),
                                                            border: Border.all(width: 2, color: Colors.black54),
                                                            borderRadius: BorderRadius.circular(20.0)),
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: MediaQuery.of(context).size.width / 4,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Material(
                                                            elevation: 10,
                                                            shadowColor: Colors.white,
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(width: 2, color: Colors.black54),
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10.0)),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.book_outlined,
                                                                    color: Colors.black54,
                                                                  ),
                                                                  Text(
                                                                    'Maintain',
                                                                    style: TextStyle(
                                                                        color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    'Course Records',
                                                                    style:
                                                                        TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 16),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  if (adminManage.maintainSelect == 2 || adminManage.maintainSelect == 3)
                                                    OutlineButton(
                                                      onPressed: () {
                                                        adminManage.setCSelect(0);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width / 3.5,
                                                        child: Text(
                                                          adminManage.action[0],
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                      borderSide: BorderSide(color: adminManage.getColorC(0), width: 5),
                                                      shape: StadiumBorder(),
                                                    ),
                                                  if (adminManage.maintainSelect == 2 || adminManage.maintainSelect == 3)
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                  OutlineButton(
                                                    onPressed: () {
                                                      adminManage.setCSelect(1);
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      child: Text(
                                                        adminManage.action[1],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    borderSide: BorderSide(color: adminManage.getColorC(1), width: 5),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  OutlineButton(
                                                    onPressed: () {
                                                      adminManage.setCSelect(2);
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      child: Text(
                                                        adminManage.action[2],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    borderSide: BorderSide(color: adminManage.getColorC(2), width: 5),
                                                    shape: StadiumBorder(),
                                                  ),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  OutlineButton(
                                                    onPressed: () {
                                                      adminManage.setCSelect(3);
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      child: Text(
                                                        adminManage.action[3],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    borderSide: BorderSide(color: adminManage.getColorC(3), width: 5),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ],
                                              ),
                                              if (adminManage.crudSelect != 0)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                                  child: Form(key: _idFormKey, child: idField),
                                                ),
                                              if (adminManage.crudSelect == 0)
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              if (adminManage.crudSelect != 4 &&
                                                  adminManage.maintainSelect != 4 &&
                                                  !(adminManage.crudSelect == 0 && adminManage.maintainSelect == 0) &&
                                                  !(adminManage.crudSelect == 0 && adminManage.maintainSelect == 1))
                                                defaultButton,
                                              Consumer<ScreenHeight>(builder: (context, _res, child) {
                                                return Container(height: _res.keyboardHeight);
                                              })
                                            ],
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
                                  ),
                                ),
                              );
                            });
                      });
                });
          }),
    );
  }

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
}
