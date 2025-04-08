import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  final String title;
  final String latinName;
  final String audioUrl;
  final double titleFontSize;

  AudioPlayerController({
    required this.title,
    required this.latinName,
    required this.audioUrl,
    required this.titleFontSize,
  });

  final AudioPlayer audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var currentPosition = 0.0.obs;
  var totalDuration = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupAudioPlayer();
  }

  void setupAudioPlayer() {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration.value = duration.inMilliseconds.toDouble();
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      currentPosition.value = position.inMilliseconds.toDouble();
    });

    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      currentPosition.value = 0.0; // Reset position when complete
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void toggleAudio() async {
    isLoading.value = true;
    try {
      if (isPlaying.value) {
        await audioPlayer.pause();
        isLoading.value = false;
      } else {
        if (audioUrl.startsWith('http') || audioUrl.startsWith('https')) {
          await audioPlayer.play(UrlSource(audioUrl));
        } else {
          await audioPlayer.play(AssetSource(audioUrl));
        }
        isLoading.value = false;
      }
      isPlaying.value = !isPlaying.value;
    } catch (e) {
      isLoading.value = false;
      print("Error playing audio: $e");
    }
  }

  String formatDuration(double duration) {
    int minutes = (duration / 1000 / 60).floor();
    int seconds = ((duration / 1000) % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}