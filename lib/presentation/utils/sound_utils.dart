import 'package:just_audio/just_audio.dart';

abstract class SoundUtils {
  static final _player = AudioPlayer();

  static Future<void> play(String soundName) async {
    try {
      await _player
        .setAsset('assets/sounds/$soundName');
      await _player.play();
    } catch (e) {
      print(e);
      print('');
    }
  }
}
