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

class AdminScreen extends StatelessWidget {
  static const String id = 'admin_screen';

  final _idFormKey = GlobalKey<FormState>();
  final FocusNode _idFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var fireStoreUni = Provider.of<FireStoreUni>(context);
    var adminManage = Provider.of<AdminManage>(context);
    var userManage = Provider.of<UserManage>(context);

    var courses = <Course>[];
    var degrees = <Degree>[];
    var faculties = <Faculty>[];
    var students = <Student>[];

    int id;

    void handle() async{
      userManage.toggle_Load();
      if(adminManage.crudSelect!=0) {
        if (await _idFormKey.currentState.validate()) {
          await _idFormKey.currentState.save();
          _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.start);
        }
      }
      else{
        _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.start);
      }
      userManage.toggle_Load();
    }

    final idField = TextFormField(
        keyboardType: TextInputType.number,
        style: TextStyle(),
        textInputAction: TextInputAction.done,
        focusNode: _idFocus,
        validator: (input) => input.isEmpty ? 'Required' : null,
        onSaved: (input) => id = int.parse(input),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: adminManage.maintain[adminManage.maintainSelect] + ' Id',
            hintText: 'Enter Id.',
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
        onFieldSubmitted: (term) {
          _idFocus.unfocus();
        });

    final defaultButton = Material(
        elevation: 10,
        shadowColor: Colors.blueAccent,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blueAccent,
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
                                return MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width / 3,
                                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  onPressed: () async{
                                    courses = await snapCourse.data;
                                    degrees = await snapDegree.data;
                                    faculties = await snapFaculty.data;
                                    students = await snapStudent.data;
                                    handle();
                                  },
                                  child: Text(adminManage.action[adminManage.crudSelect]+'  '+adminManage.maintain[adminManage.maintainSelect],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold)),
                                );
                              }
                          );
                        }
                    );
                  }
              );
            }
        )
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true,
        swipe: false,
        colorTransitionChild: Colors.blueAccent.withOpacity(0.75),
        colorTransitionScaffold: Colors.blueAccent.withOpacity(0.75),
        offset: IDOffset.only(bottom: 0.05, right: 0.05, left: 0.0),
        scale: IDOffset.horizontal(0.8),
        proportionalChildArea: true,
        borderRadius: 50,
        leftAnimationType: InnerDrawerAnimation.quadratic,
        rightAnimationType: InnerDrawerAnimation.quadratic,
        backgroundDecoration: BoxDecoration(color: Colors.white),
        //innerDrawerCallback: return  true (open) or false (close)
        leftChild: null,
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
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w800),
                  ),
                  Text('Management',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 30),
                  OutlineButton(
                    onPressed: () {
                      Navigator.pushNamed(context, UpdateScreen.id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        '   Update  \nInformation',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
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
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                    shape: StadiumBorder(),
                  ),
                  SizedBox(height: 15),
                  OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
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
                        _innerDrawerKey.currentState
                            .open(direction: InnerDrawerDirection.end);
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
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            letterSpacing: 5),
                      ),
                      SizedBox(
                        height: 15,
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
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
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
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          )
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
                              adminManage..setMSelect(0);
                            },
                            child: Material(
                              elevation: 10,
                              shadowColor: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: adminManage.getColorM(0),
                                    border:
                                    Border.all(width: 2, color: Colors.black54),
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
                                          border: Border.all(
                                              width: 2, color: Colors.black54),
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
                                                  color: Colors.blueAccent,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600)),
                                          Text('Student Records',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
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
                                    border:
                                    Border.all(width: 2, color: Colors.black54),
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
                                          border: Border.all(
                                              width: 2, color: Colors.black54),
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
                                                color: Colors.blueAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Faculty Records',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
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
                        height: 25,
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
                                    border:
                                    Border.all(width: 2, color: Colors.black54),
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
                                          border: Border.all(
                                              width: 2, color: Colors.black54),
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
                                                  color: Colors.blueAccent,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600)),
                                          Text('Degree Records',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25,
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
                                    border:
                                    Border.all(width: 2, color: Colors.black54),
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
                                          border: Border.all(
                                              width: 2, color: Colors.black54),
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
                                                color: Colors.blueAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Course Records',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
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
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if(adminManage.maintainSelect==2||adminManage.maintainSelect==3)
                            OutlineButton(
                              onPressed: () {adminManage.setCSelect(0);},
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: Text(
                                  adminManage.action[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              borderSide: BorderSide(color: adminManage.getColorC(0), width: 5),
                              shape: StadiumBorder(),
                            ),
                          if(adminManage.maintainSelect==2||adminManage.maintainSelect==3)
                            SizedBox(
                              width: 40,
                            ),
                          OutlineButton(
                            onPressed: () {adminManage.setCSelect(1);},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Text(
                                adminManage.action[1],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            borderSide: BorderSide(color: adminManage.getColorC(1), width: 5),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlineButton(
                            onPressed: () {adminManage.setCSelect(2);},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Text(
                                adminManage.action[2],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            borderSide: BorderSide(color: adminManage.getColorC(2), width: 5),
                            shape: StadiumBorder(),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          OutlineButton(
                            onPressed: () {adminManage.setCSelect(3);},
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: Text(
                                adminManage.action[3],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            borderSide: BorderSide(color: adminManage.getColorC(3), width: 5),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                      if(adminManage.crudSelect!=0)
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(key: _idFormKey,child: idField),
                        ),
                      if(adminManage.crudSelect==0)
                        SizedBox(height: 20,),
                      if(adminManage.crudSelect!=4&&adminManage.maintainSelect!=4&&!(adminManage.crudSelect==0&&adminManage.maintainSelect==0)&&!(adminManage.crudSelect==0&&adminManage.maintainSelect==1))defaultButton,
                      Consumer<ScreenHeight>( builder: (context, _res, child) { return Container( height:  _res.keyboardHeight);})
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
      ),
    );
  }

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
  GlobalKey<InnerDrawerState>();
}
