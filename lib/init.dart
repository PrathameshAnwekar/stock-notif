import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:stock_notif/controllers/home_controller.dart';
import 'package:stock_notif/hiveStore.dart';

import 'package:stock_notif/logger.dart';
import 'package:stock_notif/services/notificationService.dart';

int helloAlarmID = 0;

class InitServices {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    ilog("InitServices.init() called");
    await HiveStore.init();
    await AndroidAlarmManager.initialize();
  }
}
