import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stock_notif/logger.dart';

class NotificationHandler {
  void init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    dlog("NotificationHandler.init() called");
    final List<ActiveNotification>? activeNotifications =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications();

    // debugPrint("xyz ActiveNotifications: ${activeNotifications![0].title}!");
    activeNotifications!.forEach((element) {
      dlog("ActiveNotifications: ${element.body}!");
    });
  }
}
