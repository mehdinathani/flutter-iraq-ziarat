import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/reading_view.dart';
import 'reader_controller.dart';

class ReaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<ReaderController>();
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text('Surah ${c.surahNumber}'))),
      body: ReadingView<Map<String, String>>(
        items: c.content,
        index: RxInt(0),
        onPlay: c.downloadAndPlayAudio,
        onNext: () {},
        onPrev: () {},
        showTranslation: RxBool(false),
      ),
    );
  }
}
