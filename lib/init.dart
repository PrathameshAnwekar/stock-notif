import 'package:flutter/material.dart';

import 'package:stock_notif/logger.dart';
import 'package:stock_notif/notification_handler.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      dlog("ExecutingTask");
      NotificationHandler().init();
    } catch (err) {
      elog("WorkManagerException$err"); // Logger flutter package, prints error on the debug console
      // throw Exception(err);
    }

    return Future.value(true);
  });
}

class InitServices {
  void init() {
    ilog("InitServices.init() called");
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka _callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerOneOffTask(
        "oneoff-task-identifier", "simplePeriodicTask",
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: const Duration(seconds: 5),
        initialDelay: const Duration(seconds: 0),
        );
  }
}
