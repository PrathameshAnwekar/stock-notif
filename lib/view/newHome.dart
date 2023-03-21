import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stock_notif/logger.dart';
import 'package:stock_notif/services/finalNotifService.dart';
class NewHome extends HookConsumerWidget {
  const NewHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _log = useState(NotificationService.notifLogger);
    final started = useState(false);
    final loading = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Listener Example ${_log.value.length}'),
        actions: [
          IconButton(
              onPressed: () {
                dlog("TODO:");
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _log.value.length,
              reverse: true,
              itemBuilder: (BuildContext context, int idx) {
                final entry = _log.value[idx];
                return ListTile(
                    onTap: () {
                      entry.tap();
                    },
                    title: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title ?? "<<no title>>"),
                          Text(entry.text ?? "<<no text>>"),
                          Row(
                            children: entry.actions!.map((act) {
                              return TextButton(
                                  onPressed: () {
                                    // semantic is 1 means reply quick
                                    if (act.semantic == 1) {
                                      Map<String, dynamic> map = {};
                                      act.inputs!.forEach((e) {
                                        dlog(
                                            "set inputs: ${e.label}<${e.resultKey}>");
                                        map[e.resultKey!] =
                                            "Auto reply from me";
                                      });
                                      act.postInputs(map);
                                    } else {
                                      // just tap
                                      act.tap();
                                    }
                                  },
                                  child: Text(act.title!));
                            }).toList()
                              ..add(TextButton(
                                  child: Text("Full"),
                                  onPressed: () async {
                                    try {
                                      var data = await entry.getFull();
                                      dlog("full notifaction: $data");
                                    } catch (e) {
                                      dlog(e.toString());
                                    }
                                  })),
                          ),
                          Text(entry.createAt.toString().substring(0, 19)),
                        ],
                      ),
                    ));
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if( started.value){
            NotificationService.stopListening(started, loading);
          } else{
            NotificationService.startListening(started, loading);
          }
        
        },
        tooltip: 'Start/Stop sensing',
        child: loading.value
            ? Icon(Icons.close)
            : (started.value ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
      ),
    );
  }
}
