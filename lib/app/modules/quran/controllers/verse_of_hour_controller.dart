
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

class VerseOfHourController extends GetxController {

  late AudioPlayer audioPlayer;
  RxBool isPlaying = false.obs;
  String? audioUrl;
  RxDouble progress = 0.0.obs;
  Duration? audioDuration;
  Rx<Duration> currentPosition = Duration.zero.obs;
  RxDouble currentFontSize = 24.0.obs;

  final int surahNumber;
  final int verseNumber;

  VerseOfHourController({required this.surahNumber, required this.verseNumber});

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    fetchAudio();
    audioPlayer.onDurationChanged.listen((Duration d) {
      audioDuration = d;
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      currentPosition.value = p;
      if (audioDuration != null) {
        progress.value = p.inMilliseconds / audioDuration!.inMilliseconds;
      }
    });

    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false; // Stops animation and updates icon
      currentPosition.value = Duration.zero;
      progress.value = 0.0;
    });

  }


  Future<void> fetchAudio() async {
    try {
      audioUrl = await quran.getAudioURLByVerse(surahNumber, verseNumber);
      update();
    } catch (e) {
      print("Error fetching audio URL: $e");
    }
  }

  void togglePlayPause() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      if (audioUrl != null) {
        try {
          await audioPlayer.play(UrlSource(audioUrl!));
        } catch (e) {
          print("Error playing audio: $e");
        }
      }
    }
    isPlaying.value = !isPlaying.value;
  }

  void seekAudio(double value) async {
    if (audioDuration != null) {
      await audioPlayer.seek(
        Duration(milliseconds: (audioDuration!.inMilliseconds * value).toInt()),
      );
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void updateFontSize(double value) {
    currentFontSize.value = value;
  }
}
