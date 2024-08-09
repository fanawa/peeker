import 'package:get/get.dart';
import 'package:peeker/service/manage_tab_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ManageTabService(),
    );
  }
}
