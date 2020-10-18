import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/screens/change_screen.dart';
import 'package:uniresys/screens/update_screen.dart';

import 'package:uniresys/users.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true,
        swipe: true,
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
        leftChild: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    if (Provider.of<UserManage>(context).pointer == 1)
                      Text(
                        'List of Courses',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.blueAccent,
                            fontSize: 30),
                      ),
                    if (Provider.of<UserManage>(context).pointer == 2)
                      Text(
                        'List of Students',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.blueAccent,
                            fontSize: 30),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    //listview
                  ],
                )),
          ),
        ),
        rightChild: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.fromLTRB(10, 150, 10, 50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.contacts_rounded,
                    size: MediaQuery.of(context).size.width / 3,
                    color: Colors.blueAccent,
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
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    shape: StadiumBorder(),
                  ),
                ],
              ),
            ),
          ),
        ),
        scaffold: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
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
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Material(
                    elevation: 10,
                    shadowColor: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(50.0)),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Material(
                          elevation: 10,
                          shadowColor: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: MediaQuery.of(context).size.width / 2.5,
                                  color: Colors.blueAccent,
                                ),
                                Text('Name',style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600
                                )),
                                SizedBox(height: 5),
                                Text('Email',style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600
                                )),
                                SizedBox(height: 5),
                                Text('Phone',style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600
                                )),
                                SizedBox(height: 5),
                                Text('Degree/Course',style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  OutlineButton(
                    onPressed: () {
                      _innerDrawerKey.currentState.open(direction: InnerDrawerDirection.start);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'View Students/Courses',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    shape: StadiumBorder(),
                  ),
                ],
              ),
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
