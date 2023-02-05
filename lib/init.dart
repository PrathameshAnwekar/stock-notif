import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';

import 'package:stock_notif/logger.dart';
import 'package:stock_notif/notification_handler.dart';

int helloAlarmID = 0;
@pragma('vm:entry-point')
void printHello() async {
  // while (true) {
  await Future.delayed(Duration(seconds: 0), () {
    NotificationHandler.startListening();
  });
  // }
}

class InitServices {
  void init() async {
    ilog("InitServices.init() called");
    WidgetsFlutterBinding.ensureInitialized();
    await AndroidAlarmManager.initialize();

    await AndroidAlarmManager.oneShot(
        const Duration(seconds: 0), helloAlarmID, printHello,
        wakeup: true, rescheduleOnReboot: true);
  }
}
