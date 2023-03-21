// import 'dart:isolate';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
// import 'package:stock_notif/logger.dart';


// class NotificationsLog extends StatefulWidget {
//   const NotificationsLog({super.key});

//   @override
//   _NotificationsLogState createState() => _NotificationsLogState();
// }

// class _NotificationsLogState extends State<NotificationsLog> {
//   List<NotificationEvent> _log = [];
//   bool started = false;
//   bool _loading = false;

//   ReceivePort port = ReceivePort();

//   @override
//   void initState() {
//     initPlatformState();
//     super.initState();
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Listener Example ${_log.length}'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 dlog("TODO:");
//               },
//               icon: Icon(Icons.settings))
//         ],
//       ),
//       body: Center(
//           child: ListView.builder(
//               itemCount: _log.length,
//               reverse: true,
//               itemBuilder: (BuildContext context, int idx) {
//                 final entry = _log[idx];
//                 return ListTile(
//                     onTap: () {
//                       entry.tap();
//                     },
          
//                     title: Container(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(entry.title ?? "<<no title>>"),
//                           Text(entry.text ?? "<<no text>>"),
//                           Row(
//                             children: entry.actions!.map((act) {
//                               return TextButton(
//                                   onPressed: () {
//                                     // semantic is 1 means reply quick
//                                     if (act.semantic == 1) {
//                                       Map<String, dynamic> map = {};
//                                       act.inputs!.forEach((e) {
//                                         dlog(
//                                             "set inputs: ${e.label}<${e.resultKey}>");
//                                         map[e.resultKey!] = "Auto reply from me";
//                                       });
//                                       act.postInputs(map);
//                                     } else {
//                                       // just tap
//                                       act.tap();
//                                     }
//                                   },
//                                   child: Text(act.title!));
//                             }).toList()
//                               ..add(TextButton(
//                                   child: Text("Full"),
//                                   onPressed: () async {
//                                     try {
//                                       var data = await entry.getFull();
//                                       dlog("full notifaction: $data");
//                                     } catch (e) {
//                                       dlog(e.toString());
//                                     }
//                                   })),
//                           ),
//                           Text(entry.createAt.toString().substring(0, 19)),
//                         ],
//                       ),
//                     ));
//               })),
//       floatingActionButton: FloatingActionButton(
//         onPressed: started ? stopListening : startListening,
//         tooltip: 'Start/Stop sensing',
//         child: _loading
//             ? Icon(Icons.close)
//             : (started ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
//       ),
//     );
//   }
// }