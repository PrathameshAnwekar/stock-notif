import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:stock_notif/logger.dart';
import 'package:stock_notif/services/notificationService.dart';

@pragma('vm:entry-point')
void mainService() async {
  await Future.delayed(Duration(seconds: 0), () {
    NotificationService.startListening();
  });
}

class AlarmService {
  static int alarmID = 0;

  static startService() async {
    try {
      await AndroidAlarmManager.oneShot(
              const Duration(seconds: 0), alarmID, mainService,
              wakeup: true, rescheduleOnReboot: true)
          .then((value) {
        dlog("Started AlarmManager Service");
      });
    } catch (e) {
      elog(e.toString());
    }
  }

  static stopService() {
    dlog("Stopped AlarmManager Service");
    NotificationService.stopListening();
    AndroidAlarmManager.cancel(alarmID);
    
  }
}
