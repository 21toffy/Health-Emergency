import 'package:flutter/material.dart';
import 'package:emergency/pages/splash.dart';

void main() {
  runApp(MaterialApp(
    home: SplashPage(),
    theme: ThemeData(
      primaryColor: Colors.red.shade900,
      fontFamily: 'Nunito'
    ),
    debugShowCheckedModeBanner: false,
  ));
}