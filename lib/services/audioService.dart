import 'package:audioplayers/audioplayers.dart';
import 'package:stock_notif/services/logger.dart';

class AudioService {
  static final _player = AudioPlayer();

  static void playSound() {
    _player.setVolume(1);
    dlog("Playing Sound");
    _player.play(
      AssetSource("sounds/long_beep.mp3"),
    );
  }
}
