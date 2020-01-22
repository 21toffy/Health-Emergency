import 'package:flutter/material.dart';

class EditMessagePage extends StatefulWidget {
  @override
  _EditMessagePageState createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Message Title'),
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
