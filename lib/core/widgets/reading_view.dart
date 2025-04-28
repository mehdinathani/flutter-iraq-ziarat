import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reading_item.dart';

class ReadingView<T> extends StatelessWidget {
  final List<T> items;
  final RxInt index;
  final Future<void> Function()? onPlay;
  final void Function()? onNext;
  final void Function()? onPrev;
  final RxBool? showTranslation;

  const ReadingView({
    super.key,
    required this.items,
    required this.index,
    this.onPlay,
    this.onNext,
    this.onPrev,
    this.showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final item = items[index.value] as ReadingItem;

      return Column(
        children: [
          Text(item.title, style: const TextStyle(fontSize: 24)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(item.arabic.length, (i) {
                  return Column(
                    children: [
                      Text(
                        item.arabic[i],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (showTranslation?.value ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Text(
                            item.translation[i],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const Divider(),
                    ],
                  );
                }),
              ),
            ),
          ),
          if (onPlay != null)
            IconButton(icon: const Icon(Icons.play_arrow), onPressed: onPlay),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: onPrev),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: onNext,
              ),
            ],
          ),
        ],
      );
    });
  }
}
