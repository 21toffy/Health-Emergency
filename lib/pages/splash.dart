import 'package:emergency/model/user.dart';
import 'package:emergency/pages/account/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
      .currentUser()
        .then((currentUser) => {
          if (currentUser == null)
            {
              Navigator.pushReplacement(
                context, MaterialPageRoute(
                  builder: (context) => Login()))
            }
          else
          {
            Firestore.instance
              .collection("users")
              .document(currentUser.email.toLowerCase())
              .get()
              .then((DocumentSnapshot result) => 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(user: User(
                      uid: currentUser.uid,
                      fullname: result["fullname"],
                      email: result["email"],
                      gender: result["gender"],
                      address: result["address"],
                      emNumber: result["emNumber"]
                  )))))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
            ),            
            new Image.asset(
            'Assets/images/emguy.png',
            fit: BoxFit.cover,
            width: double.infinity,
            ),

            new Text(
              "Emergency",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 54.0,
              ),
            )
          ],
        )
      ),
    );
  }
}