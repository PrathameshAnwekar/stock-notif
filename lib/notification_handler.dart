import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:stock_notif/logger.dart';

class NotificationHandler {
  static Notifications? _notifications;
  static StreamSubscription<NotificationEvent>? _subscription;
  static void onData(NotificationEvent event) {
    dlog(event.packageName.toString() + event.title.toString() +  event.message!);
  }

  static void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
    } on NotificationException catch (exception) {
      elog(exception.message);
    }
  }
  void stopListening() {
    _subscription?.cancel();
  }
}
