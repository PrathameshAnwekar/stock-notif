import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:stock_notif/services/alarmService.dart';
import 'package:stock_notif/services/notificationService.dart';
import 'package:stock_notif/storage/hiveStore.dart';

import 'package:stock_notif/services/logger.dart';

import 'storage/constants.dart';

class InitServices {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveStore.init();
    AlarmService.serviceStatus =
        HiveStore.storage.get(Constants.notificationServiceStatus) ?? false;
    await AndroidAlarmManager.initialize();
    await NotificationService.init();
  }
}
