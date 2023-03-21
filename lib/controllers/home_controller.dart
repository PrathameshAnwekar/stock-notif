import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stock_notif/hiveStore.dart';
import 'package:stock_notif/services/alarmService.dart';

final homeProvider = ChangeNotifierProvider((ref) => HomeController());

class HomeController extends ChangeNotifier {
  static bool alarmServiceStatus =
      HiveStore.storage.get("alarmServiceStatus", defaultValue: false);

  List soundList = ["SHORT_BEEP", "LONG_BEEP"];

  Icon serviceStatusIcon = alarmServiceStatus
      ? const Icon(Icons.stop_circle)
      : const Icon(Icons.done_rounded);

  void switchServiceStatus() {
    if (alarmServiceStatus) {
      AlarmService.stopService();
      alarmServiceStatus = !alarmServiceStatus;
      HiveStore.storage.put("alarmServiceStatus", false);
    } else {
      AlarmService.startService();
      alarmServiceStatus = !alarmServiceStatus;
      HiveStore.storage.put("alarmServiceStatus", true);
    }
    serviceStatusIcon = alarmServiceStatus
      ? const Icon(Icons.stop_circle)
      : const Icon(Icons.done_rounded);
    notifyListeners();
  }
}
