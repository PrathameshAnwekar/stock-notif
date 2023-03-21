import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:stock_notif/logger.dart';

class NotificationService {
  static final port = ReceivePort();
  static final notifLogger = [];
  static void _callback(NotificationEvent evt) {
    dlog("send evt to ui: $evt");
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
    if (send == null) dlog("can't find the sender");
    send?.send(evt);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initPlatformState(ValueNotifier started) async {
    NotificationsListener.initialize(callbackHandle: _callback);

    // this can fix restart<debug> can't handle error
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
    port.listen((message) => onData(message));

    // don't use the default receivePort
    // NotificationsListener.receivePort.listen((evt) => onData(evt));

    var isR = await NotificationsListener.isRunning;
    dlog(
        """Notification Listener Service is ${!isR! ? "not " : ""}already running""");

    started.value = isR;
  }

  static void onData(NotificationEvent event) {
    notifLogger.add(event);

    dlog(event.toString());
  }

 static void startListening(ValueNotifier started, ValueNotifier loading) async {
    dlog("start listening");

    loading.value = true;

    var hasPermission = await NotificationsListener.hasPermission;
    if (!hasPermission!) {
      dlog("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!isR!) {
      await NotificationsListener.startService(
          foreground: false,
          title: "Listener Running",
          description: "Welcome to having me");
    }

    started.value = true;
    loading.value = false;
  }

  static void stopListening(ValueNotifier started, ValueNotifier loading) async {
    dlog("stop listening");

    loading.value = true;

    await NotificationsListener.stopService();

    started.value = false;
    loading.value = false;
  }
}
