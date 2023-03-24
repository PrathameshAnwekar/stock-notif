import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

  static void startListening() async {
    dlog("Starting to listen to notifications");
    await HiveStore.storage.put(Constants.notificationServiceStatus, true);
    NotificationListenerService.notificationsStream.listen((event) {
      dlog("Notification received: $event");
      if (checkHotKeywords(event)) {
        AudioService.playSound();
      }
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
    permissionGranted = res;
    return res;
  }

  static Future<bool> isPermissionGranted() async {
    final bool res = await NotificationListenerService.isPermissionGranted();
    dlog("Are permissions granted: $res");
    return res;
  }

  static bool checkHotKeywords(ServiceNotificationEvent notif) {
    final List titleKeywords =
        HiveStore.storage.get(Constants.titleKeywords) ?? [];
    final List contentKeywords =
        HiveStore.storage.get(Constants.contentKeywords) ?? [];
    bool titleMatch = false;
    bool contentMatch = false;

    String title = notif.title == null ? "" : notif.title!.toLowerCase();
    String content = notif.content == null ? "" : notif.content!.toLowerCase();

    List titleWords = title.split(" ");
    List contentWords = content.split(" ");

    for (String word in titleWords) {
      if (titleKeywords.contains(word)) {
        titleMatch = true;
        break;
      }
    }

    for (String word in contentWords) {
      if (contentKeywords.contains(word)) {
        contentMatch = true;
        break;
      }
    }

    return (titleMatch || contentMatch) && !notif.hasRemoved!;
  }
}
