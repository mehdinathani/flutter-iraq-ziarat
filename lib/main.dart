import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iraqziarat/features/quran/bindings/quran_binding.dart';
import 'data_initializer.dart';
import 'features/quran/views/quran_page.dart';
import 'features/reader/reader_binding.dart';
import 'features/reader/reader_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetStorage for persistent storage
  await GetStorage.init();
  // Run data initializer to load translations into local file (once)
  await DataInitializer.runOnce();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rehnuma e Safar',
      initialRoute: '/quran',
      getPages: [
        GetPage(
          name: '/quran',
          page: () => QuranPage(),
          binding: QuranBinding(),
        ),
        GetPage(
          name: '/reader',
          page: () => ReaderView(),
          binding: ReaderBinding(),
        ),
      ],
    );
  }
}
