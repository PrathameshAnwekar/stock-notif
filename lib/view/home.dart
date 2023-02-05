import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:stock_notif/controllers/home_controller.dart';
import 'package:stock_notif/logger.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
        final serviceStatusIcon = ref.watch(homeProvider).serviceStatusIcon;

    return Scaffold(
        floatingActionButton: Tooltip(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          message: "Tap to disable the app",
          child: FloatingActionButton(
            elevation: 4,
            onPressed:() => home.switchServiceStatus(),
            child: serviceStatusIcon,
          ),
        ),
        appBar: AppBar(
          title: const Text("Notificaton to Alarm"),
          elevation: 4,
          shadowColor: Theme.of(context).shadowColor,
        ),
        body: LogConsoleOnShake(
          dark: true,
          child: Stack(
            children: [
              DropdownButton(
                  items: home.soundList
                      .map((e) => DropdownMenuItem(child: Text(e.toString())))
                      .toList(),
                  onChanged: null)
            ],
          ),
        ));
  }
}
