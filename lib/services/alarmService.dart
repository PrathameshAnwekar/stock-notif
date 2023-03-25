import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:stock_notif/services/logger.dart';
import 'package:stock_notif/services/notificationService.dart';
import 'package:stock_notif/storage/constants.dart';
import 'package:stock_notif/storage/hiveStore.dart';

@pragma('vm:entry-point')
void mainService() async {
  await Future.delayed(const Duration(seconds: 0), () async {
    dlog(
        "Started Service for listening to notifications in the background now.");
    await HiveStore.init();
    NotificationService.startListening();
  });
}

class AlarmService {
  static int alarmID = 0;
  static bool serviceStatus = false;
  static Future<bool> startService() async {
    try {
      await AndroidAlarmManager.oneShot(
              const Duration(seconds: 0), alarmID, mainService,
              wakeup: true, rescheduleOnReboot: true)
          .then((value) {
        HiveStore.storage.put(Constants.notificationServiceStatus, true);
        serviceStatus = true;
        dlog("Started AlarmManager Service");
        
      });
      return Future.value(true);
    } catch (e) {
      elog(e.toString());
      return Future.value(false);
    }
  }

  static stopService() {
    dlog("Stopped AlarmManager Service");
    NotificationService.stopListening();
    HiveStore.storage.put(Constants.notificationServiceStatus, false);
    AndroidAlarmManager.cancel(alarmID);
    serviceStatus = false;
  }
}
