import 'package:audioplayers/audioplayers.dart';
import 'package:stock_notif/services/logger.dart';

class AudioService {
  static final _player = AudioPlayer();
  static const AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: [],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.gain,
    ),
  );
  static void playSound() {
    _player.setVolume(0.5);
    dlog("Playing Sound");
    _player.play(AssetSource("sounds/short_beep.mp3"),
        mode: PlayerMode.mediaPlayer);
  }
}

// class NAudioService {
//   static final _player = AssetsAudioPlayer();

//   static void playSound() {
//     dlog("Playing Sound");
//     _player.open(
//       Audio("assets/sounds/short_beep.mp3"), showNotification: true, respectSilentMode: false,
//     );
//   }
// }
