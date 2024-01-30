import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idz/routes/app_pages.dart';
import 'package:idz/service/manage_tab_service.dart';
import 'package:idz/utils/platform_information.dart';

class TopPageController extends GetxController {
  TopPageController();
  final ManageTabService manageTabService = Get.find<ManageTabService>();

  RxInt currentIndex = RxInt(0);
  RxInt previousIndex = RxInt(0);
  Rx<int> previousRoute = 0.obs;

  final List<String> pages = NavManager.ALL_NAV_ROUTES;
  late List<String> currentRoutes = List<String>.from(pages);
  RxList<bool> check = RxList<bool>.filled(2, false);

  @override
  Future<void> onInit() async {
    check[0] = true;
    // changeIndex(NavManager.getNavigationRouteId(Routes.HOME));

    final String deviceId = await PlatformInfo.getDeviceId();
    debugPrint('deviceId: $deviceId');

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    manageTabService.currentIndex.listen((int index) {
      if (currentIndex.value == index) {
        return;
      }
      // タブ切り替え前に現在表示しているRouteを記憶する。
      currentRoutes[currentIndex.value] = Get.currentRoute;

      currentIndex.value = 0;
      check[0] = true;
      Get.offAllNamed<void>(pages[0]);
      currentRoutes[0] = pages[0];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // タブ切り替え後、記憶していた前回のタブのRouteを復元する。
        Get.rootController.routing.update((Routing value) {
          value.current = currentRoutes[0];
        });
      });
    });
  }

  int getHomeIndex() {
    return NavManager.ALL_NAV_ROUTES.indexOf(Routes.HOME);
  }

  /// タブ切り替え時の処理
  void changeIndex(int index, {bool forceGetLatestInfo = false}) {
    // タブ切り替え前に現在表示しているRouteを記憶する。
    currentRoutes[currentIndex.value] = Get.currentRoute;
    check[index] = true;
    if (currentIndex.value == index) {
      Get.offAllNamed<void>(pages[index]);
      currentRoutes[index] = pages[index];
    }
    currentIndex.value = index;
    manageTabService.currentIndex.value = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // タブ切り替え後、記憶していた前回のタブのRouteを復元する。
      Get.rootController.routing.update((Routing value) {
        value.current = currentRoutes[index];
      });
    });
  }
}
