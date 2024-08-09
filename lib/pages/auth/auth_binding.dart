import 'package:get/get.dart';
import 'package:idz/pages/auth/auth_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthController(),
      fenix: true,
    );
  }
}
