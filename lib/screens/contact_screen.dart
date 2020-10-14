import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:uniresys/flutterfire/firestore.dart';
import 'package:uniresys/users.dart';

class ContactScreen extends StatelessWidget {
  static const String id = 'contact_screen';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _feed;

    void submitFeed() async{
      String s;
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        FocusScope.of(context).requestFocus(FocusNode());
         await Provider.of<FirestoreUni>(context, listen: false)
            .addFeed(_feed, context);
        s = Provider.of<FirestoreUni>(context, listen: false).getMsg();
      }
      if (s == 'Success') {
        Provider.of<UserManage>(context, listen: false)
            .showMyDialog(context, 'Submitted', 2);
        _formKey.currentState.reset();
      } else if (s != null) {
        Provider.of<UserManage>(context, listen: false).errorDialog(s, context);
      }
    }

    final feedField = TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      minLines: 1,
      style: TextStyle(),
      textInputAction: TextInputAction.done,
      validator: (input) => input.isEmpty ? 'Required' : null,
      onSaved: (input) => _feed = input,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 40.0),
          labelText: 'Feedback',
          hintText: 'Submit Feedback',
          suffixIcon: Icon(Icons.feedback),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );

    final submitButton = Material(
      elevation: 10,
      shadowColor: Colors.blueAccent,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          submitFeed();
        },
        child: Text('Submit',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 25,
        title: Text('Contact University'),
      ),
      body: LoadingOverlay(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      '   : +91-987654321',
                      style: TextStyle(fontSize: 30, color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.mail,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      '   : abc@uni.edu',
                      style: TextStyle(fontSize: 30, color: Colors.black54),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 35,
                      color: Colors.blueAccent,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '   : Street name, City name',
                          style: TextStyle(fontSize: 25, color: Colors.black54),
                        ),
                        Text(
                          'State name, Pincode',
                          style: TextStyle(fontSize: 25, color: Colors.black54),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 25,
                ),
                Form(key: _formKey, child: feedField),
                SizedBox(
                  height: 25,
                ),
                submitButton,
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Image.asset(
                    'assets/feedback.png',
                    fit: BoxFit.contain,
                  ),
                )
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
    );
  }
}
