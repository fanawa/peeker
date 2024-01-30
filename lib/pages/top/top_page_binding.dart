import 'package:get/get.dart';
import 'package:idz/pages/top/top_page_controller.dart';
import 'package:idz/service/manage_tab_service.dart';

class TopPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => ManageTabService(),
      fenix: true,
    );
  }
}
