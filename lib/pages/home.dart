import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/model/url.dart';
import 'package:emergency/model/user.dart';
import 'package:emergency/pages/account/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emergency/pages/account/profile.dart';
import 'package:emergency/pages/history/history.dart';
import 'package:emergency/pages/messages/messages.dart';
import 'package:emergency/pages/settings/settings.dart';
import 'package:emergency/pages/contacts/contacts.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, @required this.user}):super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //List<Contact> _contacts =  [];
  //String _message;
  List contacts = [];
  Url url;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  TextEditingController _contactPhoneController;
  

  @override
  
  void initState() {
    _contactPhoneController = new TextEditingController();
    super.initState();
    
  }


  Widget build(BuildContext context) {
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(
        height: 20,
      ),
      Text('Information'),
      Text('Privacy Policy'),
      Text('Terms of Service'),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              style: TextStyle(color: Theme.of(context).accentColor),
              text: 'www.lasu.edu.ng'
            )
          ]
        ),
      )
    ];


    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pink.shade700,
        title: Text('Health Emergency'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed:  () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new HistoryPage(
                  user: User(
                  uid: widget.user.uid,
                  fullname: widget.user.fullname,
                  email: widget.user.email,
                  gender: widget.user.gender,
                  address: widget.user.address,
                  emNumber: widget.user.emNumber,
                )))),
          )
        ],
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          //header
          new UserAccountsDrawerHeader(
            accountName: Text(widget.user.fullname),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: new BoxDecoration(
              color: Colors.pink.shade500,
            ),
          ),

          //Body
          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('Home'),
              leading: Icon(
                Icons.home,
                color: Colors.deepPurple,
              ),
            ),
          ),

          InkWell(
            onTap: ()=> Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new Profile(
                  user: User(
                  uid: widget.user.uid,
                  fullname: widget.user.fullname,
                  email: widget.user.email,
                  gender: widget.user.gender,
                  address: widget.user.address,
                  emNumber: widget.user.emNumber,
                )))),
            child: ListTile(
              title: Text('My Account'),
              leading: Icon(
                Icons.person,
                color: Colors.deepPurple,
              ),
            ),
          ),

          InkWell(
            onTap: ()=> Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ContactsPage(user: User(
                  uid: widget.user.uid,
                  fullname: widget.user.fullname,
                  email: widget.user.email,
                  gender: widget.user.gender,
                  address: widget.user.address,
                  emNumber: widget.user.emNumber,
              )))),
            child: ListTile(
              title: Text('Contacts'),
              leading: Icon(
                Icons.people,
                color: Colors.deepPurple,
              ),
            ),
          ),

          InkWell(
            onTap: ()=> Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => MessagesPage(user: User(
                  uid: widget.user.uid,
                  fullname: widget.user.fullname,
                  email: widget.user.email,
                  gender: widget.user.gender,
                  address: widget.user.address,
                  emNumber: widget.user.emNumber,
              )))),
            child: ListTile(
              title: Text('Messages'),
              leading: Icon(
                Icons.message,
                color: Colors.deepPurple,
              ),
            ),
          ),

          InkWell(
            onTap:(){
              Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new HistoryPage(
                  user: User(
                  uid: widget.user.uid,
                  fullname: widget.user.fullname,
                  email: widget.user.email,
                  gender: widget.user.gender,
                  address: widget.user.address,
                  emNumber: widget.user.emNumber,
                ))));
            },
            child: ListTile(
              title: Text('History'),
              leading: Icon(
                Icons.history,
                color: Colors.deepPurple,
              ),
            ),
          ),

          Divider(),

          InkWell(
            onTap: (){
              _showDialog();
            },
            child: ListTile(
              title: Text('Config'),
              leading: Icon(
                Icons.settings,
                color: Colors.deepPurple,
              ),
            ),
          ),


          InkWell(
            onTap: (){_signOut();},
            child: ListTile(
              title: Text('Sign Out'),
              leading: Icon(
                Icons.power,
                color: Colors.deepPurple,
              ),
            ),
          ),
          
          
          
          AboutListTile(
            child: Text('About'),
            icon: Icon(
              Icons.info,
              color: Colors.deepPurple,
            ),
            applicationIcon: Icon(
              Icons.local_play,
              size: 65.0,
              color: Theme.of(context).accentColor,
            ),
            applicationName: 'Health Emergency',
            applicationVersion: '1.0.0',
            applicationLegalese: '2019 LASU',
            aboutBoxChildren: aboutBoxChildren,
          ),

        ],
      )),

      backgroundColor: Colors.pinkAccent.shade50,
      
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){
                callService();
              },
              child: new Image.asset(
                'Assets/images/emcall.png',
                height: 250.0,
                width: 200.0,
              ),
            ),

            new Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Text(
                    'Tap the icon to report your emergency now',
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
    
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }

    ).catchError((e) {
      print(e);
    });
  }


  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.locality},${place.country}";
      });
    } 
    catch (e) {
      print(e);
    }
  }

  //Message Service
  Future callService() async {
    
    _getCurrentLocation();
    String address = "https://maps.google.com/?q=${_currentPosition.latitude},${_currentPosition.longitude}";

    String _message = "Help me! I'm at $address\n${widget.user.address}\n${widget.user.email}\n${widget.user.fullname}";
    Firestore.instance
      .collection("users")
      .document(widget.user.email.toLowerCase())
      .collection("history")
      .add({
        "date": new DateTime.now().toString(),
        "address": address
      });
    
    Firestore.instance
      .collection("users")
      .document(widget.user.email.toLowerCase())
      .updateData({
        "find_me": address,
      });
    
    String msgUrl = "http://www.smslive247.com/http/index.aspx?cmd=sendquickmsg&owneremail=sms@posshop-ng.com&subacct=TEST&subacctpwd=Sms@Toyin&message=$_message&sender=EMERGENCY&sendto=${int.parse(widget.user.emNumber)}&msgtype=0";

    http.Response res = await http.get(
      Uri.encodeFull(msgUrl),
      headers: {
        "Accept": "Application/json"
      }
    );
    Fluttertoast.showToast(msg: "Emergency Reported!");
    debugPrint(json.decode(res.body));
  }

  //Log out
  void _signOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }


  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(23.0),
        content: Column(
          children: <Widget>[
            Text("You can change the emergency "),

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
              _contactPhoneController.clear();
              Navigator.pop(context);
            }),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if (_contactPhoneController.text.isNotEmpty) {
                Firestore.instance.collection("users").document(widget.user.email).updateData({
                  "emNumber": _contactPhoneController.text,
                })                
                .then((result) => {
                  Navigator.pop(context),
                  _contactPhoneController.clear(),
                })
                .catchError((err) => print(err));
                Fluttertoast.showToast(msg: "emergency contact changed");
            }
          })
        ],
      ),
    );
  }

}
