import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quran/quran.dart' as quran;
import '../../../core/models/reading_item.dart';

class ReaderController extends GetxController {
  var items = <ReadingItem>[].obs;
  var title = ''.obs;
  var showTranslation = true.obs;
  var selectedLanguage = 'ur'.obs; // Urdu from .txt
  var surahNumber = 0;

  final audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isDownloading = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var _audioFilePath = '';
  var index = 0.obs;

  var translationData = <String, String>{}; // 🔥

  final dio = Dio();

  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    title.value = arguments['title'] ?? '';
    surahNumber = arguments['surahNumber'] ?? 1;

    await _loadTranslations();
    await _loadSurahContent();

    audioPlayer.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p;
    });
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        position.value = Duration.zero;
        audioPlayer.stop();
        _audioFilePath = '';
      } else {
        isPlaying.value = state.playing;
      }
    });
  }

  void nextItem() {
    if (index.value < items.length - 1) index.value++;
  }

  void prevItem() {
    if (index.value > 0) index.value--;
  }

  Future<void> _loadTranslations() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/qur_jawadi.json');
    if (!await file.exists()) {
      final raw = await rootBundle.loadString('assets/qur.jawadi.txt');
      final lines = raw.split('\n');
      for (var line in lines) {
        final parts = line.split('|');
        if (parts.length >= 3) {
          translationData['${parts[0]}|${parts[1]}'] =
              parts.sublist(2).join('|').trim();
        }
      }
      await file.writeAsString(jsonEncode(translationData));
    } else {
      translationData = Map<String, String>.from(
        jsonDecode(await file.readAsString()),
      );
    }
    log('Translations Loaded ✅');
  }

  Future<void> _loadSurahContent() async {
    List<String> arabicList = [];
    List<String> translationList = [];

    final verseCount = quran.getVerseCount(surahNumber);
    for (int verse = 1; verse <= verseCount; verse++) {
      final arabic = quran.getVerse(surahNumber, verse, verseEndSymbol: true);
      final translation = translationData['$surahNumber|$verse'] ?? '';
      arabicList.add(arabic);
      translationList.add(translation);
    }

    items.value = [
      ReadingItem(
        title: quran.getSurahName(surahNumber),
        arabic: arabicList,
        translation: translationList,
        audioPath: quran.getAudioURLBySurah(surahNumber),
      ),
    ];

    log('Surah $surahNumber Loaded with ${items[0].arabic.length} verses ✅');
  }

  Future<void> downloadAndPlayAudio() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
      return;
    }

    final path = await _getAudioPath();
    final file = File(path);

    if (await file.exists()) {
      log('Playing local audio');
      await _play(path);
    } else {
      log('Downloading audio...');
      await _download(path);
      await _play(path);
    }
  }

  Future<String> _getAudioPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/surah_$surahNumber.mp3';
  }

  Future<void> _download(String path) async {
    isDownloading.value = true;
    try {
      final url = quran.getAudioURLBySurah(surahNumber);
      await dio.download(url, path);
      log('Audio Download Completed ✅');
    } catch (e) {
      log('Error downloading audio: $e');
      Get.snackbar('Error', 'Audio download failed');
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> _play(String path) async {
    if (_audioFilePath != path) {
      await audioPlayer.setFilePath(path);
      _audioFilePath = path;
    }
    await audioPlayer.play();
    isPlaying.value = true;
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
  }

  Future<void> seekForward() async {
    final newPosition = position.value + const Duration(seconds: 10);
    if (newPosition < duration.value) {
      await audioPlayer.seek(newPosition);
    }
  }

  Future<void> seekBackward() async {
    final newPosition = position.value - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      await audioPlayer.seek(newPosition);
    } else {
      await audioPlayer.seek(Duration.zero);
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    dio.close();
    super.onClose();
  }
}
