import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../controllers/app_theme_switch_controller.dart';

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
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.processingState == ProcessingState.ready || state.processingState == ProcessingState.buffering;
    });
    _audioPlayer.durationStream.listen((d) => _duration.value = d ?? Duration.zero);
    _audioPlayer.positionStream.listen((p) => _position.value = p);
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _position.value = Duration.zero;
        _isPlaying.value = false;
      }
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
      try {
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();
      } catch (e) {
        print("Error loading or playing audio: $e");
        // Handle the error appropriately, e.g., show a snackbar
      }
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