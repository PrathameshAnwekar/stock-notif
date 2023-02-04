import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:stock_notif/init.dart';
import 'package:stock_notif/logger.dart';

void main() {
  
  InitServices().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: LogConsoleOnShake(
        dark: true,
        child: GestureDetector(
          onTap: () {
            dlog("cancelling all notifs");
          },
          child:const Center(child: Text('Click to disable notifs')),
        ),
      )),
    );
  }
}
