import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:email_validator/email_validator.dart';

import 'package:uniresys/flutterfire/fireauth.dart';
import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/users.dart';

class UpdateScreen extends StatelessWidget {
  static const String id = 'update_screen';

  final _uFormKey = GlobalKey<FormState>();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    String mail, phone;
    var admin = Provider.of<FireStoreUni>(context).admin;
    var faculty = Provider.of<FireStoreUni>(context).faculty;
    var student = Provider.of<FireStoreUni>(context).student;

    void update() async {
      String s;
      if (_uFormKey.currentState.validate()) {
        _uFormKey.currentState.save();
        FocusScope.of(context).unfocus();
        try {
          await Provider.of<SignUpIn>(context, listen: false).auth.currentUser.updateEmail(mail);
          var x = Provider.of<UserManage>(context, listen: false).pointer;
          var fireStoreUni = Provider.of<FireStoreUni>(context, listen: false);
          if (x == 0) {
            fireStoreUni.setStudentEntity(Student(student.Id, student.Name, mail, phone));
            await fireStoreUni.setStudent();
          }
          if (x == 2) {
            fireStoreUni.setFacultyEntity(Faculty(faculty.Id, faculty.Name, mail, phone));
            await fireStoreUni.setFaculty();
          }
          if (x == 1) {
            fireStoreUni.setAdminEntity(Admin(mail, admin.Name, phone));
            await fireStoreUni.setAdmin();
          }
          s = 'Successfully Updated';
        } on FirebaseAuthException catch (e) {
          s = e.code.toUpperCase().toString();
        }
        if (s == 'Successfully Updated') {
          Provider.of<UserManage>(context, listen: false).showMyDialog(context, s, 0);
          _uFormKey.currentState.reset();
        } else if (s != null) {
          Provider.of<UserManage>(context, listen: false).errorDialog(s, context);
        }
      }
    }

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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _phoneFocus.unfocus();
          FocusScope.of(context).requestFocus(_emailFocus);
        });

    final emailField = TextFormField(
        style: TextStyle(),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        focusNode: _emailFocus,
        validator: (input) => EmailValidator.validate(input) ? null : 'Invalid email address',
        onSaved: (input) => mail = input,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: 'Email',
            hintText: 'e.g. abc@gmail.com',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _emailFocus.unfocus();
          update();
        });

    final updateButton = Material(
        elevation: 10,
        shadowColor: Colors.blueAccent,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueAccent,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 3,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            Provider.of<UserManage>(context, listen: false).toggle_Load();
            await update();
            Provider.of<UserManage>(context, listen: false).toggle_Load();
          },
          child: Text('Update', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Update Information'),
        elevation: 25,
        brightness: Brightness.dark,
      ),
      body: LoadingOverlay(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _uFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      child: Icon(
                        Icons.update_rounded,
                        color: Colors.black54,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                  phoneField,
                  SizedBox(height: 20.0),
                  emailField,
                  SizedBox(height: 20.0),
                  updateButton,
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
