import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/screens/change_screen.dart';
import 'package:uniresys/screens/update_screen.dart';

import 'package:uniresys/users.dart';

class AdminScreen extends StatelessWidget {
  static const String id = 'admin_screen';

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
        scaffold: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            leading: Icon(Icons.contacts_outlined,size: 30,),
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
            child: Container(),
          ),
        ),
      ),
    );
  }

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
  GlobalKey<InnerDrawerState>();
}