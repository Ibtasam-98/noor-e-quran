
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import 'app_theme_switch_controller.dart';

class ProphetMiracleDetailController extends GetxController {
  final String prophetName;
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool _isPlaying = false.obs;
  final Rx<Duration> _duration = Duration.zero.obs;
  final Rx<Duration> _position = Duration.zero.obs;

  ProphetMiracleDetailController({required this.prophetName});

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying.value = state == PlayerState.playing;
    });
    _audioPlayer.onDurationChanged.listen((d) => _duration.value = d);
    _audioPlayer.onPositionChanged.listen((p) => _position.value = p);
    _audioPlayer.onPlayerComplete.listen((_) {
      _position.value = Duration.zero;
      _isPlaying.value = false;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> playPauseAudio(String audioUrl) async {
    if (_isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  Future<void> seekAudio(double value) async {
    await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }

  RxBool get isPlaying => _isPlaying;
  Rx<Duration> get duration => _duration;
  Rx<Duration> get position => _position;
}