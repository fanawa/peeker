import 'package:get/get.dart';
import 'package:peeker/pages/top/top_page_controller.dart';
import 'package:peeker/service/manage_tab_service.dart';

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
