import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:stock_notif/init.dart';
import 'package:stock_notif/services/logger.dart';
import 'package:stock_notif/views/home.dart';
import 'package:stock_notif/views/newHome.dart';

void main() async {
  await InitServices().init();
  runApp(const ProviderScope(child: const MyApp()));
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
      debugShowCheckedModeBanner: false,
      title: 'Notif App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.black,
      ),
      home: Home()
    );
  }
}
