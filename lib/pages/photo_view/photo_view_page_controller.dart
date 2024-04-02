import 'package:get/get.dart';
import 'package:idz/pages/top/top_page_controller.dart';

class PhotoViewPageController extends GetxController {
  TopPageController topPageController = Get.find();
  @override
  void onReady() {
    topPageController.isVisibleBottomNav.value = false;
  }
}
