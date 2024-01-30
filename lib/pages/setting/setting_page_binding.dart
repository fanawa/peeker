import 'package:get/get.dart';
import 'package:idz/pages/setting/setting_page_controller.dart';
import 'package:idz/pages/top/top_page_controller.dart';

class SettingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingPageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
