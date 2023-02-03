import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:stock_notif/init.dart';
import 'package:stock_notif/logger.dart';
import 'package:workmanager/workmanager.dart';

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
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: LogConsoleOnShake(
        dark: true,
        child: GestureDetector(
          onTap: () {
            dlog("cancelling all notifs");
            Workmanager().cancelAll();
          },
          child:const Center(child: Text('Click to disable notifs')),
        ),
      )),
    );
  }
}
