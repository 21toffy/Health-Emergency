import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  static const NAME = "name";
  static const PHONE = "phone";

  String _name;
  num _phone;

  String get name => _name;
  num get phone => _phone;

  Contact.fromSnapshot(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    _name = data[NAME];
    _phone = data[PHONE];
  }
}