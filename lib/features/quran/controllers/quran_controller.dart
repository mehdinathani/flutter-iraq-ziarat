import 'package:get/get.dart';
import 'package:iraqziarat/core/controllers/audio_player_controller.dart';
import 'package:iraqziarat/core/models/reading_item.dart';
import 'package:iraqziarat/core/services/translation_service.dart';
import 'package:quran/quran.dart' as quran;

class QuranController extends GetxController {
  final items = <ReadingItem>[].obs;
  RxInt index = 0.obs;
  final audio = Get.put(AudioPlayerController());
  var showTranslation = false.obs; // <-- ✨ added this!

  ReadingItem get current => items[index.value];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void toggleTranslation(bool value) {
    showTranslation.value = value;
    items.clear();
    _load();
  }

  Future<void> _load() async {
    final trans = await TranslationService.load();
    for (var s = 1; s <= 114; s++) {
      final name = quran.getSurahName(s);
      final count = quran.getVerseCount(s);
      final audioUrl = quran.getAudioURLBySurah(s);

      final content = <String>[];
      for (var v = 1; v <= count; v++) {
        final text = quran.getVerse(s, v);
        final tr = trans['$s|$v'] ?? '';
        if (showTranslation.value) {
          content.add('$v. $text\n\nTranslation: $tr');
        } else {
          content.add('$v. $text');
        }
      }

      items.add(
        ReadingItem(
          title: '$s. $name',
          content: content.join("\n\n"),
          audioPath: audioUrl,
        ),
      );
    }
  }

  void next() {
    if (index < items.length - 1) {
      index++;
      audio.stop();
    }
  }

  void prev() {
    if (index > 0) {
      index--;
      audio.stop();
    }
  }
}
