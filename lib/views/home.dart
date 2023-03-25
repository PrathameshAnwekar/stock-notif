import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stock_notif/services/alarmService.dart';
import 'package:stock_notif/services/logger.dart';
import 'package:stock_notif/services/notificationService.dart';
import 'package:stock_notif/storage/constants.dart';
import 'package:stock_notif/storage/hiveStore.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final permissionGranted = useState(NotificationService.permissionGranted);
    final serviceStatus = useState(NotificationService.serviceRunning);
    final ValueNotifier<List> titleKeywords =
        useState(HiveStore.storage.get(Constants.titleKeywords) ?? []);
    final ValueNotifier<List> contentKeywords =
        useState(HiveStore.storage.get(Constants.contentKeywords) ?? []);
    final titleController = useTextEditingController();
    final contentController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure"),
      ),
      body: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
            onTap: () {
              if (!permissionGranted.value) {
                NotificationService.requestPermission().then((value) {
                  permissionGranted.value = value;
                });
              }
            },
            child: Chip(
              label: Text(permissionGranted.value
                  ? "Permission Granted"
                  : "Permission not granted"),
              backgroundColor:
                  permissionGranted.value ? Colors.green : Colors.red,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!serviceStatus.value) {
                
                AlarmService.startService().then((value) {
                  serviceStatus.value = value;
                });
              } else {
                AlarmService.stopService();
                serviceStatus.value = false;
              }
            },
            child: Chip(
              label: Text(serviceStatus.value
                  ? "Service Running"
                  : "Service not running"),
              backgroundColor: serviceStatus.value ? Colors.green : Colors.red,
            ),
          )
        ]),
        const Text("Hot keywords"),
        const Text(
            "A high priority sound will be played if any of these keywords are found in a notification"),
        //clear title keywords
        TextButton(
          onPressed: () {
            titleKeywords.value = [];
            HiveStore.storage.put(Constants.titleKeywords, []);
          },
          child: const Text("Clear title keywords"),
        ),
        //clear content keywords
        TextButton(
          onPressed: () {
            contentKeywords.value = [];
            HiveStore.storage.put(Constants.contentKeywords, []);
          },
          child: const Text("Clear content keywords"),
        ),

        Expanded(
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title keywords",
            ),
            onSubmitted: (value) {
              if (value.trim().isEmpty) return;
              titleController.clear();
              titleKeywords.value.add(value);
              HiveStore.storage
                  .put(Constants.titleKeywords, titleKeywords.value)
                  .then((value) async {
                setState(() {});
              });
            },
          ),
        ),
        Wrap(
          children: titleKeywords.value
              .map((e) => GestureDetector(
                  onTap: () {
                    titleKeywords.value.remove(e);
                    HiveStore.storage
                        .put(Constants.titleKeywords, titleKeywords.value);
                  },
                  child: Chip(label: Text(e))))
              .toList(),
        ),
        Expanded(
          child: TextField(
            controller: contentController,
            decoration: const InputDecoration(
              hintText: "Content keywords",
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              if (value.trim().isEmpty) return;
              contentController.clear();
              contentKeywords.value.add(value);
              HiveStore.storage
                  .put(Constants.contentKeywords, contentKeywords.value)
                  .then((value) async {
                setState(() {});
              });
            },
          ),
        ),
        Wrap(
          children: contentKeywords.value
              .map((e) => GestureDetector(
                  onTap: () {
                    contentKeywords.value.remove(e);
                    HiveStore.storage
                        .put(Constants.contentKeywords, contentKeywords.value)
                        .then((value) {
                      setState(() {
                        contentController.clear();
                      });
                    });
                  },
                  child: Chip(label: Text(e))))
              .toList(),
        ),
      ]),
    );
  }
}
