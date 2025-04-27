import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as quran;
import 'package:dio/dio.dart';

class ReaderController extends GetxController {
  var content = <Map<String, String>>[].obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var isPlaying = false.obs;
  var isDownloading = false.obs;
  late final int surahNumber;
  late final String surahAudioUrl;
  final audioPlayer = AudioPlayer();
  final dio = Dio();
  String _filePath = '';

  @override
  void onInit() async {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    surahNumber = args['surahNumber'];
    surahAudioUrl = quran.getAudioURLBySurah(surahNumber);
    _loadContent();

    audioPlayer.durationStream.listen(
      (d) => duration.value = d ?? Duration.zero,
    );
    audioPlayer.positionStream.listen((p) => position.value = p);
    audioPlayer.playerStateStream.listen((s) {
      isPlaying.value = s.playing;
      if (s.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        position.value = Duration.zero;
        _filePath = '';
      }
    });
  }

  void _loadContent() {
    final count = quran.getVerseCount(surahNumber);
    for (var v = 1; v <= count; v++) {
      content.add({
        'arabic': quran.getVerse(surahNumber, v, verseEndSymbol: true),
        'translation': quran.getVerseTranslation(surahNumber, v),
      });
    }
  }

  Future<String> _localPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '\${dir.path}/surah_\$surahNumber.mp3';
  }

  Future<void> downloadAndPlayAudio() async {
    if (isDownloading.value) return;
    isDownloading.value = true;
    final path = await _localPath();
    final file = File(path);
    if (!await file.exists()) {
      await dio.download(surahAudioUrl, path);
    }
    await audioPlayer.setFilePath(path);
    await audioPlayer.play();
    isDownloading.value = false;
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    dio.close();
    super.onClose();
  }
}
