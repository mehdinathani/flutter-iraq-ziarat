import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DataInitializer {
  static const _initializedKey = 'data_initialized';

  static Future<void> runOnce() async {
    final box = GetStorage();
    if (box.read(_initializedKey) ?? false) return;

    // Updated filename
    final raw = await rootBundle.loadString('assets/qur.jawadi.txt');
    final map = <String, String>{};
    for (var line in raw.split('\n')) {
      final parts = line.split('|');
      if (parts.length >= 3) {
        map['${parts[0]}|${parts[1]}'] = parts.sublist(2).join('|').trim();
      }
    }

    // Save with correct output name
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/qur_jawadi.json',
    ); // saving as qur_jawadi.json
    await file.writeAsString(jsonEncode(map));

    box.write(_initializedKey, true);
  }
}
