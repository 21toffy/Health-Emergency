import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Settings'),
        actions: <Widget>[
          
        ],
        
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed:(){},
        backgroundColor: Colors.deepPurple,
        tooltip: 'Add new Message',
        child: new Icon(Icons.done),
      ),
    );
  }
}
