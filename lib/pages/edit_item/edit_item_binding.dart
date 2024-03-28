import 'package:get/get.dart';
import 'package:idz/pages/edit_item/edit_item_controller.dart';
import 'package:idz/pages/top/top_page_controller.dart';

class EditItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EditItemPageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
