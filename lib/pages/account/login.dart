import 'package:emergency/model/user.dart';
import 'package:emergency/pages/account/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/pages/home.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  SharedPreferences preferences;
  bool loading = false;
  bool isLoggedIn = false;
  String error = "";
  
  @override
  void initState(){
    super.initState();
    //sSignedIn();
  }
  
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'Assets/images/eee.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 270),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 280.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
                              labelStyle: TextStyle(
                                fontSize: 15
                              )
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value){
                              if (value.isEmpty) {
                                Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value)) {
                                  return "Please enter a valid email address";
                                }else{
                                  return null;
                                }
                                
                              }

                            }
                          ),
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              labelStyle: TextStyle(
                                fontSize: 15
                              )
                            ),
                            validator: (value){
                              if (value.isEmpty) {
                                return "The password field cannot be empty";
                              }else if (value.length < 6) {
                                return "The password should be atleast 6 characters long";
                              }
                              return null;
                            },
                            controller: _passwordTextController,
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue.withOpacity(0.8),
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: (){
                            handleLogin();
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        )
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text(
                          "Forgot password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: (){
                          resetPassword();
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                        },
                        child: Text(
                          "Create an account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.0,
                          ),
                        )
                      )
                    ),

                  ],
                ),
              ),
            ),
          ),
          
          
          Visibility(
            visible: loading ?? true,
            child:Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future handleLogin() async{
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      try {
        FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text
        )
        .then((currentUser) => Firestore.instance
        .collection("users")
        .document(currentUser.user.email.toLowerCase())
        .get()
        .then(
          (DocumentSnapshot result) =>{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(
              user:  User(
                uid: currentUser.user.uid,
                email: currentUser.user.email,
                fullname: result["fullname"], 
                gender: result["gender"],
                emNumber: result["emNumber"],
                address: result["address"],
                )
              ))
            )
          }
        )
        .catchError((err){
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: "Invalid login details");
         })
        )
        .catchError((err){
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: "Invalid login details");
         });
         
         
      } catch (e) {
        
      }
      
    }
  }

  Future<void> resetPassword() async {
    if(_emailTextController.text == null)
    {
      Fluttertoast.showToast(msg: "Provide your email address in the email field");
    }
    await firebaseAuth.sendPasswordResetEmail(email: _emailTextController.text);
    Fluttertoast.showToast(msg: "Check your mail");
  }

}