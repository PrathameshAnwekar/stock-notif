import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:stock_notif/services/audioService.dart';
import 'package:stock_notif/services/logger.dart';
import 'package:stock_notif/storage/constants.dart';
import 'package:stock_notif/storage/hiveStore.dart';

class NotificationService {
  static bool permissionGranted = false;
  static bool serviceRunning = false;
  static StreamSubscription<ServiceNotificationEvent>? _subscription;

  static init() async {
    permissionGranted = await isPermissionGranted();
    serviceRunning =
        HiveStore.storage.get(Constants.notificationServiceStatus) ?? false;
    dlog(
        "NotificationService.init() permissionGranted: $permissionGranted, serviceRunning: $serviceRunning");
  }

  static void onData(ServiceNotificationEvent event) async {
    dlog("Notification received: $event");
    if (await checkHotKeywords(event)) {
      AudioService.playSound();
    }
  }

  static void startListening() async {
    dlog("Starting to listen to notifications");
    await HiveStore.storage.put(Constants.notificationServiceStatus, true);
    _subscription =
        NotificationListenerService.notificationsStream.listen(onData);
  }

  static void stopListening() async {
    dlog("Stopping to listen to notifications");
    _subscription?.cancel();
    await HiveStore.storage.put(Constants.notificationServiceStatus, false);
  }

  static Future<bool> requestPermission() async {
    final res = await NotificationListenerService.requestPermission();
    dlog("Permissions given: $res");
    permissionGranted = res;
    return res;
  }

  static Future<bool> isPermissionGranted() async {
    final bool res = await NotificationListenerService.isPermissionGranted();
    dlog("Are permissions granted: $res");
    return res;
  }

  static Future<bool> checkHotKeywords(ServiceNotificationEvent notif) async {
    
    final List titleKeywords =
        HiveStore.storage.get(Constants.titleKeywords) ?? [];
    dlog(titleKeywords.toString());
    final List contentKeywords =
        HiveStore.storage.get(Constants.contentKeywords) ?? [];
    dlog(contentKeywords.toString());
    bool titleMatch = false;
    bool contentMatch = false;

    String title = notif.title == null ? "" : notif.title!.toLowerCase();
    String content = notif.content == null ? "" : notif.content!.toLowerCase();

    List titleWords = title.split(" ");
    List contentWords = content.split(" ");

    for (String word in titleWords) {
      if (titleKeywords.contains(word)) {
        titleMatch = true;
        dlog(word + "found");
        break;
      }
    }

    for (String word in contentWords) {
      if (contentKeywords.contains(word)) {
        contentMatch = true;
        dlog(word + "found");
        break;
      }
    }
    final res = (titleMatch || contentMatch) && !notif.hasRemoved!;
    return Future.value(res);
  }
}
