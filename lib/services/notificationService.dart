import 'dart:async';

import 'package:notifications/notifications.dart';
import 'package:stock_notif/logger.dart';
import 'package:stock_notif/services/audioService.dart';

class NotificationService {
  static Notifications? _notifications;
  static StreamSubscription<NotificationEvent>? _subscription;
  static void onData(NotificationEvent event) {
    try {
      dlog("\npackageName: ${event.packageName}\ntitle:${event.title}\nmessage:${event.message}");
      audioPlay(event);
    } catch (e) {
      elog(e.toString());
    }
  }

  static void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
      dlog("Started Notification Service");
    } on NotificationException catch (exception) {
      elog(exception.message);
    }
  }

  static void stopListening() {
    _subscription?.cancel();
    dlog("Stopped notification service");
  }

  static void audioPlay(NotificationEvent notif) {
    if (notif.title == "Text") {
      AudioService.playSound();
    }
  }
}
