import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/users.dart';
import 'package:uniresys/flutterfire/fireauth.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  static const String id = 'register_screen';

  final _rFormKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _verifyFocus = FocusNode();

  var result = false;
  var registerBool = true;

  @override
  Widget build(BuildContext context) {
    String name, phone, mail, pass, vPass;
    int id;

    List<String> makeStrC(List<Course> temp) {
      var list = <String>[];
      var length = temp.length;
      for (var i = 0; i < length; ++i) {
        list.add(temp[i].Name);
      }
      return list;
    }

    List<String> makeStrD(List<Degree> temp) {
      var lol = <String>[];
      var length = temp.length;
      for (var i = 0; i < length; ++i) {
        lol.add(temp[i].Name);
      }
      return lol;
    }

    void register() async {
      String s;
      if (_rFormKey.currentState.validate()) {
        _rFormKey.currentState.save();
        FocusScope.of(context).requestFocus(FocusNode());
        if (pass == vPass) {
          if (result) {
            if (registerBool) {
              FocusScope.of(context).requestFocus(FocusNode());
              await Provider.of<SignUpIn>(context, listen: false)
                  .signUP(context, mail, pass, vPass);
              if (Provider.of<UserManage>(context, listen: false).pointer ==
                  0) {
                Provider.of<FireStoreUni>(context, listen: false).
      setStudentEntity(Student(id, name, mail, phone));
                await Provider.of<FireStoreUni>(context, listen: false)
                    .setStudent();
              }
              if (Provider.of<UserManage>(context, listen: false).pointer ==
                  2) {
                Provider.of<FireStoreUni>(context, listen: false).setFacultyEntity(
                    Faculty(id, name, mail, phone));
                await Provider.of<FireStoreUni>(context, listen: false)
                    .setFaculty();
              }
              Provider.of<FireStoreUni>(context, listen: false).setRegisteredEntity(Registered(id));
              await Provider.of<FireStoreUni>(context,listen: false).setRegistered();
              s = Provider.of<SignUpIn>(context, listen: false).getMsg();
            } else {
              s = Provider.of<UserManage>(context, listen: false).getName() +
                  ' already registered.';
            }
          } else {
            s = Provider.of<UserManage>(context, listen: false).getName() +
                ' Id not found in chosen ' +
                Provider.of<UserManage>(context, listen: false).getDrop();
          }
        } else {
          s = 'Password do not match with Verify password';
        }
        if (s == 'Success') {
          Provider.of<UserManage>(context, listen: false)
              .showMyDialog(context, 'Registered', 1);
          _rFormKey.currentState.reset();
        } else if (s != null) {
          Provider.of<UserManage>(context, listen: false)
              .errorDialog(s, context);
        }
        result = false;
        registerBool = true;
        Provider.of<UserManage>(context, listen: false).setSelected(null);
      }
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
          _phoneFocus.unfocus();
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

    final vPassField = TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        style: TextStyle(),
        textInputAction: TextInputAction.next,
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
          _verifyFocus.unfocus();
          FocusScope.of(context).requestFocus(_idFocus);
        });

    final idField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _idFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => id = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: Provider.of<UserManage>(context).getName() + ' Id',
            hintText: 'Enter Id.',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _idFocus.unfocus();
        });

    final registerButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: StreamBuilder<List<Registered>>(
          stream: Provider.of<FireStoreUni>(context).getRegistered(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(
                child: SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 150,
                ),
              );
            }
            return MaterialButton(
              minWidth: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                if (_rFormKey.currentState.validate()) {
                  _rFormKey.currentState.save();
                  var len = snap.data.length;
                  for (var i = 0; i < len; ++i) {
                    if (snap.data[i].Id == id) {
                      registerBool = false;
                      break;
                    }
                  }
                }
                register();
              },
              child: Text('Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            );
          }),
    );

    final dropDownF = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30),
      child: StreamBuilder<List<Course>>(
          stream: Provider.of<FireStoreUni>(context).getCourses(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 150,
                ),
              );
            }
            var list = makeStrC(snapshot.data);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: DropdownButton<String>(
                value: Provider.of<UserManage>(context).selected,
                icon: Icon(Icons.arrow_drop_down),
                iconDisabledColor: Colors.blueAccent,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent),
                underline: Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                items: list.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  if (_rFormKey.currentState.validate()) {
                    _rFormKey.currentState.save();
                    var len = snapshot.data.length;
                    for (var i = 0; i < len; ++i) {
                      if (snapshot.data[i].Name == newValue) {
                        if (snapshot.data[i].Faculty_Id == id) {
                          result = true;
                          break;
                        }
                      }
                    }
                  }
                  Provider.of<UserManage>(context, listen: false)
                      .setSelected(newValue);
                },
                hint: Text(
                  'Please select a ' +
                      Provider.of<UserManage>(context).getDrop(),
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            );
          }),
    );

    final dropDownS = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30),
      child: StreamBuilder<List<Degree>>(
          stream: Provider.of<FireStoreUni>(context).getDegrees(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitDoubleBounce(
                  color: Colors.blueAccent,
                  size: 150,
                ),
              );
            }
            var list = makeStrD(snapshot.data);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: DropdownButton<String>(
                value: Provider.of<UserManage>(context).selected,
                icon: Icon(Icons.arrow_drop_down),
                iconDisabledColor: Colors.blueAccent,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent),
                underline: Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                items: list.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  if (_rFormKey.currentState.validate()) {
                    _rFormKey.currentState.save();
                    var len = snapshot.data.length;
                    for (var i = 0; i < len; ++i) {
                      if (snapshot.data[i].Name == newValue) {
                        var ids = snapshot.data[i].Student_Ids;
                        for (var j = 0; j < ids.length; ++j) {
                          if (ids[j] == id) {
                            result = true;
                          }
                        }
                      }
                    }
                  }
                  Provider.of<UserManage>(context, listen: false)
                      .setSelected(newValue);
                },
                hint: Text(
                  'Please select a ' +
                      Provider.of<UserManage>(context).getDrop(),
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            );
          }),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 25,
        title: Center(
            child: Text(
                Provider.of<UserManage>(context).getName() + ' Registration')),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.person,
              size: 30.0,
            ),
          )
        ],
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
                  SizedBox(height: 10.0),
                  phoneField,
                  SizedBox(height: 10.0),
                  emailField,
                  SizedBox(height: 10.0),
                  passField,
                  SizedBox(height: 10.0),
                  vPassField,
                  SizedBox(height: 10.0),
                  idField,
                  SizedBox(height: 30),
                  if (Provider.of<UserManage>(context).pointer == 0) dropDownS,
                  if (Provider.of<UserManage>(context).pointer == 2) dropDownF,
                  SizedBox(height: 30),
                  registerButton,
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
