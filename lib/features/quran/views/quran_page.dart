import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/reading_view.dart';
import '../controllers/quran_controller.dart';

class QuranPage extends StatelessWidget {
  final controller = Get.find<QuranController>();

  QuranPage({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quran')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                // ✨ Translation Toggle Button
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Show Translation',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: controller.showTranslation.value,
                          onChanged: controller.toggleTranslation,

                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReadingView(
                    items: controller.items,
                    index: controller.index,
                    onPlay:
                        () => controller.audio.downloadAndPlay(
                          controller.current.audioPath!,
                          'surah_${controller.index.value + 1}',
                        ),
                    onNext: controller.next,
                    onPrev: controller.prev,
                    showTranslation:
                        controller
                            .showTranslation, // pass this if you update ReadingView
                  ),
                ),
              ],
            ),
          ),
          // ✨ Audio Player Controls at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✨ Seekbar
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            _formatDuration(controller.audio.position.value),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0.0,
                            max:
                                controller.audio.duration.value.inSeconds
                                    .toDouble(),
                            value:
                                controller.audio.position.value.inSeconds
                                    .clamp(
                                      0.0,
                                      controller.audio.duration.value.inSeconds
                                          .toDouble(),
                                    )
                                    .toDouble(),
                            onChanged: (value) {
                              controller.audio.audioPlayer.seek(
                                Duration(seconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            _formatDuration(controller.audio.duration.value),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // ✨ Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10),
                          onPressed: controller.audio.seekBackward,
                        ),
                        IconButton(
                          icon: Icon(Icons.stop),
                          onPressed: controller.audio.stop,
                        ),
                        controller.audio.isDownloading.value
                            ? CircularProgressIndicator()
                            : IconButton(
                              icon: Icon(
                                controller.audio.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                              ),
                              onPressed:
                                  () => controller.audio.downloadAndPlay(
                                    controller.current.audioPath!,
                                    'surah_${controller.index.value + 1}',
                                  ),
                            ),
                        IconButton(
                          icon: Icon(Icons.forward_10),
                          onPressed: controller.audio.seekForward,
                        ),
                        // ✨ Repeat Button
                        IconButton(
                          icon: Obx(
                            () => Icon(
                              controller.audio.repeatMode.value
                                  ? Icons.repeat
                                  : Icons.repeat_one_outlined,
                              color:
                                  controller.audio.repeatMode.value
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            controller.audio.repeatMode.toggle();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
