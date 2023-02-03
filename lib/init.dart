import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class InitServices {
   void init() {
    WidgetsFlutterBinding.ensureInitialized();
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerPeriodicTask(
      "periodic-task-identifier",
      "simplePeriodicTask",
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 5),
      initialDelay: const Duration(seconds: 10),
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      frequency: const Duration(seconds: 10),
    );
  }

  @pragma('vm:entry-point')
  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      int? totalExecutions;
      final sharedPreference =
          await SharedPreferences.getInstance(); //Initialize dependency

      try {
        //add code execution
        debugPrint("ExecutingTask");
        totalExecutions = sharedPreference.getInt("totalExecutions");
        sharedPreference.setInt("totalExecutions",
            totalExecutions == null ? 1 : totalExecutions + 1);
      } catch (err) {
        Logger().e(err
            .toString()); // Logger flutter package, prints error on the debug console
        throw Exception(err);
      }

      return Future.value(true);
    });
  }
}
