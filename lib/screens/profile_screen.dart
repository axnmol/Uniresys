import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu,size: 30)
            ),
          )
        ],
        elevation: 25,
        brightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
