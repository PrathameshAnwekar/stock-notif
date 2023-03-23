import 'package:path_provider/path_provider.dart';

import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hiveP = StateProvider((ref) => null);

class HiveStore {
  static final storage = Hive.box("defaultStorage");

  static init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    await Hive.openBox("defaultStorage");
  }
}
