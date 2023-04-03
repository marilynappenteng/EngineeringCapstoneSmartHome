import 'package:flutter/material.dart';
import 'package:smart_home_capstone_app/pages/loading.dart';
import 'package:smart_home_capstone_app/pages/login.dart';
import 'package:smart_home_capstone_app/pages/home.dart';
import 'package:smart_home_capstone_app/pages/settings.dart';
import 'package:smart_home_capstone_app/pages/controls.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/login': (context) => Login(),
      '/home': (context) => Home(),
      '/settings':(context) => Settings(),
      '/controls':(context) => Controls(),
    },
  ));
}
