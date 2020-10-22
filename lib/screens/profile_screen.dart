import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:uniresys/entities/entities.dart';
import 'package:uniresys/flutterfire/fireauth.dart';
import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/screens/change_screen.dart';
import 'package:uniresys/screens/update_screen.dart';
import 'package:uniresys/users.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    var x = Provider.of<UserManage>(context).pointer;
    var student = Provider.of<FireStoreUni>(context).student;
    var faculty = Provider.of<FireStoreUni>(context).faculty;
    var button = <String>['Courses', '', 'Students'];

    Course course;
    Degree degree;

    String countCredits(List<Course> c){
      var cr=0;
      c.forEach((element) {cr+=element.Credits;});
      return cr.toString();
    }

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
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    if (x == 0)
                      Column(
                        children: <Widget>[
                          Text(
                            'List of Courses',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54,
                                fontSize: 40),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            height: MediaQuery.of(context).size.height/1.4,
                            child: NotificationListener<OverscrollIndicatorNotification>(
                              // ignore: missing_return
                              onNotification: (overScroll) {
                                overScroll.disallowGlow();
                              },
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: Provider.of<FireStoreUni>(context).courses.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,15,0,0),
                                        child: Icon(Icons.book,size: 50,),
                                      ),
                                      title: Align(
                                        alignment: Alignment(-1.1,0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Material(
                                            color: Colors.blueAccent.withOpacity(0.75),
                                            elevation: 10,
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              width: MediaQuery.of(context).size.width/1.5,
                                              height: MediaQuery.of(context).size.height/8,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text( Provider.of<FireStoreUni>(context).courses[index].Id.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 15
                                                    ),),
                                                  Text( Provider.of<FireStoreUni>(context).courses[index].Name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800,
                                                        fontSize: 20
                                                    ),),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('Credits -',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),),
                                                      SizedBox(width: 10,),
                                                      Text(Provider.of<FireStoreUni>(context).courses[index].Credits.toString(),style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15
                                                      ),),
                                                      SizedBox(width: 30,),
                                                      Text('Seats -',style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),),
                                                      SizedBox(width: 10,),
                                                      Text(Provider.of<FireStoreUni>(context).courses[index].Seats.toString(),style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15
                                                      ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('Faculty ID -',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                                                      SizedBox(width: 10,),
                                                      Text(Provider.of<FireStoreUni>(context).courses[index].Faculty_Id.toString(),style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18
                                                      ),),

                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),
                        ]
                      ),
                    if (x == 2)
                      Column(
                        children: <Widget>[
                          Text(
                            'List of Students',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54,
                                fontSize: 40),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            height: MediaQuery.of(context).size.height/1.4,
                            child: NotificationListener<OverscrollIndicatorNotification>(
                                // ignore: missing_return
                                onNotification: (overScroll) {
                                  overScroll.disallowGlow();
                                },
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                  itemCount: Provider.of<FireStoreUni>(context).students.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return ListTile(
                                      leading: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,8,0,0),
                                        child: Icon(Icons.person,size: 50,),
                                      ),
                                      title: Align(
                                        alignment: Alignment(-1.1,0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Material(
                                            color: Colors.blueAccent.withOpacity(0.75),
                                            elevation: 10,
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15),
                                              width: MediaQuery.of(context).size.width/1.5,
                                              height: MediaQuery.of(context).size.height/10,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text( Provider.of<FireStoreUni>(context).students[index].Name+' - '+Provider.of<FireStoreUni>(context).students[index].Id.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20
                                                  ),),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.phone,color: Colors.white,size: 15,),
                                                      SizedBox(width: 10,),
                                                      Text(Provider.of<FireStoreUni>(context).students[index].Phone,style: TextStyle(
                                                        color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15
                                                      ),)

                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.mail,color: Colors.white,size: 15,),
                                                      SizedBox(width: 10,),
                                                      Text(Provider.of<FireStoreUni>(context).students[index].Email,style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15
                                                      ),),

                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )),
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
                    onPressed: () async {
                      await Provider.of<SignUpIn>(context, listen: false)
                          .signOut();
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
          body: SingleChildScrollView(
            child:
                  SafeArea(
                    child: StreamBuilder<List<Course>>(
                        stream: Provider.of<FireStoreUni>(context).getCourses(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SpinKitDoubleBounce(
                                color: Colors.blue,
                                size: 150,
                              ),
                            );
                          }
                          var len = snapshot.data.length;
                          for (var i = 0; i < len; ++i) {
                            if (x == 2) {
                              if (snapshot.data[i].Faculty_Id == faculty.Id) {
                                course = snapshot.data[i];
                              }
                            }
                          }
                          return Container(
                            padding: EdgeInsets.all(30),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (x == 0)
                                  StreamBuilder<List<Course>>(
                                      stream: Provider.of<FireStoreUni>(context).getCoursesStudents(student.Id),
                                      builder: (context, snapCStudent) {
                                        if (!snapCStudent.hasData) {
                                          return Center(
                                            child: SpinKitDoubleBounce(
                                              color: Colors.blue,
                                              size: 150,
                                            ),
                                          );
                                        }
                                        Provider.of<FireStoreUni>(context).courses = snapCStudent.data;
                                      return Text(
                                        'ID : ' + student.Id.toString(),
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 10),
                                      );
                                    }
                                  ),
                                if(x==2)
                                  StreamBuilder<List<Student>>(
                                    stream: Provider.of<FireStoreUni>(context).getStudentFaculty(course.Student_Ids),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SpinKitDoubleBounce(
                                            color: Colors.blue,
                                            size: 150,
                                          ),
                                        );
                                      }
                                      Provider.of<FireStoreUni>(context).students = snapshot.data;
                                      return Text(
                                        'ID : ' + faculty.Id.toString(),
                                        style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 10),
                                      );
                                    }
                                  ),
                                SizedBox(
                                  height: 15,
                                ),
                                Material(
                                  elevation: 10,
                                  shadowColor: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        border: Border.all(
                                            width: 2, color: Colors.black54),
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width / 1,
                                    child: Padding(
                                      padding: EdgeInsets.all(30.0),
                                      child: Material(
                                        elevation: 10,
                                        shadowColor: Colors.white,
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white54),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: FittedBox(
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.black54,
                                                  ),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              if (x == 0)
                                                Text(student.Name,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              if (x == 2)
                                                Text(faculty.Name,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              SizedBox(height: 10),
                                              if (x == 0)
                                                Text(student.Email,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              if (x == 2)
                                                Text(faculty.Email,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              SizedBox(height: 10),
                                              if (x == 0)
                                                Text(student.Phone,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              if (x == 2)
                                                Text(faculty.Phone,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              SizedBox(height: 10),
                                              if (x == 0)
                                                StreamBuilder<List<Degree>>(
                                                    stream:
                                                        Provider.of<FireStoreUni>(
                                                                context)
                                                            .getDegrees(),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child:
                                                              SpinKitDoubleBounce(
                                                            color: Colors.white,
                                                            size: 150,
                                                          ),
                                                        );
                                                      }
                                                      var len =
                                                          snapshot.data.length;
                                                      for (var i = 0;
                                                          i < len;
                                                          ++i) {
                                                        var length = snapshot
                                                            .data[i]
                                                            .Student_Ids
                                                            .length;
                                                        for (var j = 0;
                                                            j < length;
                                                            ++j) {
                                                          if (snapshot.data[i]
                                                                      .Student_Ids[
                                                                  j] ==
                                                              student.Id) {
                                                            degree =
                                                                snapshot.data[i];
                                                          }
                                                        }
                                                      }
                                                      return Text(
                                                        degree.Name,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      );
                                                    }),
                                              if (x == 2)
                                                Text(
                                                  course.Name,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (x == 0)
                                  Text(
                                    'Courses enrolled by a student : ' + Provider.of<FireStoreUni>(context).courses.length.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                if (x == 0)
                                  SizedBox(
                                    height: 15,
                                  ),
                                if (x == 2)
                                  Text(
                                    'Students teached by the faculty : ' +
                                        course.Student_Ids.length.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                if (x == 0)
                                  Text(
                                    'Credits attained by a student : '+ countCredits(Provider.of<FireStoreUni>(context).courses),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black54),
                                  ),
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  color: Colors.blueAccent,
                                  elevation: 10,
                                  onPressed: () {
                                    _innerDrawerKey.currentState.open(
                                        direction: InnerDrawerDirection.start);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'View ' + button[x],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  shape: StadiumBorder(),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
          ),
        ),
      ),
    );
  }
  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
}
