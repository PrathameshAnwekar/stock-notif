import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:stock_notif/init.dart';


void main() {
  InitServices().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const Scaffold(
          body:  LogConsoleOnShake(
            dark: true,
            child: Center(
                child: Text('Flutter Demo Home Page')),
          )),
    );
  }
}
