import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:stock_notif/services/logger.dart';
import 'package:stock_notif/storage/constants.dart';
import 'package:stock_notif/storage/hiveStore.dart';

class NotificationService {
  static bool permissionGranted = false;
  static bool serviceRunning = false;
  static StreamSubscription<ServiceNotificationEvent>? _subscription;
  

  static void init() {
    permissionGranted =
        HiveStore.storage.get(Constants.permissionGranted) ?? false;
    serviceRunning =
        HiveStore.storage.get(Constants.notificationServiceStatus) ?? false;
    dlog("NotificationService.init() permissionGranted: $permissionGranted, serviceRunning: $serviceRunning");
  }

  
  static void startListening() async {
    dlog("Starting to listen to notifications");
    await HiveStore.storage.put(Constants.notificationServiceStatus, true);
    NotificationListenerService.notificationsStream.listen((event) {
      dlog("Notification received: $event");
    });
  }

  static void stopListening() async {
    dlog("Stopping to listen to notifications");
    _subscription?.cancel();
    await HiveStore.storage.put(Constants.notificationServiceStatus, false);
  }

  static Future<bool> requestPermission() async {
    final res = await NotificationListenerService.requestPermission();
    dlog("Permissions given: $res");
    await HiveStore.storage.put(Constants.permissionGranted, res);
    return res;
  }

  static Future<bool> isPermissionGranted() async {
    final bool res = await NotificationListenerService.isPermissionGranted();
    dlog("Are permissions granted: $res");
    await HiveStore.storage.put(Constants.permissionGranted, res);
    return res;
  }
}
