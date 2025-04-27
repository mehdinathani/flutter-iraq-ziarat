import 'package:get/get.dart';
import 'reader_controller.dart';

class ReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(() => ReaderController());
  }
}
