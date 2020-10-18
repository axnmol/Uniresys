import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniresys/screens/profile_screen.dart';

class Users{
  String name;
  Users(this.name);
}

class UserManage extends ChangeNotifier{
  bool isLoad = false;
  int pointer=1;
  String selected;
  final List<String> _drop=['Degree','','Course'];
  final List<Users> _users=[
    Users('Student'),
    Users('Admin'),
    Users('Faculty')
  ];

  void showMyDialog(BuildContext context,String str,int x) {
    dynamic msg;
    // For Sign In and Sign Up
    if(x==1) {
      msg = _users[pointer].name + ' Successfully '+str;
    }
    // For Feedback
    if(x==2) {
      msg = 'Feedback Successfully '+str;
    }
    showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          title: Text(
            'Successful',
            textAlign: TextAlign.center,
          ),
          content: Text(msg.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.maybePop(context);
                if(x==1){
                    Navigator.pushNamed(context, ProfileScreen.id);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void errorDialog(String s,BuildContext context) {
    showDialog<AlertDialog>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          title: Text('Unsuccessful', textAlign: TextAlign.center),
          content: Text(
            s,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setSelected(String string){
    selected = string ;
    notifyListeners();
  }


  void setSelect(int n){
    if(n>2&&n<0)return;
    pointer=n;
    notifyListeners();
  }

  void toggle_Load(){
    isLoad=isLoad?false:true;
    notifyListeners();
  }

  String getName(){
    return _users[pointer].name;
  }

  String getDrop(){
    return _drop[pointer];
  }

  Color getColor(int n){
    if(n==pointer) {
      return Colors.blueAccent;
    } else {
      return Colors.black54;
    }
  }
}