import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TranslationService {
  static Future<Map<String, String>> load() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/qur_jawadi.json',
    ); // <-- use qur_jawadi.json here
    if (!await file.exists()) return {};
    final jsonStr = await file.readAsString();
    return Map<String, String>.from(jsonDecode(jsonStr));
  }
}
