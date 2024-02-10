import 'package:get/get.dart';
import 'package:idz/pages/item_detail/item_detail_controller.dart';
import 'package:idz/pages/top/top_page_controller.dart';

class ItemDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ItemDetailPageController(),
      fenix: true,
    );
    Get.lazyPut(
      () => TopPageController(),
      fenix: true,
    );
  }
}
