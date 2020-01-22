import 'package:emergency/model/user.dart';
import 'package:emergency/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }


  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }
  //Sign in with email

  //sign in with google
  
  //sign in with email and password
  // Future SignInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.signInWithEmailAndPassword(
        
  //     )
  //   } catch (e) {
  //   }
  // }
  //register with email and password
  // Future RegisterWithEmailAndPassword(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password
  //     );

  //     FirebaseUser user = result.user;
  //     //create a new document for the user wit the uid
  //     await UserDb(uid: user.uid).UpdateUserData(fullname, gender);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //signout


  
}