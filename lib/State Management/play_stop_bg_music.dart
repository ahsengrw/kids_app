

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

class AudioModel extends ChangeNotifier {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playAudio() async {
    if (!_isPlaying) {
      await
       _assetsAudioPlayer.open(Audio('assets/bg.mp3'));
      _assetsAudioPlayer.setVolume(0.3);
      _assetsAudioPlayer.play();

      _assetsAudioPlayer.loopMode;
      _isPlaying = true;
      notifyListeners();
    }
  }

  void stopAudio() {
    if (_isPlaying) {
      _assetsAudioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    }
  }

  void toggleAudio() {
    if (_isPlaying) {
      stopAudio();
    } else {
      playAudio();
    }
  }
}
