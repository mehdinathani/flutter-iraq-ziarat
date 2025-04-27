import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerController extends GetxController {
  final audioPlayer = AudioPlayer();
  final dio = Dio();
  var isPlaying = false.obs;
  var isDownloading = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var _audioFilePath = '';
  var repeatMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAudioListeners();
  }

  void _initAudioListeners() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p;
    });
    audioPlayer.playerStateStream.listen((state) async {
      if (state.playing) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
      if (state.processingState == ProcessingState.completed) {
        log('Audio completed.');
        if (repeatMode.value) {
          log('Repeat mode is ON. Restarting...');
          await audioPlayer.seek(Duration.zero);
          await audioPlayer.play();
        } else {
          log('Repeat mode is OFF.');
          position.value = Duration.zero;
          duration.value = Duration.zero;
          _audioFilePath = '';
        }
      }
    });
  }

  Future<String> _getLocalFilePath(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$name.mp3';
  }

  Future<bool> _checkAudioExists(String name) async {
    final filePath = await _getLocalFilePath(name);
    final file = File(filePath);
    return file.exists();
  }

  Future<void> downloadAndPlay(String url, String localName) async {
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
      log('Paused audio.');
      return;
    }

    final filePath = await _getLocalFilePath(localName);
    final exists = await _checkAudioExists(localName);

    if (exists) {
      log('Playing audio from local: $filePath');
      await _playLocal(filePath);
    } else {
      log('Downloading audio...');
      await _download(url, filePath);
      log('Download complete. Playing...');
      await _playLocal(filePath);
    }
  }

  Future<void> _download(String url, String savePath) async {
    isDownloading.value = true;
    try {
      await dio.download(url, savePath);
      log('Downloaded to $savePath');
    } catch (e) {
      log('Download error: $e');
      Get.snackbar('Download Error', '$e');
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> _playLocal(String filePath) async {
    try {
      if (_audioFilePath != filePath) {
        await audioPlayer.setLoopMode(LoopMode.off);
        await audioPlayer.setFilePath(filePath);
        _audioFilePath = filePath;
        await audioPlayer.seek(Duration.zero);
      }
      await audioPlayer.play();
      log('Playing audio.');
    } catch (e) {
      log('Play error: $e');
      Get.snackbar('Play Error', '$e');
    }
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
    _audioFilePath = '';
    log('Stopped audio.');
  }

  Future<void> seekForward() async {
    final newPos = position.value + const Duration(seconds: 10);
    if (newPos < duration.value) {
      await audioPlayer.seek(newPos);
      log('Seeked forward 10s.');
    }
  }

  Future<void> seekBackward() async {
    final newPos = position.value - const Duration(seconds: 10);
    if (newPos > Duration.zero) {
      await audioPlayer.seek(newPos);
      log('Seeked backward 10s.');
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
