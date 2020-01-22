import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:emergency/pages/contacts/addContact.dart';

class ContactsPage extends StatefulWidget {
  final User user;
  ContactsPage({Key key, @required this.user}):super(key: key);
  
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController _contactNameController;
  TextEditingController _contactPhoneController;
  FirebaseUser currentUser;

  @override
  initState() {
    _contactNameController = new TextEditingController();
    _contactPhoneController = new TextEditingController();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  // _deleteContact() async {
  //   await Firestore.instance.collection("users").document(widget.user.uid).collection("contacts").document()
  //   Fluttertoast.showToast(msg: "Profile Updated");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Contacts'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
              .collection("users")
              .document(widget.user.email)
              .collection("contacts")
              .snapshots(),
            builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                        return Card(
                          child: ListTile(
                            title: new Text(
                              document["name"],
                              style: new TextStyle(
                                  color: Colors.pink.shade700, fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    //Phone Number of Contact
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Text("Phone:",
                                          style: new TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w400)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: new Text(document["phone"],
                                          style: new TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w600)),
                                    ),

                                    // new Padding(
                                    //   padding: const EdgeInsets.fromLTRB(19.0, 8.0, 7.0, 8.0),
                                    //   child: new Text("Email:",
                                    //       style: new TextStyle(
                                    //           fontSize: 12, fontWeight: FontWeight.w400)),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(0),
                                    //   child: new Text(contactEmail,
                                    //       style: new TextStyle(
                                    //           fontSize: 12, fontWeight: FontWeight.w600)),
                                    // ),
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                        );
                    }).toList(),
                  );
              }
            },
          )),
        ),


      floatingActionButton: new FloatingActionButton(
        onPressed: () {_showDialog();},
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add new contact',
        child: new Icon(Icons.add),
      ),
    );
  }


    _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to add a new contact"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Contact Name*'),
                controller: _contactNameController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Contact Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                controller: _contactPhoneController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              _contactNameController.clear();
              _contactPhoneController.clear();
              Navigator.pop(context);
            }),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if (_contactPhoneController.text.isNotEmpty &&
                  _contactNameController.text.isNotEmpty) {
                Firestore.instance
                  .collection("users")
                  .document(widget.user.email)
                  .collection("contacts")
                  .add({
                    "name": _contactNameController.text,
                    "phone": _contactPhoneController.text
                })
                .then((result) => {
                  Navigator.pop(context),
                  _contactNameController.clear(),
                  _contactPhoneController.clear(),
                })
                .catchError((err) => print(err));
            }
          })
        ],
      ),
    );
  }
}

