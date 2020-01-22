import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emergency/components/Marquee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emergency/model/user.dart';
//import 'package:emergency/pages/History/addMessage.dart';

class HistoryPage extends StatefulWidget {
  final User user;
  HistoryPage({Key key, @required this.user}):super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FirebaseUser currentUser;

  @override
  initState() {
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
        title: Text('History'),
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
              .collection("history")
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
                              document["date"],
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
                                          document["address"],
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
    );
  }
}
