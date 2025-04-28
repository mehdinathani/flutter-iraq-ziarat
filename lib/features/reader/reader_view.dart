import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iraqziarat/core/models/reading_item.dart';
import '../../core/widgets/reading_view.dart';
import 'reader_controller.dart';

class ReaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<ReaderController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(c.title.value)),
        actions: [
          Obx(
            () => Row(
              children: [
                const Text('Translation', style: TextStyle(fontSize: 14)),
                Switch(
                  value: c.showTranslation.value,
                  onChanged: (value) {
                    c.showTranslation.value = value;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (c.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ReadingView<ReadingItem>(
              items: c.items,
              index: c.index,
              onPlay: c.downloadAndPlayAudio,
              onNext: c.nextItem,
              onPrev: c.prevItem,
              showTranslation: c.showTranslation,
            );
          }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              return Container(
                color: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatDuration(c.position.value),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0.0,
                            max: c.duration.value.inSeconds.toDouble(),
                            value:
                                c.position.value.inSeconds
                                    .clamp(
                                      0.0,
                                      c.duration.value.inSeconds.toDouble(),
                                    )
                                    .toDouble(),
                            onChanged: (value) {
                              c.audioPlayer.seek(
                                Duration(seconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                        Text(
                          _formatDuration(c.duration.value),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: c.seekBackward,
                        ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: c.stopAudio,
                        ),
                        c.isDownloading.value
                            ? const CircularProgressIndicator()
                            : IconButton(
                              icon: Icon(
                                c.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 32,
                              ),
                              onPressed: c.downloadAndPlayAudio,
                            ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: c.seekForward,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
