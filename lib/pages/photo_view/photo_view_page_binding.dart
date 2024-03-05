import 'package:get/get.dart';
import 'package:idz/pages/top/top_page_controller.dart';

class PhotoViewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
