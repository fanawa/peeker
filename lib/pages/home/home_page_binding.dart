import 'package:get/get.dart';
import 'package:peeker/pages/home/home_page_controller.dart';
import 'package:peeker/pages/top/top_page_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomePageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
