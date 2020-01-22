import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emergency/components/Marquee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emergency/model/user.dart';
//import 'package:emergency/pages/messages/addMessage.dart';

class MessagesPage extends StatefulWidget {
  final User user;
  MessagesPage({Key key, @required this.user}):super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController _messageTitleController;
  TextEditingController _messageDescriptionController;
  FirebaseUser currentUser;

  @override
  initState() {
    _messageTitleController = new TextEditingController();
    _messageDescriptionController = new TextEditingController();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Messages'),
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
              .collection("messages")
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
                              document["title"],
                              style: new TextStyle(
                                  color: Colors.pink.shade700, fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                       // direction: Axis.horizontal,
                                        // child: Text(
                                          document["description"],
                                          style: new TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400
                                          )
                                         )
                                      
                                      // new Text(document["description"],
                                          // style: new TextStyle(
                                          //     fontSize: 1, fontWeight: FontWeight.w400)),
                                    ),
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
        tooltip: 'Add new Message',
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
            Text("Please fill all fields to create a new message"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Message Title*'),
                controller: _messageTitleController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Message Description'),
                controller: _messageDescriptionController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              _messageTitleController.clear();
              _messageDescriptionController.clear();
              Navigator.pop(context);
            }),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if (_messageDescriptionController.text.isNotEmpty &&
                  _messageTitleController.text.isNotEmpty) {
                Firestore.instance
                  .collection("users")
                  .document(widget.user.email)
                  .collection("messages")
                  .add({
                    "title": _messageTitleController.text,
                    "description": _messageDescriptionController.text
                })
                .then((result) => {
                  Navigator.pop(context),
                  _messageTitleController.clear(),
                  _messageDescriptionController.clear(),
                })
                .catchError((err) => print(err));
            }
          })
        ],
      ),
    );
  }
}
