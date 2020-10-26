import 'package:flutter/material.dart';

class AdminManage extends ChangeNotifier {
  int maintainSelect = 4;
  int crudSelect = 4;
  List<String> action = ['Add', 'Update', 'View', 'Delete', ''];
  List<String> maintain = ['Student', 'Faculty', 'Degree', 'Course', ''];
  List<String> idFormat = ['[4XX]','[3XX]','[1XX]','[2XX]'];
  int id, it = 0;
  bool viewAll = false;

  void setIt(int x) {
    it = x;
    notifyListeners();
  }

  void setId(int x) {
    id = x;
    notifyListeners();
  }

  void toggleView() {
    viewAll = !viewAll;
    notifyListeners();
  }

  void setMSelect(int n) {
    maintainSelect = n;
    notifyListeners();
  }

  void setCSelect(int n) {
    crudSelect = n;
    notifyListeners();
  }

  Color getColorC(int m) {
    if (crudSelect == m) {
      return Colors.blueAccent;
    } else {
      return Colors.black26;
    }
  }

  Color getColorM(int m) {
    if (maintainSelect == m) {
      return Colors.blueAccent;
    } else {
      return Colors.blueAccent.withOpacity(0.3);
    }
  }
}
