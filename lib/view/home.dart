import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stock_notif/controllers/home_controller.dart';
import 'package:stock_notif/logger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    final home = ref.watch(homeProvider);
    final serviceStatusIcon = ref.watch(homeProvider).serviceStatusIcon;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaton to Alarm"),
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: Column(
        children: [
          Container(
            child: DropdownButton(
              value: home.soundList[index.value],
              items: home.soundList
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                index.value = home.soundList.indexOf(value.toString());
                dlog("value: $value");
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Tooltip(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        message: "Tap to disable the app",
        child: FloatingActionButton(
          elevation: 4,
          onPressed: () => home.switchServiceStatus(),
          child: serviceStatusIcon,
        ),
      ),
    );
  }
}
