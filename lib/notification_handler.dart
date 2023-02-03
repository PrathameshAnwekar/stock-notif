import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';

class NotificationHandler {
  Notifications _notifications = Notifications();
  StreamSubscription<NotificationEvent>? _subscription;

  void startListening() {
    _notifications = new Notifications();
    try {
      _subscription = _notifications.notificationStream!.listen(onData);
    } on NotificationException catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void onData(NotificationEvent event) {
    debugPrint(event.toString());
  }

  

  void stopListening() {
    _subscription?.cancel();
  }
}
