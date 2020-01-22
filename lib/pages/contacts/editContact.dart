import 'package:flutter/material.dart';

class EditContactsPage extends StatefulWidget {
  @override
  _EditContactsPageState createState() => _EditContactsPageState();
}

class _EditContactsPageState extends State<EditContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Health Emergency'),
        actions: <Widget>[
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: new Icon(Icons.done),
      ),
    );
  }
}
