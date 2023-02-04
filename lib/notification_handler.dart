import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stock_notif/logger.dart';

class NotificationHandler {

  static void check() async {
    dlog("NotificationHandler.check() called");
    
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.getActiveNotifications()
    //     .then((value) {
    //   for (var element in value) {
    //     dlog("ActiveNotifications: ${element.body}!");
    //   }
    //   dlog("Reached End of NotificationHandler.check() ${value.length}");
    // });

  }
}
