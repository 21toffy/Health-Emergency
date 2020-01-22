import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/model/user.dart';
import 'package:emergency/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:emergency/db/users.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
  
class _RegisterState extends State<Register> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  
  //UserServices _userServices = UserServices();
  
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  String gender;
  num emNumber = 07088501809;
  String groupValue = "male";
  bool hidePassword = true;
  bool loading = false;



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
            padding: const EdgeInsets.only(top: 250.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: TextFormField(
                            // style: TextStyle(
                            //   color: Colors.black,
                            //   fontFamily: 'SFUIDisplay'
                            // ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline),
                              // labelStyle: TextStyle(
                              //   fontSize: 15
                              // )
                            ),
                            validator: (value){
                              if (value.isEmpty) {
                                return "The name field cannot be empty";
                              }
                              return null;
                            },
                            controller: _nameTextController,
                          ),
                        ),
                      ),
                    ),

                  

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: TextFormField(
                            // style: TextStyle(
                            //   color: Colors.black,
                            //   fontFamily: 'SFUIDisplay'
                            // ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
                              // labelStyle: TextStyle(
                              //   fontSize: 15
                              // )
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
                      padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 4.0),
                      child: new Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  "Male",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                trailing: Radio(
                                  value: "male",
                                  groupValue: groupValue,
                                  onChanged: (e)=> valueChanged(e)
                                ),
                              )
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  "Female",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                trailing: Radio(
                                  value: "female",
                                  groupValue: groupValue,
                                  onChanged: (e)=> valueChanged(e)
                                ),
                              )
                            ),
                            
                          ],
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: ListTile(
                            title: TextFormField(
                              // style: TextStyle(
                              //   color: Colors.black,
                              //   fontFamily: 'SFUIDisplay'
                              // ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                // labelStyle: TextStyle(
                                //   fontSize: 15
                                // )
                              ),
                              validator: (value){
                                if (value.isEmpty) {
                                  return "The password field cannot be empty";
                                }else if (value.length < 6) {
                                  return "The password should be atleast 6 characters long";
                                }
                                return null;
                              },
                              obscureText: hidePassword,
                              controller: _passwordTextController,
                            ),
                            trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                              setState(() {
                                hidePassword = false;
                              });
                            },),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 4.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.withOpacity(0.2),
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: ListTile(
                            title: TextFormField(
                              // style: TextStyle(
                              //   color: Colors.black,
                              //   fontFamily: 'SFUIDisplay'
                              // ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                // labelStyle: TextStyle(
                                //   fontSize: 15
                                // )
                              ),
                              validator: (value){
                                if (value.isEmpty) {
                                  return "The password field cannot be empty";
                                }else if (value.length < 6) {
                                  return "The password should be atleast 6 characters long";
                                }else if (_passwordTextController.text != value) {
                                  return "The passwords do not match";
                                }
                                return null;
                              },
                              obscureText: hidePassword,
                              controller: _confirmPasswordTextController,
                            ),
                            trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                              setState(() {
                                hidePassword = false;
                              });
                            },),
                          ),
                        ),
                      ),
                    ),




                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red.shade900.withOpacity(0.8),
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: (){
                            handleRegister();
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign up",
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
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Log in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 15.0,
                          ),
                        )
                      )
                    ),



                    //Expanded(child: Container()),

                    //Divider(color:Colors.black),

                    // Text(
                    //   "Other login in option",
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 16.0,
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Material(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //     color: Colors.red.withOpacity(0.8),
                    //     elevation: 0.0,
                    //     child: MaterialButton(
                    //       onPressed: (){},
                    //       minWidth: MediaQuery.of(context).size.width,
                    //       child: Text(
                    //         "Google",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18.0,
                    //         ),
                    //       ),
                    //     )
                    //   ),
                    // ),


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

  valueChanged(e) {
    setState((){
      if (e == "male") {
        groupValue = e;
        gender = e;
      }else if (e == "female"){
        groupValue = e;
        gender = e;
      }
    });
  }


Future handleRegister() async {
  setState(() {
            loading = true;
          });
  if (_formKey.currentState.validate()) {
    

    if (_passwordTextController.text ==
        _confirmPasswordTextController.text) {
          
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((currentUser) => Firestore.instance
              .collection("users")
              .document(currentUser.user.email.toLowerCase())
              .setData({
                "uid": currentUser.user.uid,
                "fullname": _nameTextController.text,
                "gender": gender,
                "email": currentUser.user.email,
                "address" : " ",
                "emNumber" : "08159011464",
                "find_me" : " ",
              })
              .then((result) => {
                Navigator.pop(context),
                  _emailTextController.clear(),
                  _nameTextController.clear(),
                  _passwordTextController.clear(),
                  _confirmPasswordTextController.clear(),
                })
              .catchError((err){
                setState(() {
                  loading = false;
                });
                Fluttertoast.showToast(msg: "Error in registration");
              }))
          .catchError((err) {
            setState(() {
              loading = false;
            });
            Fluttertoast.showToast(msg: "User with the email exist");
          });
         
          setState(() {
            loading = false;
          });
          

      } else {}

     
    }
     //Fluttertoast.showToast(msg: "You are registered, please log in");
  }
}

