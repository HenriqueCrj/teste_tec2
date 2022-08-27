import 'package:flame_audio/flame_audio.dart';

class MasterAudio {
  static Future initialize() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      "mixkit-arcade-space-shooter-dead-notification-272.wav",
      "mixkit-extra-bonus-in-a-video-game-2045.wav",
      "mixkit-video-game-retro-click-237.wav",
      "064594-korg-z1.mp3"
    ]);
  }

  static void goldPickup() {
    FlameAudio.play(
      "mixkit-video-game-retro-click-237.wav",
      volume: 0.3,
    );
  }

  static void shieldActivated() {
    FlameAudio.play(
      "064594-korg-z1.mp3",
      volume: 0.3,
    );
  }

  static void playerDeath() {
    FlameAudio.play(
      "mixkit-arcade-space-shooter-dead-notification-272.wav",
      volume: 0.3,
    );
  }

  static void powerPickup() {
    FlameAudio.play(
      "mixkit-extra-bonus-in-a-video-game-2045.wav",
      volume: 0.3,
    );
  }

  static void stopBackgroundSound() async {
    FlameAudio.bgm.stop();
  }

  // static void playBackgroundSound({double volume = 1}) {
  //   FlameAudio.bgm.play(
  //     "Monplaisir_-_03_-_Level_0.mp3",
  //     volume: volume,
  //   );
  // }

  // static void pauseBackgroundSound() {
  //   FlameAudio.bgm.pause();
  // }

  // static void resumeBackgroundSound() {
  //   FlameAudio.bgm.resume();
  // }

  // static bool isBgmPlaying() {
  //   return FlameAudio.bgm.isPlaying;
  // }

  static void dispose() {
    FlameAudio.bgm.dispose();
  }
}
