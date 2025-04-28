import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

class QuranController extends GetxController {
  var surahList = <Map<String, dynamic>>[].obs;
  var favorites = <int>[].obs; // 🧡 Favorite Surah Numbers
  final index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  void loadSurahs() {
    for (int i = 1; i <= 114; i++) {
      surahList.add({
        'number': i,
        'name': quran.getSurahName(i),
        'verses': quran.getVerseCount(i),
      });
    }
  }

  void toggleFavorite(int number) {
    if (favorites.contains(number)) {
      favorites.remove(number);
    } else {
      favorites.add(number);
    }
  }

  void openSurah(int surahNumber, String surahName) {
    Get.toNamed(
      '/reader',
      arguments: {
        'type': 'surah',
        'surahNumber': surahNumber,
        'title': surahName,
      },
    );
  }
}
