import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniresys/screens/admin_screen.dart';

class AdminManage extends ChangeNotifier{
 int maintainSelect = 4;
 int crudSelect = 4;
 List<String> action=['Add','Update','View','Delete',''];
 List<String> maintain=['Student','Faculty','Degree','Course',''];

 void setMSelect(int n){
   maintainSelect = n;
   notifyListeners();
 }

 void setCSelect(int n){
   crudSelect = n;
   notifyListeners();
 }

 Color getColorC(int m){
   if(crudSelect==m) {
     return Colors.blueAccent;
   } else {
     return Colors.black26;
   }
 }

 Color getColorM(int m){
   if(maintainSelect==m) {
     return Colors.blueAccent;
   } else {
     return Colors.blueAccent.withOpacity(0.3);
   }
 }
}