import 'package:get/get.dart';
import 'package:peeker/pages/create_item/create_item_controller.dart';
import 'package:peeker/pages/top/top_page_controller.dart';

class CreateItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateItemPageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
