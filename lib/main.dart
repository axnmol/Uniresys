import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:uniresys/screens/admin_screen.dart';

import 'package:uniresys/screens/change_screen.dart';
import 'package:uniresys/screens/home_screen.dart';
import 'package:uniresys/screens/profile_screen.dart';
import 'package:uniresys/screens/register_screen.dart';
import 'package:uniresys/screens/contact_screen.dart';
import 'package:uniresys/screens/update_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:uniresys/flutterfire/fireauth.dart';
import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/users.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(), // Main App
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            width: 1,
            color: Colors.red,
          ); //SomethingWentWrong();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserManage>(
                create: (BuildContext context) => UserManage(),
              ),
              ChangeNotifierProvider<FireStoreUni>(
                create: (BuildContext context) => FireStoreUni(),
              ),
              ChangeNotifierProvider<SignUpIn>(
                create: (BuildContext context) => SignUpIn(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: HomeScreen.id, // Initial Screen
              onGenerateRoute: (settings) {
                // Id id for route String
                switch (settings.name) {
                  case HomeScreen.id:
                    return PageTransition<void>(
                        child: HomeScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                    break;
                  case RegisterScreen.id:
                    return PageTransition<void>(
                        child: RegisterScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                    break;
                  case ContactScreen.id:
                    return PageTransition<void>(
                        child: ContactScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                  case ProfileScreen.id:
                    return PageTransition<void>(
                        child: ProfileScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                    break;
                  case ChangeScreen.id:
                    return PageTransition<void>(
                        child: ChangeScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                    break;
                  case UpdateScreen.id:
                    return PageTransition<void>(
                        child: UpdateScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                  case AdminScreen.id:
                    return PageTransition<void>(
                        child: AdminScreen(),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 400));
                    break;
                  default:
                    return null;
                }
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.blueAccent,
          width: 1,
        );
      },
    );
  }
}
