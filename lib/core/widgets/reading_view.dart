import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingView<T> extends StatelessWidget {
  final List<T> items;
  final RxInt index;
  final Future<void> Function()? onPlay;
  final void Function()? onNext;
  final void Function()? onPrev;

  const ReadingView({
    super.key,
    required this.items,
    required this.index,
    this.onPlay,
    this.onNext,
    this.onPrev,
    required RxBool showTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (items.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      final item = items[index.value] as dynamic;
      return Column(
        children: [
          Text(item.title, style: TextStyle(fontSize: 24)),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(item.content),
            ),
          ),
          if (onPlay != null)
            IconButton(icon: Icon(Icons.play_arrow), onPressed: onPlay),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: onPrev),
              IconButton(icon: Icon(Icons.arrow_forward), onPressed: onNext),
            ],
          ),
        ],
      );
    });
  }
}
