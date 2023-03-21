// import 'dart:isolate';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
// import 'package:stock_notif/logger.dart';

// class NotifService extends ChangeNotifier {
//   // static List<NotificationEvent> _log = [];
//   static ReceivePort port = ReceivePort();

//   static void _callback(NotificationEvent evt) {
//     dlog("send evt to ui: $evt");
//     final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
//     if (send == null) dlog("can't find the sender");
//     send?.send(evt);
//   }

//   static Future<void> initPlatformState() async {
//     NotificationsListener.initialize(callbackHandle: _callback);

//     // this can fix restart<debug> can't handle error
//     IsolateNameServer.removePortNameMapping("_listener_");
//     IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
//     port.listen((message) => onData(message));

//     // don't use the default receivePort
//     // NotificationsListener.receivePort.listen((evt) => onData(evt));
//     var isR = await NotificationsListener.isRunning;
//     dlog("""Service is ${!isR! ? "not " : ""}already running""");
//   }

//   static void onData(NotificationEvent event) {
//     dlog(event.toString());
//   }

//   static void startListening() async {
//     dlog("start listening");
//     var hasPermission = await NotificationsListener.hasPermission;
//     if (!hasPermission!) {
//       dlog("no permission, so open settings");
//       NotificationsListener.openPermissionSettings();
//       return;
//     }

//     var isR = await NotificationsListener.isRunning;

//     if (!isR!) {
//       await NotificationsListener.startService(
//           foreground: false,
//           title: "Listener Running",
//           description: "Welcome to having me");
//     }
//   }

//   static void stopListening() async {
//     dlog("stop listening");
//     await NotificationsListener.stopService();
//   }
// }
