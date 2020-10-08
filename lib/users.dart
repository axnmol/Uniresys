import 'package:flutter/material.dart';

class Users{
  String name;
  Users(this.name);

  String getName(){
    return name;
  }
}

class UserManage extends ChangeNotifier{
  bool _isLoad = false;
  int pointer=1;
  final List<String> _ids=['Enrollment','','Enlistment'];
  final List<String> _drop=['Degree','','Subject'];
  final List<Users> _users=[
    Users('Student'),
    Users('Admin'),
    Users('Faculty')
  ];

  void showMyDialog(BuildContext context,String str,int x) {
    dynamic msg;
    // For Sign In and Sign Up
    if(x==1) {
      msg = _users[pointer].getName()+ ' Successfully '+str;
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

  void setSelect(int n){
    if(n>2&&n<0)return;
    pointer=n;
    notifyListeners();
  }

  int getSelect(){
    return pointer;
  }

  bool getLoad(){
    return _isLoad;
  }

  void toggle_Load(){
    _isLoad=_isLoad?false:true;
    notifyListeners();
  }

  String getName(){
    return _users[pointer].getName();
  }

  String getId(){
    return _ids[pointer];
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