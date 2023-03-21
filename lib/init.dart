
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:stock_notif/hiveStore.dart';

import 'package:stock_notif/logger.dart';


class InitServices {
  init() async {
     
    WidgetsFlutterBinding.ensureInitialized();
    dlog("InitServices.init() called");
    // Ear.register();
    await HiveStore.init();
    await AndroidAlarmManager.initialize();
  }
}
